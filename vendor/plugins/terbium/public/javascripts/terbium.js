Event.addBehavior.reassignAfterAjax = true;

Event.onReady(function() {
  Event.addBehavior({'*[terbium_popup]:click': show_terbium_popup});
  Event.addBehavior({'*[terbium_popup_close]:click': hide_terbium_popup});
  Event.addBehavior({'a[ajax]:click': terbium_ajax_request});
  Event.addBehavior({'input[ajax]:click': terbium_check_request});
  Event.addBehavior({'form[ajax]:submit': terbium_ajax_submit});
});

function show_terbium_popup(event) {
  Event.stop(event);
  new TerbiumPopup(this.readAttribute('terbium_popup'), {
    parameters: {'ids[]': eval(this.readAttribute('ids'))}
  });
}

function hide_terbium_popup(event) {
  Event.stop(event);
  this.up('.terbium_popup', 0).popup.hide();
}

function terbium_ajax_request(event) {
  Event.stop(event);
  new Ajax.Request(this.readAttribute('ajax'), {
    parameters: {'ids[]': eval(this.readAttribute('ids'))},
    asynchronous: true,
    evalScripts: false
  });
}

function terbium_check_request(event) {
  Event.stop(event);
  new Ajax.Request(this.readAttribute('ajax'), {
    asynchronous: true,
    evalScripts: false
  });
}

function terbium_ajax_submit(event) {
  Event.stop(event);
  new Ajax.Request(this.readAttribute('ajax'), {
    parameters: Form.serialize(this) + '&' + Object.toQueryString({'ids[]': eval(this.readAttribute('ids'))}),
    asynchronous: true,
    evalScripts: false
  });
}
