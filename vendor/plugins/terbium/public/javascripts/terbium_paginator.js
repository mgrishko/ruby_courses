

var Paginator = function(id, current_page, pages_count, url, options) {
  options = options || {}
  this.pages_count = pages_count
  this.current_page = current_page
  this.url = url
  this.paginator = document.getElementById(id)
  var nextPage = current_page + 1 > pages_count ? '' : url + (current_page + 1)
  nextPage = nextPage == '' ? (options['next'] || "Next") + " &rarr;" : "<a href=\"" + nextPage + "\">" + (options['next'] || "Next") + " &rarr;</a>"
  var prevPage = current_page == 1 ? '' : url + (current_page - 1)
  prevPage = prevPage == '' ? "&larr; " + (options['prev'] || "Previous") : "<a href=\"" + prevPage + "\">&larr; " + (options['prev'] || "Previous") + "</a>"
  var lastPage = current_page == pages_count ? '' : url + pages_count
  lastPage = lastPage == '' ? (options['last'] || "last") : "<a href=\"" + lastPage + "\">" + (options['last'] || "last") + "</a>"
  var firstPage = current_page == 1 ? '' : url + 1
  firstPage = firstPage == '' ? (options['first'] || "first") : "<a href=\"" + firstPage + "\">" + (options['first'] || "first") + "</a>"

  this.page_width = 50
  
  this.paginator.innerHTML = "<div class=\"wrap\"> \
    <div class=\"left\"> \
      <div class=\"prev\">" + prevPage + "</a></div> \
      <div class=\"first\">" + firstPage + "</div> \
    </div> \
    <ul> \
    </ul> \
    <div class=\"scroll\"> \
      <div class=\"track\"> \
	<div class=\"pointer\"></div> \
      </div> \
      <div class=\"mark\"></div> \
    </div> \
    <div class=\"right\"> \
      <div class=\"next\">" + nextPage + "</div> \
      <div class=\"last\">" + lastPage + "</div> \
    </div> \
  </div>"

  this.pages = this.paginator.getElementsByTagName('ul')[0]
  this.scroller = getElementsByClass('scroll', this.paginator, 'div')[0]
  this.mark = getElementsByClass('mark', this.scroller, 'div')[0]
  this.track = getElementsByClass('track', this.scroller, 'div')[0]
  this.pointer = getElementsByClass('pointer', this.track, 'div')[0]

  this.setup()
  this.register()
  this.scrollToPage(current_page)
}

Paginator.prototype.setup = function(id) {
  this.pages_show = Math.floor(this.pages.offsetWidth / this.page_width)
  this.track.style.width = Math.round(this.scroller.offsetWidth * this.pages_show / this.pages_count) + 'px'
  if (this.track.offsetWidth < 6) {
    this.track.style.width = '6px'
  }
  if (this.track.offsetWidth >= this.scroller.offsetWidth) {
    this.track.style.display = 'none'
  } else {
    this.track.style.display = 'block'
  }
  this.mark.style.left = Math.round((this.scroller.offsetWidth - this.mark.offsetWidth) * (this.current_page - 1) / (this.pages_count - 1)) + 'px'
  if (this.mark.offsetLeft < 0) {
    this.mark.style.left = '0px'
  }
  if (this.mark.offsetLeft > this.scroller.offsetWidth - this.mark.offsetWidth) {
    this.mark.style.left = this.scroller.offsetWidth - this.mark.offsetWidth + 'px'
  }
}

Paginator.prototype.redrawPages = function(page) {
  this.shown_page = page || Math.round(this.track.offsetLeft * (this.pages_count - 1) / (this.scroller.offsetWidth - this.track.offsetWidth))
  var s = 0
  var e = 0
  if (this.pages_show >= this.pages_count) {
    s = 1
    e = this.pages_count
  } else {
    s = this.shown_page - Math.floor(this.pages_show/2)
    e = s + this.pages_show + 1
    if (s < 1) {
      s = 1
      e = this.pages_show
    }
    if (e > this.pages_count) {
      s = this.pages_count - this.pages_show + 1
      e = this.pages_count
    }
  }
  
  var list = ''
  for (var i = s; i <= e; i++) {
    if (i == this.current_page) {
      list += '<li class="current"><span>' + i + '</span></li>'
    } else {
      list += '<li><a href="' + this.url + i + '">' + i + '</a></li>'
    }
  }
  this.pages.innerHTML = list
}

Paginator.prototype.scrollToPage = function(page) {
  if (page < 1) { page = 1 }
  if (page > this.pages_count) { page = this.pages_count }
  this.setTrackPosition((this.scroller.offsetWidth - this.track.offsetWidth) * (page - 1) / (this.pages_count - 1))
  this.redrawPages(page)
}

Paginator.prototype.setTrackPosition = function(position) {
  if (typeof position == "number") {
    this.track.style.left = position + 'px'
    if (this.track.offsetLeft < 0) { this.track.style.left = '0px'}
    if (this.track.offsetLeft > this.scroller.offsetWidth - this.track.offsetWidth) { this.track.style.left = this.scroller.offsetWidth - this.track.offsetWidth + 'px'}
    this.redrawPages()
  }
}

Paginator.prototype.register = function() {
  var scroller = this.scroller
  var track = this.track
  var _this = this

  addEvent(this.pointer, 'mousedown', function(e) {
    track.drag = true
    var e = e || window.event
    track.cx = e.clientX
    stop(e)
  })

  addEvent(this.scroller, 'mousedown', function(e) {
    track.drag = true
    var e = e || window.event
    track.cx = e.clientX
    _this.setTrackPosition(track.offsetLeft + (getMousePosition(e).x - getPageX(track)) - track.offsetWidth/2)
  })

  addEvent(document, 'mousemove', function(e) {
    var e = e || window.event
    if (track.drag) {
      var delta = track.cx - e.clientX
      if ((delta < 0 && getMousePosition(e).x > getPageX(scroller) + track.offsetWidth/2) 
	  || (delta > 0 && getMousePosition(e).x < getPageX(scroller) + scroller.offsetWidth - track.offsetWidth/2)) {
	_this.setTrackPosition(track.offsetLeft - delta)
      }
      track.cx = e.clientX
    }
    return false
  })

  addEvent(document, 'mouseup', function() {
    track.drag = false
  })

  function wheel(e) {
    var e = e || window.event
    var delta;
    if(e.wheelDelta)
      delta = e.wheelDelta / 120;
    else if (e.detail)
      delta =- e.detail / 3;
    if(!delta)
      return;
    _this.scrollToPage(Math.floor(_this.shown_page + delta * _this.pages_show / 2))
    stop(e)
    return false
  }
  addEvent(this.paginator, 'mousewheel', wheel)
  addEvent(this.paginator, 'DOMMouseScroll', wheel)

}

function getElementsByClass(searchClass,node,tag) {
  if (node.getElementsByClassName) {
    return node.getElementsByClassName(searchClass)
  } else {
    var classElements = new Array();
    if ( node == null )
        node = document;
    if ( tag == null )
        tag = '*';
    var els = node.getElementsByTagName(tag);
    var elsLen = els.length;
    var pattern = new RegExp('(^|\\\\s)'+searchClass+'(\\\\s|$)');
    for (i = 0, j = 0; i < elsLen; i++) {
        if ( pattern.test(els[i].className) ) {
            classElements[j] = els[i];
            j++;
        }
    }
    return classElements;
  }
}

function addEvent(obj, evt, fn) {
  if (obj.addEventListener)
    obj.addEventListener(evt, fn, false);
  else if (obj.attachEvent)
    obj.attachEvent('on'+evt, fn);
}

function getPageX( oElement ) {
	var iPosX = oElement.offsetLeft;
	while ( oElement.offsetParent != null ) {
		oElement = oElement.offsetParent;
		iPosX += oElement.offsetLeft;
		if (oElement.tagName == 'BODY') break;
	}
	return iPosX;
}

function getMousePosition(e) {
	if (e.pageX || e.pageY){
		var posX = e.pageX;
		var posY = e.pageY;
	}else if (e.clientX || e.clientY) 	{
		var posX = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
		var posY = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
	}
	return {x:posX, y:posY}	
}

function stop(e) {
  e.cancelBubble = true
  if (e.stopPropagation) {
    e.stopPropagation() 
  }
}