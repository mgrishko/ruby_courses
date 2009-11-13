PI = (function(options){
  var linkEl = null, saveUrl = null, 
    methods = {
      'new' : 'POST',
      'edit' : 'PUT'
  },
  piItemsContainer = $('#pi_container');

  function hideForms(){
    $('#newform,#editform').hide();
  }

  function deletePi(item, link){
    $.ajax({
        'type' : 'DELETE',
        url: link,
        dataType: 'json',
        success: function(){
          $(item).parent().parent().remove();
        }
    });
  }

  function showPiForm(str, t, href, get_url){
    var form = $('#' + str + 'form');
    saveUrl = href;
    if(get_url){
      $('#editform form').formLoad(get_url);
    }else{
      $('#newform input[type=text]').each(function(){
        $(this).val('');
      })
    }
    hideForms();
    form.insertAfter($(t).parents('.item')).show();
    linkEl = t;
    return false;
  }

  function initialize(){
    $(['new', 'edit']).each(function(index, str){
      var form = $('#' + str + 'form');

      $('form', form).submit(function(){
        var id = $('#packaging_item_id').val();
        $(this).ajaxSubmit({
          type : methods[str],
          dataType : 'json',
          url : saveUrl,
          success : function(result){
            if(result.success){
              hideForms();
              var li = $(linkEl).parent().parent();

              if(li.parents('#pi_new').length){
                $('#pi_container > ul').append($(result.out));
              }else{
                if(str == 'edit'){
                  li.after($(result.out)).remove();
                }else{
                  var item = $(result.out);
                  li.find('ul:first').append(item);
                }
              }
            }else{
              var errors = result;
              for (var i = 0; i < errors.length; i++) {
                $('#' + str + '_packaging_item_' + errors[i][0]).parents('p').append(
                  '<span class="error">' + errors[i][1] + '<br /></span>'
                );
              };
            }
          },
          beforeSubmit : function(){
            $('.error', form).remove();
          }
        });
        return false;
      });
    });
  }

  return t = {
    'init' : initialize,
    'showForm' : showPiForm,
    'delete' : deletePi
  }
})({});

$(PI.init);
