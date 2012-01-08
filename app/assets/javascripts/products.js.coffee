$(document).ready ->
  groupedValidators = {}
  validators = window[$("form[data-validate]").attr('id')].validators;
  
  #rebindGroupValidators = (elem) ->
  #  group = $(elem).attr("data-validate-presence-group")
  #  groupInputs = $("input[data-validate-presence-group*='" + group + "']")
  #  allEmpty = true
  #  groupInputs.each (i, elem) -> allEmpty = false if $(elem).val()
    
  #  rebindInputValidator = (input) ->
  #    inputName = input.removeData('changed').attr("name")
  #    if allEmpty
  #      input.removeData('valid')
  #      delete validators[inputName] if validators.hasOwnProperty(inputName)
  #      clientSideValidations.formBuilders['SimpleForm::FormBuilder'].remove(input)
  #    else
  #      validators[inputName] = groupedValidators[group][inputName]
    
  #  groupInputs.each () -> rebindInputValidator($(this))
  
  #$("input[data-validate-presence-group]").each () ->
  #  input = $(this)
  #  inputName = input.attr("name")
  #  group = input.attr("data-validate-presence-group")
  #  groupedValidators[group] = {} unless groupedValidators[group]
  #  groupedValidators[group][inputName] = validators[inputName]
  #  delete validators[inputName]
    
  #$("input[data-validate-presence-group]").on("keyup blur", () -> rebindGroupValidators(this))
  
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
