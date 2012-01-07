class ProductValidator
  constructor: () ->
    groupedValidators = {}
    validators = window[$("form[data-validate]").attr('id')].validators;
    
    rebindGroupValidators = (elem) ->
      group = $(elem).attr("data-validate-presence-group")
      groupInputs = $("input[data-validate-presence-group*='" + group + "']")
      enableValidation = true
      groupInputs.each (i, elem) -> enableValidation = false if $(elem).val()
      
      rebindInputValidator = (input) ->
        inputName = input.removeData('changed').attr("name")
        if enableValidation
          input.removeData('valid')
          delete validators[inputName] if validators.hasOwnProperty(inputName)
          clientSideValidations.formBuilders['SimpleForm::FormBuilder'].remove(input)
        else
          validators[inputName] = groupedValidators[group][inputName]
      
      groupInputs.each () -> rebindInputValidator($(this))
    
    $("input[data-validate-presence-group]").each () ->
      input = $(this)
      inputName = input.attr("name")
      group = input.attr("data-validate-presence-group")
      groupedValidators[group] = {} unless groupedValidators[group]
      groupedValidators[group][inputName] = validators[inputName]
      delete validators[inputName]
      
    $("input[data-validate-presence-group]").on("keyup blur", () -> rebindGroupValidators(this))
    
    callGroupValidators = (elem) ->
      group = $(elem).attr("data-validate-with")
      $("input[data-validate-with*='" + group + "']").each () ->
        $(this).removeData('changed').isValid(validators)
      
    $("input[data-validate-with]").on("keyup blur", () -> callGroupValidators(this))
    
    $("input[data-validate-require]").on "keyup", () ->
        input = $(this)
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
    
    $("input.optional").each () -> deletePresenceValidator($(this).attr("name"))

$(document).ready -> new ProductValidator()
