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
