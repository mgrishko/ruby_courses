clientSideValidations.validators.local['gtin_format'] = (element, options) ->
  #6291041500213 - valid GTIN
  value = $(element).val()
  return options.message unless value.length in [0, 8, 12, 13, 14]
  digits = (parseInt(c) for c in value.rjust(18, "0").split(''))
  sum = digits.pop()

  index = 0
  for item in digits
    even = index++ % 2 == 0
    sum += if even then item * 3 else item
  
  return options.message if sum % 10 > 0

$(document).ready ->
  validators = window[$("form[data-validate]").attr('id')].validators;

  deletePresenceValidator = (inputName) -> 
    delete validators[inputName].presence if validators[inputName]?.presence?

  $("input.optional").each () -> deletePresenceValidator($(this).attr("name"))

  makeLinkedInputNameList = (elem) ->
    input = $(elem)
    inputName = input.attr("name")
    resultNames = [inputName]
    prefix = inputName.substring(0, inputName.lastIndexOf('['))
    resultNames.push("#{prefix}[#{name}]") for name in input.attr("data-validate-with").split(" ")
    resultNames

  $("input[data-validate-with]").on "keyup blur", () ->
    for name in makeLinkedInputNameList(this)
      $("input[name*='" + name + "']").each () -> 
        $(this).removeData('changed').isValid(validators)

  $("input[data-validate-require]").on "keyup blur", () ->
      names = makeLinkedInputNameList(this)

      allEmpty = true
      for name in names
        allEmpty = false if $("input[name*='" + name + "']").val()          

      for name in names
        linkedInput = $("input[name*='" + name + "']")

        if allEmpty
          linkedInput.removeData('valid')
          deletePresenceValidator(name)
        else
          validators[name] = {} unless validators[name]
          validators[name].presence = message: I18n.t('mongoid.errors.messages.blank')

        linkedInput.removeData('changed').isValid(validators)  