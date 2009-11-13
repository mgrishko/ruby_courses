(function ($) {
    function expandName(name){
      var r = (name.match(/([^[]+)(?:\[([^\]]+)\])?/)), ret = '';
      if(r){
        r.shift();
      };
      r = r || [];

      for (var i = 0; i < r.length; i++) {
        ret += "['" + r[i] + "']";
      };

      return ret;
    }
    $.fn.formLoad = function (url, options) {
        options = options || {};
        var t=this;
        $.getJSON(url, null, function(){
            var data = arguments[0];
            $('input', t).each(function(){
                var local_data_var = data, val;
                if(!this.name) return;
                try{
                  val = (eval('local_data_var' + expandName(this.name)));

                  if(val){
                    $(this).val(val);
                  }
                }catch(e){
                  return;
                }
            });
        });
    };
})(jQuery);
