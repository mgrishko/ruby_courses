// функции "упаковать"
var packageMe = function(bi_id){
  $j.getScript('/base_items/'+bi_id+'/packaging_items/new', function() {});
  return false;
};
var packageMeWithSub = function(bi_id,iid){
  $j.getScript('/base_items/'+bi_id+'/packaging_items/' + iid + '/new_sub/', function() {});
  return false;
};
var cancelEditButton = function(path){
  $j.getScript(path, function() {});
  return false;
};

var cancelPackageMeWithSub = function(bi_id){
  $j.getScript('/base_items/'+bi_id+'/packaging_items/', function() {});
  return false;
};

var acceptOrCancelSR =function(sr, action, event){
  event.stopPropagation();
  $j.getScript('/subscription_results/update_one/'+sr+'?'+action+'=yes', function() {});
  return false;
};

function setHeights() {
  $j('#items .item').each(function(element){
    element.setStyle({minHeight: ''});
  });
  /*$$('#items .item').each(function(element){
    if (!element.up('li').hasClassName('new')) {
      element.setStyle({minHeight: element.up('li').getHeight() - 10 + 'px'});
    }
  });*/
}

//Event.observe(window, 'load', setHeights);

//Ajax.Responders.register({onComplete: setHeights});

//
var _GT = {};
function toggleTab() {
  if (_GT['toogleTab']) {
    delete _GT['toogleTab'];
    $j("#button").html('Продолжить');
    showTab(1);
  } else {
    _GT['toogleTab'] = 2;
    $j("#button").html('Назад');
    showTab(2);
  }
  return false;
}

function showTab(tab) {
  $j(".tab").hide();
  $j("#tab-"+tab).show();
  return false;
}
$(function(){
  $j("#search-form-input").blur(function() {
    $j(this).css('color', '#CCC');
    if ((this.value == '') || (this.value == 'Search')) {
      this.value = 'Search'
      $j("#search-clear").addClass('search-clear-inactive');
    }
  });
  $j("#search-form-input").focus(function() {
    $j(this).css('color', '#000');
    if (this.value == 'Search') {
      this.value = '';
    }
  });
  $j("#search-form-input").keyup(function() {
    if ($j("#search-form-input").val().length > 0) {
       $j("#search-clear").removeClass('search-clear-inactive');
      $j("#search-clear").addClass('search-clear-active');
    } else {
      $j("#search-clear").removeClass('search-clear-active');
      $j("#search-clear").addClass('search-clear-inactive');
    }
  });
  $j(".bi").hover(function() {
    $j(this).addClass("hovered");
  },
  function() {
    $j(this).removeClass("hovered");
  });
  $j(".cm").hover(function() {
    $j(this).find(".actions").show();
  },
  function() {
    $j(this).find(".actions").hide();
  });
  hovers();
  return false;
});
function hovers() {
  bi_hover(); //base_items
  cm_hover(); //comments
}
function bi_hover() {
  $j(".bi").hover(function() {
    $j(this).addClass("hovered");
  },
  function() {
    $j(this).removeClass("hovered");
  });
}
function cm_hover() {
  $j(".cm").hover(function() {
    $j(this).find(".actions").show();
  },
  function() {
    $j(this).find(".actions").hide();
  });
}

// further undone

function subscription(event, that, supplier_id) {
  event.stopPropagation();
  $j.post('/subscriptions/status', {id: supplier_id}, function(data) {
    if (data.error) {
      alert(data.error);
    } else {
      $j(that).html(data.text);
      if (data.flag) {
	      $j('#bi-'+supplier_id).addClass('subscribed');
      } else {
	      $j('#bi-'+supplier_id).removeClass('subscribed');
      }
    }
  }, "json");
  return false;
}
//$j(function() {
// $j("#tab-1").show();

//  $j('body').click(function(e){
//  e.stopPropagation();
//  //DO SOMETHING
//  });
//  return false;
//});

function instantSubscription(that, supplier_id) {
  $j.post('/subscriptions/instantstatus', {id: supplier_id}, function(data) {
    if (data.error) {
      alert(data.error);
    } else {
      $j(that).html(data.text);
      $j(that).attr('disabled','disabled');
      $j('#bs-'+supplier_id).html('Отписаться');
    }
  })
}

function check_pallete(emitter) {
  if ($j(emitter).val() == 'PX') {
    $j(emitter).parent().parent().addClass('pl');
    $j(".pallet").show();
  } else {
    $j(emitter).parent().parent().removeClass('pl');
    $j(".pallet").hide();
  }
}

// Function to submit receivers when private = true
function submitReceiver(suffix) {
  if (!suffix) {
    suffix = '';
  }
  $j("#receiver_gln").val($j("#new_receiver_input"+suffix).val());
  $j("#new_receiver").submit();
  return false;
}

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var active = -1;
var selected_li = null;
var timeout = null;

function findCountryPos(obj) {
  var curleft = obj.offsetLeft || 0;
  var curtop = obj.offsetTop || 0;
  while (obj = obj.offsetParent) {
    curleft += obj.offsetLeft;
    curtop += obj.offsetTop;
  }
  return {x:curleft, y:curtop};
}
/*
function classifierSelect(li){
  var lis = $j("li", "#groups");
  if (!lis[0]) return;
  lis.removeClass("ac_over");
  $j(li).addClass("ac_over");
}


function selectClassifierGroup(li){
  $j("#categories").html("");
  var lis = $j("li", "#groups");
//  lis.removeClass("ac_liselected");
//  $j(li).addClass("ac_liselected");
  requestSubgroupsData($j(li).attr("id"));
}

function selectClassifierSubgroup(li){
  var lis = $j("li", "#subgroups");
  lis.removeClass("ac_liselected");
  $j(li).addClass("ac_liselected");
  requestCategoriesData($j(li).attr("id"));
};

function selectClassifierCategory(li){
  var lis = $j("li", "#categories");
  lis.removeClass("ac_liselected");
  $j(li).addClass("ac_liselected");
}


function selectClassifierItem(li){
  var li = $j("li.ac_liselected", "#categories")[0];
  if (li){
    $j("#classifier_link").html(li.innerHTML);
    $j("#classifier_value").val($j(li).html());
    hideClassifierNow();
  }
}
*/
function requestCategoriesData(q){
  var data = null;
  $j.get("/main/categories/" + q, function(data) {
    receiveCategoriesData(data);
  });
}

function receiveCategoriesData(data) {
  if (data) {
    $j("li", "#subgroups").removeClass("ac_loading");
    $j("#categories").html(data);
  }
};


function requestSubgroupsData(q){
  var data = null;
  $j.get("/main/subgroups/" + q, function(data) {
    receiveSubgroupsData(data);
  });
}

function receiveSubgroupsData(data) {
  if (data) {
    $j("li", "#groups").removeClass("ac_loading");
    $j("#subgroups").html(data);
  }
};


function hideResults() {
  if (timeout) clearTimeout(timeout);
  timeout = setTimeout(hideResultsNow, 500);
};

function hideCountriesNow() {
	var lis = $j("li", "#countries");
  lis.removeClass("ac_liselected")
	$j("#countries").hide();
  $j('#hidden_div').hide();
};

function hideClassifierNow(){
  var lis = $j("li", "#classifier");
  lis.removeClass("ac_liselected")
  $j("#subgroups").html("");
  $j("#categories").html("");
  if (timeout) clearTimeout(timeout);
  if ($j("#classifier").is(":visible")) {
    $j("#classifier").hide();
  }
  $j('#hidden_div').hide();
}

// cases

function casesSelect(li){
  var lis = $j("li", ".cases_results");
  if (!lis[0]) return;
  lis.removeClass("ac_liselected");
  lis.removeClass("ac_over");
  lis.removeClass("ac_loading");
  $j(li).addClass("ac_liselected");
  selected_li = lis[active];
  $j(li).addClass("ac_loading");
  requestManData($j(li).attr("id"));
}

function selectCasesItem(li){
  var li = $j("li.ac_liselected", ".cases_results")[0];
  if (li){
    $j("#cases_link").html(li.innerHTML);
    $j("#cases_value").val($j(li).attr("id"));
    hideResultsNow();
  }
}

function requestManData(q){
  var data = null;
  $j.get("/main/show_man/" + q, function(data) {
    receiveManData(data);
  });
}

function receiveManData(data) {
  if (data) {
    $j(".pic-cont").html(data.split('<br>')[0]);
    $j(".remark").html(data.split('<br>')[1]);
  }
};

