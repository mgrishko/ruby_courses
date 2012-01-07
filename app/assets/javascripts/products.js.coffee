class ProductValidator
  constructor: () ->
    groupedInputValidators = {}
    validators = window[$("form[data-validate]").attr('id')].validators;
    
    rebindGroupValidators = (group) ->
      groupInputs = $("input[data-validate-presence-group*='" + group + "']")
      enableValidation = true
      groupInputs.each (i, elem) -> enableValidation = false if $(elem).val()
      
      groupInputs.each (i, elem) ->
        input = $(elem)
        inputName = input.removeData('changed').attr("name")
        if enableValidation
          input.removeData('valid')
          delete validators[inputName] if validators.hasOwnProperty(inputName)
          clientSideValidations.formBuilders['SimpleForm::FormBuilder'].remove(input)
        else
          validators[inputName] = groupedInputValidators[group][inputName]
    
    $("input[data-validate-presence-group]").each (i, elem) ->
      input = $(elem)
      inputName = input.attr("name")
      group = input.attr("data-validate-presence-group")
      groupedInputValidators[group] = {} unless groupedInputValidators[group]
      groupedInputValidators[group][inputName] = validators[inputName]
      delete validators[inputName]
      
      input.on "keyup", () -> rebindGroupValidators($(this).attr("data-validate-presence-group"))
      input.on "blur", () -> rebindGroupValidators($(this).attr("data-validate-presence-group"))
    
    callGroupValidators = (group) ->
      $("input[data-validate-with*='" + group + "']").each (i, elem) ->
        $(elem).removeData('changed').isValid(validators)
      
    $("input[data-validate-with]").each (i, elem) ->
      input = $(elem)
      input.on "keyup", () -> callGroupValidators($(this).attr("data-validate-with"))
      input.on "blur", () -> callGroupValidators($(this).attr("data-validate-with"))
    
    $("input[data-validate-require]").each (i, elem) ->
      $(elem).on "keyup", (event) ->
        input = $(event.srcElement)
        elementName = input.attr("name");
        requiredInputName = elementName.substring(0, elementName.lastIndexOf('[')) + "[" + input.attr("data-validate-require") + "]";
        
        if input.val()
          validators[requiredInputName] = {} unless validators[requiredInputName]
          validators[requiredInputName].presence = message: I18n.t('mongoid.errors.messages.blank')
        else
          deletePresenceValidator(requiredInputName)
          
        $("input[name*='" + requiredInputName + "']").removeData('changed').isValid(validators)
			  
    deletePresenceValidator = (inputName) -> 
      delete validators[inputName].presence if validators[inputName]?.presence?
    
    $("input.optional").each (i, elem) -> deletePresenceValidator($(elem).attr("name"))

$(document).ready -> new ProductValidator()
