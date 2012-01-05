class ProductValidator
  constructor: () ->
    groupedValidators = {}
    validators = window[$("form[data-validate]").attr('id')].validators;
    
    rebindValidators = (event) ->
      group = $(event.srcElement).attr("data-validate-presence-group")
      groupInputs = $("input[data-validate-presence-group*='" + group + "']")
      
      allInputsInGroupEmpty = true
      groupInputs.each (i, elem) -> allInputsInGroupEmpty = false if $(elem).val()
      
      groupInputs.each (i, elem) ->
        input = $(elem)
        inputName = input.removeData('changed').attr("name")
        if allInputsInGroupEmpty
          input.removeData('valid')
          delete validators[inputName] if validators.hasOwnProperty(inputName)
          clientSideValidations.formBuilders['SimpleForm::FormBuilder'].remove(input)
        else
          validators[inputName] = groupedValidators[group][inputName]
    
    $("input[data-validate-presence-group]").each (i, elem) ->
      input = $(elem)
      inputName = input.attr("name")
      group = input.attr("data-validate-presence-group")
      groupedValidators[group] = {} unless groupedValidators[group]
      groupedValidators[group][inputName] = validators[inputName]
      delete validators[inputName]
      
      input.on "keyup", (event) -> rebindValidators(event)
      input.on "blur", (event) -> rebindValidators(event)

$(document).ready -> new ProductValidator()
