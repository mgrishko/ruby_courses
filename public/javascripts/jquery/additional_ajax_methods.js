(function ($) {
    $(['put', 'delete']).each(function(item){
        jQuery.extend({
          item : function( url, data, callback, type ) {
              // shift arguments if data argument was ommited
              if ( jQuery.isFunction( data ) ) {
                  callback = data;
                  data = null;
              }

              return jQuery.ajax({
                  type: item.toUpperCase(),
                  url: url,
                  data: data,
                  success: callback,
                  dataType: type
              });
          }
        })
    });
})(jQuery);
