function setHeights() {
  $$('#items .item').each(function(element){
    element.setStyle({minHeight: ''});
  });
  /*$$('#items .item').each(function(element){
    if (!element.up('li').hasClassName('new')) {
      element.setStyle({minHeight: element.up('li').getHeight() - 10 + 'px'});
    }
  });*/
}

Event.observe(window, 'load', setHeights);

Ajax.Responders.register({onComplete: setHeights});

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
$j(function() {
  $j("#tab-1").show();
  return false;
});

function subscription(that, supplier_id) {
  $j.post('/subscriptions/status', {id: supplier_id}, function(data) {
    if (data.error) {
      alert(data.error);
    } else {
      $j(that).html(data.text);
      if (data.flag) {
	$j('#tr-'+supplier_id).addClass('subscribed');
      } else {
	$j('#tr-'+supplier_id).removeClass('subscribed');
      }
    }
  }, "json");
}
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

function classifierSelect(li){
  var lis = $j("li", "#groups");
  if (!lis[0]) return;
  lis.removeClass("ac_over");
  $j(li).addClass("ac_over");
}

function selectCountry(li){
  var lis = $j("li", "#countries_results");
  if (!lis[0]) return;
  lis.removeClass("ac_liselected");
  $j(li).addClass("ac_liselected");
  selected_li = lis[active];
}

function selectCountryItem(li){
  var li = $j("li.ac_liselected", "#countries_results")[0];
  if (li){
    $j("#country_link").html(li.innerHTML);
    $j("#country_value").val(li.innerHTML);
    hideCountriesNow();
  }
}

function selectClassifierGroup(li){
  $j("#categories").html("");
  var lis = $j("li", "#groups");
  lis.removeClass("ac_liselected");
  $j(li).addClass("ac_liselected");
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
    $j("li", ".cases_results").removeClass("ac_loading");
    $j(".cases_man").html(data);
  }
};