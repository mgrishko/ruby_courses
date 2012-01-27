$.namespace("GoodsMaster.validators")

class GoodsMaster.validators.FileValidations
  constructor: (@fileInput) ->
  
  validateImageFileType: () ->
    if !/(\.gif|\.jpg|\.jpeg|\.png)$/i.test(@fileInput.value)
      I18n.t('errors.messages.invalid_image_file_type')
  
  validateMaxFileSize: (max_size_in_bytes, max_size_as_text) ->
    if typeof(window.FileReader) == 'function'
      if @fileInput.files[0].size > max_size_in_bytes
        I18n.t("errors.messages.size_too_big", { file_size: max_size_as_text })