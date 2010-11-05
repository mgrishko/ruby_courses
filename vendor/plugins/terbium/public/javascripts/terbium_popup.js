var TerbiumPopup = Class.create({

  initialize: function(content, options) {
    this.options = options || {};
    this.options.parameters = this.options.parameters || {}
    this.popup = this.getPopup(content);
    this.popup.popup = this;
    this.show();
  },

  getPopup: function(content) {
    var popup_element = new Element('div', {className: 'terbium_popup', id: 'terbium_popup'});

    var _this = this;
    new Ajax.Request(content, {
      parameters: _this.options.parameters,
      asynchronous: true,
      evalScripts: false,
      onFailure: function(response) {
        _this.hide();
      }
    });
    return popup_element
  },

  show: function() {
    this.popup.hide();
    $(document.body).appendChild(this.popup);
    new Effect.Appear(this.popup, { duration: 0.5 });
  },

  hide: function(message) {
    new Effect.Fade(this.popup, {
      duration: 0.5,
      afterFinish: function(effect) {
        effect.element.remove();
      }
    });
  }

});
