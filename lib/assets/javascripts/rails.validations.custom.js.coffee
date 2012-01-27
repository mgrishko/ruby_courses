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
  
  $('input[data-require-in-group*=true]').each () ->
    input = $(this)
    inputName = input.attr("name")
    prefix = inputName.substring(0, inputName.lastIndexOf('['))
    shortName = inputName.substring(inputName.lastIndexOf('[') + 1, inputName.lastIndexOf(']'))
    groups[prefix] = [] unless groups[prefix]
    groups[prefix].push(shortName) unless shortName in groups[prefix]
  
  $('input[data-require-in-group*=true]').each () ->
    input = $(this)
    inputName = input.attr("name")
    prefix = inputName.substring(0, inputName.lastIndexOf('['))
    names = groups[prefix].join(" ")
    input.attr("data-validate-with", names).attr("data-validate-require", names)

$(document).ready ->
  validators = window[$("form[data-validate]").attr('id')].validators;

  # Remove presence validators
  deletePresenceValidator = (inputName) -> 
    if validators[inputName]?.presence?
      delete validators[inputName].presence
      
  $("input.optional").each () ->
    deletePresenceValidator($(this).attr("name"))
  
  setupRequiredInGroupFields()
  
  makeLinkedInputNameList = (elem) ->
    input = $(elem)
    inputName = input.attr("name")
    resultNames = [inputName]
    prefix = inputName.substring(0, inputName.lastIndexOf('['))
    for name in input.attr("data-validate-with").split(" ")
      resultNames.push("#{prefix}[#{name}]")
    resultNames

  # Setup fields that are validated if another field is filled in
  $("input[data-validate-with]").on "keyup blur", () ->
    for name in makeLinkedInputNameList(this)
      $("input[name*='" + name + "']").each () -> 
        $(this).removeData('changed').isValid(validators)

  # Setup fields that are required if another field is not empty
  $("input[data-validate-require]").on "keyup blur", () ->
      names = makeLinkedInputNameList(this)

      allEmpty = true
      for name in names
        if $("input[name*='" + name + "']").val()
          allEmpty = false

      for name in names
        linkedInput = $("input[name*='" + name + "']")

        if allEmpty
          linkedInput.removeData('valid')
          deletePresenceValidator(name)
        else
          validators[name] = {} unless validators[name]
          validators[name].presence = message: I18n.t('errors.messages.blank')

        linkedInput.removeData('changed').isValid(validators)  