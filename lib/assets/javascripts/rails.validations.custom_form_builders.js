clientSideValidations.formBuilders['SimpleForm::FormBuilder'] = {
	add: function(element, settings, message) {
		if (element.data('valid') !== false) {
			var wrapper = element.closest("div.clearfix");
			wrapper.addClass("error");
			var input_wrapper = element.closest("div.input");
			var errorElement = $('<span' + ' class="help-inline">' + message + '</span>');
			input_wrapper.append(errorElement);
		} else {
			element.parent().find(settings.error_tag + '.' + settings.error_class).text(message);
		}
	},
	remove: function(element, settings) {
		var wrapper = element.closest("div.clearfix");
		wrapper.removeClass("error");
		var input_wrapper = element.closest("div.input");
		var errorElement = input_wrapper.find('span.help-inline');
		errorElement.remove();
	}
}

clientSideValidations.validators.local.numericality = function(element, options) {
   if (!/^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d*)?$/.test(element.val()) && element.val() != '') {
     return options.messages.numericality;
   }

   if (options.only_integer && !/^[+-]?\d+$/.test(element.val())) {
     return options.messages.only_integer;
   }

   var CHECKS = { greater_than: '>', greater_than_or_equal_to: '>=',
     equal_to: '==', less_than: '<', less_than_or_equal_to: '<=' }

   for (var check in CHECKS) {
     var comparedValue = options[check];

		if (typeof options[check] == "string" && !$.isNumeric(options[check])){
			var elementName = $(element).attr("name");
			var comparedElementName = elementName.substring(0, elementName.lastIndexOf('[')) + "[" + options[check] + "]";
			var i = $("input[name*='" + comparedElementName + "']");
			var v = i.val();
			if (typeof(v) != "undefined") { comparedValue = parseInt(v); }
		}

		if (options[check] != undefined && element.val() != "" && !(new Function("return " + element.val() + CHECKS[check] + comparedValue)())) {
       return options.messages[check];
     }
   }

   if (options.odd && !(parseInt(element.val()) % 2)) {
     return options.messages.odd;
   }

   if (options.even && (parseInt(element.val()) % 2)) {
     return options.messages.even;
   }
 }