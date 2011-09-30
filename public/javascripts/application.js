// функции "упаковать"
var packageMe = function(obj,bi_id){
 // $.getScript('/base_items/'+bi_id+'/packaging_items/new', function() {});
  $.get('/base_items/'+bi_id+'/packaging_items/new', {},
    function(data){
      addLeaf(obj, data)
  });

  return false;
};
var packageMeWithSub = function(obj,bi_id,iid){
//  $.getScript('/base_items/'+bi_id+'/packaging_items/' + iid + '/new_sub/', function() {});
  $.get('/base_items/'+bi_id+'/packaging_items/' + iid + '/new_sub/', {},
    function(data){
      addLeaf(obj, data)
    });
  return false;
};
var cancelEditButton = function(path){
  $.getScript(path, function() {});
  return false;
};

var cancelPackageMeWithSub = function(bi_id){
  $.getScript('/base_items/'+bi_id+'/packaging_items/', function() {});
  return false;
};

var acceptOrCancelSR =function(sr, action, event){
  event.stopPropagation();
  $.getScript('/subscription_results/update_one/'+sr+'?'+action+'=yes', function() {});
  return false;
};

function setHeights() {
  $('#items .item').each(function(element){
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
    $("#button").html('Продолжить');
    showTab(1);
  } else {
    _GT['toogleTab'] = 2;
    $("#button").html('Назад');
    showTab(2);
  }
  return false;
}

function showTab(tab) {
  $(".tab").hide();
  $("#tab-"+tab).show();
  return false;
}
$(function(){
  $("#search-form-input").blur(function() {
    $(this).css('color', '#CCC');
    if ((this.value == '') || (this.value == 'Search')) {
      this.value = 'Search'
      $("#search-clear").addClass('search-clear-inactive');
    }
  });
  $("#search-form-input").focus(function() {
    $(this).css('color', '#000');
    if (this.value == 'Search') {
      this.value = '';
    }
  });
  $("#search-form-input").keyup(function() {
    if ($("#search-form-input").val().length > 0) {
       $("#search-clear").removeClass('search-clear-inactive');
      $("#search-clear").addClass('search-clear-active');
    } else {
      $("#search-clear").removeClass('search-clear-active');
      $("#search-clear").addClass('search-clear-inactive');
    }
  });
  $(".bi").hover(function() {
    $(this).addClass("hovered");
  },
  function() {
    $(this).removeClass("hovered");
  });
  $(".cm").hover(function() {
    $(this).find(".actions").show();
  },
  function() {
    $(this).find(".actions").hide();
  });
  hovers();
  return false;
});
function hovers() {
  bi_hover(); //base_items
  cm_hover(); //comments
}
function bi_hover() {
  $(".bi").hover(function() {
    $(this).addClass("hovered");
  },
  function() {
    $(this).removeClass("hovered");
  });
}
function cm_hover() {
  $(".cm").hover(function() {
    $(this).find(".actions").show();
  },
  function() {
    $(this).find(".actions").hide();
  });
}

// further undone

/* Subscription page */
function subscription(event, that, supplier_id) {
  event.stopPropagation();
  $.post('/subscriptions/status', {id: supplier_id}, function(data) {
    if (data.error) {
      alert(data.error);
    } else {
      $(that).html(data.text);
      if (data.flag) {
	      $('#bi-'+supplier_id).addClass('subscribed');
      } else {
	      $('#bi-'+supplier_id).removeClass('subscribed');
      }
    }
    $(that).parent().parent().find('.loader').remove();
  }, "json");
  return false;
}

$(document).ready(function(){
  $('.export.subscribe').click(function(event){
    id = $(this).attr('id').split('-')[1];
    $(this).parent().before("<img src='/images/autocomplete_indicator.gif' class='fright loader'/>");
    subscription(event, this, id);
    return false;
  });
});

/* END Subscription page */
//$(function() {
// $("#tab-1").show();

//  $('body').click(function(e){
//  e.stopPropagation();
//  //DO SOMETHING
//  });
//  return false;
//});

function instantSubscription(that, supplier_id) {
  $.post('/subscriptions/instantstatus', {id: supplier_id}, function(data) {
    if (data.error) {
      alert(data.error);
    } else {
      $(that).html(data.text);
      $(that).attr('disabled','disabled');
      $('#bs-'+supplier_id).html('Отписаться');
    }
  })
}

function check_pallete(emitter) {
  if ($(emitter).val() == 'PX') {
    $(emitter).parent().parent().addClass('pl');
    $(".pallet").show();
  } else {
    $(emitter).parent().parent().removeClass('pl');
    $(".pallet").hide();
  }
}

// Function to submit receivers when private = true
function submitReceiver(suffix) {
  if (!suffix) {
    suffix = '';
  }
  $("#receiver_gln").val($("#new_receiver_input"+suffix).val());
  $("#new_receiver").submit();
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
  var lis = $("li", "#groups");
  if (!lis[0]) return;
  lis.removeClass("ac_over");
  $(li).addClass("ac_over");
}


function selectClassifierGroup(li){
  $("#categories").html("");
  var lis = $("li", "#groups");
//  lis.removeClass("ac_liselected");
//  $(li).addClass("ac_liselected");
  requestSubgroupsData($(li).attr("id"));
}

function selectClassifierSubgroup(li){
  var lis = $("li", "#subgroups");
  lis.removeClass("ac_liselected");
  $(li).addClass("ac_liselected");
  requestCategoriesData($(li).attr("id"));
};

function selectClassifierCategory(li){
  var lis = $("li", "#categories");
  lis.removeClass("ac_liselected");
  $(li).addClass("ac_liselected");
}


function selectClassifierItem(li){
  var li = $("li.ac_liselected", "#categories")[0];
  if (li){
    $("#classifier_link").html(li.innerHTML);
    $("#classifier_value").val($(li).html());
    hideClassifierNow();
  }
}
*/
function requestCategoriesData(q){
  var data = null;
  $.get("/main/categories/" + q, function(data) {
    receiveCategoriesData(data);
  });
}

function receiveCategoriesData(data) {
  if (data) {
    $("li", "#subgroups").removeClass("ac_loading");
    $("#categories").html(data);
  }
};

function requestDefinitionData(q){
  var data = null;
  if (isInt(q)) {
    $.get("/main/definition/" + q, function(data) {
      receiveDefinitionData(data);
    });
  };
}

function isInt(n) {
   return n % 1 == 0;
}

function receiveDefinitionData(data) {
  if (data) {
    $("li", "#categories").removeClass("ac_loading");
    $("#definition").html(data);
  }
};


function requestSubgroupsData(q){
  var data = null;
  $.get("/main/subgroups/" + q, function(data) {
    receiveSubgroupsData(data);
  });
}

function receiveSubgroupsData(data) {
  if (data) {
    $("li", "#groups").removeClass("ac_loading");
    $("#subgroups").html(data);
  }
};


function hideResults() {
  if (timeout) clearTimeout(timeout);
  timeout = setTimeout(hideResultsNow, 500);
};

function hideCountriesNow() {
	var lis = $("li", "#countries");
  lis.removeClass("ac_liselected")
	$("#countries").hide();
  $('#hidden_div').hide();
};

function hideClassifierNow(){
  var lis = $("li", "#classifier");
  lis.removeClass("ac_liselected")
  $("#subgroups").html("");
  $("#categories").html("");
  if (timeout) clearTimeout(timeout);
  if ($("#classifier").is(":visible")) {
    $("#classifier").hide();
  }
  $('#hidden_div').hide();
}

// cases

function casesSelect(li){
  var lis = $("li", ".cases_results");
  if (!lis[0]) return;
  lis.removeClass("ac_liselected");
  lis.removeClass("ac_over");
  lis.removeClass("ac_loading");
  $(li).addClass("ac_liselected");
  selected_li = lis[active];
  $(li).addClass("ac_loading");
  requestManData($(li).attr("id"));
}

function selectCasesItem(li){
  var li = $("li.ac_liselected", ".cases_results")[0];
  if (li){
    $("#cases_link").html(li.innerHTML);
    $("#cases_value").val($(li).attr("id"));
    hideResultsNow();
  }
}

function requestManData(q){
  var data = null;
  $.get("/main/show_man/" + q, function(data) {
    receiveManData(data);
  });
}

function receiveManData(data) {
  if (data) {
    $(".pic-cont").html(data.split('<br>')[0]);
    $(".remark").html(data.split('<br>')[1]);
  }
};

//$(document).ready(function() {
  //$('div.cm-child:nth-child(odd)').addClass('odd');
//})

