clientSideValidations.validators.local['gtin_format'] = (element, options) ->
  value = $(element).val()
  unless value.length in [0, 8, 12, 13, 14]
    return I18n.t("errors.messages.invalid_gtin_format")
  digits = (parseInt(c) for c in value.rjust(18, "0").split(''))
  sum = digits.pop()

  index = 0
  for item in digits
    even = index++ % 2 == 0
    sum += if even then item * 3 else item
  
  if sum % 10 > 0
    return I18n.t("errors.messages.invalid_gtin_format")

# Setup fields required in group
setupRequiredInGroupFields = () ->
  groups = {}
  
  # Collect validation group names
  $('input[data-require-in-group*=true]').each () ->
    input = $(this)
    name = input.attr("name")
    prefix = name.substring(0, name.lastIndexOf('['))
    shortName = name.substring(name.lastIndexOf('[') + 1, name.lastIndexOf(']'))
    groups[prefix] = [] unless groups[prefix]
    groups[prefix].push(shortName) unless shortName in groups[prefix]
  
  # Set 'required' for inputs in validation groups
  $('input[data-require-in-group*=true]').each () ->
    input = $(this)
    name = input.attr("name")
    prefix = name.substring(0, name.lastIndexOf('['))
    names = groups[prefix].join(" ")
    input.attr("data-validate-with", names).attr("data-validate-require", names)


# Overload error rendering for SimpleForm to support Bootstrap layout

clientSideValidations.formBuilders['SimpleForm::FormBuilder'] =
	add: (element, settings, message) ->
		unless element.data('valid')
			wrapper = element.closest("div.clearfix")
			wrapper.addClass("error")
			
			input_wrapper = element.closest("div.input")
			errorElement = input_wrapper.find("span.help-inline")
			
			# Adds error message element or resets its text
			if errorElement.length
			  errorElement.html(message)
			else
			  newErrorElement = $('<span' + ' class="help-inline">' + message + '</span>')
			  input_wrapper.append(newErrorElement)
		else
			element.parent().find(settings.error_tag + '.' + settings.error_class).text(message);

	remove: (element, settings) ->
		wrapper = element.closest("div.clearfix")
		wrapper.removeClass("error")
		
		input_wrapper = element.closest("div.input")
		errorElement = input_wrapper.find('span.help-inline')
		 
		errorElement.remove();

# Overload numericality validator to support comparison with another field value

clientSideValidations.validators.local.numericality = (element, options) ->
  if !/^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d*)?$/.test(element.val()) && element.val()
    return options.messages.numericality

  if options.only_integer && !/^[+-]?\d+$/.test(element.val())
    return options.messages.only_integer
  
  CHECKS = 
    greater_than: '>'
    greater_than_or_equal_to: '>='
    equal_to: '=='
    less_than: '<'
    less_than_or_equal_to: '<='
  
  for check of CHECKS
    comparedValue = options[check]
    
    if (typeof(options[check]) == "string" && !$.isNumeric(options[check]))
      name = $(element).attr("name");
      elemName = name.substring(0, name.lastIndexOf('[')) + "[" + options[check] + "]";
      elemValue = $("input[name*='" + elemName + "']").val();
      comparedValue = parseInt(elemValue) if typeof(elemValue) != "undefined"
      
    if options[check] != undefined && element.val() != ""
      if !(new Function("return " + element.val() + CHECKS[check] + comparedValue)())
        return options.messages[check]
  
  if (options.odd && !(parseInt(element.val()) % 2))
    return options.messages.odd

  if (options.even && (parseInt(element.val()) % 2))
    return options.messages.even

$(document).ready ->
  
  # Trigger field validation on keyup, so the field is validated
  # immediatelly as a user changes its value
  $("form[data-validate]").each () ->
    form = $(this)
    settings = window[form.attr('id')]
    
    onKeyup = (e) ->
      if e.keyCode != 9
        $(this).data('changed', true) 
        $(this).isValid(settings.validators)
    
    form.find('[data-validate]:input:not(:radio)').live('keyup', onKeyup)
  
  return unless $("form[data-validate]").length
  validators = window[$("form[data-validate]").attr('id')].validators;

  # Remove presence validators
  deletePresenceValidator = (inputName) -> 
    if validators[inputName]?.presence?
      delete validators[inputName].presence
      
  $("input.optional").each () ->
    deletePresenceValidator($(this).attr("name"))
  
  setupRequiredInGroupFields()
  
  makeLinkedInputNameList = (elem, includeElem = true) ->
    input = $(elem)
    inputName = input.attr("name")
    resultNames = []
    resultNames.push(inputName) if includeElem
    prefix = inputName.substring(0, inputName.lastIndexOf('['))
    validateWith = input.attr("data-validate-with")
    if validateWith
      for name in validateWith.split(" ")
        resultNames.push("#{prefix}[#{name}]")
    resultNames

  # Setup fields that are validated if another field is filled in
  $("input[data-validate-with]").on "keyup blur", () ->
    for name in makeLinkedInputNameList(this)
      $("input[name*='" + name + "']").each () -> 
        $(this).removeData('changed').isValid(validators)

  # Setup fields that are required if another field is not empty
  $("input[data-validate-require]").on "keyup blur", () ->
      names = makeLinkedInputNameList(this, false)

      allEmpty = true
      for name in names
        if $("input[name*='" + name + "']").val()
          allEmpty = false

      for name in names
        linkedInput = $("input[name*='" + name + "']")

        if (allEmpty && names.length > 1) || (!$(this).val() && names.length == 1)
          linkedInput.removeData('valid')
          deletePresenceValidator(name)
        else
          validators[name] = {} unless validators[name]
          validators[name].presence = message: I18n.t('errors.messages.blank')

        linkedInput.removeData('changed').isValid(validators)  