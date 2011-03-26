function setHeights() {
  $$('#items .item').each(function(element){
    element.setStyle({minHeight: ''});
  });
  $$('#items .item').each(function(element){
    if (!element.up('li').hasClassName('new')) {
      element.setStyle({minHeight: element.up('li').getHeight() - 10 + 'px'});
    }
  });
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
