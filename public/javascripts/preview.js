$j('document').ready(function(){	$j('#goods-list-short .item').click(function(){		$j('.pp-overlay').css('display','block');		$j(this).find('.preview-popup').css('visibility','visible');	});	$j('#goods-list-detailed .item').click(function(){		$j('.pp-overlay').css('display','block');		$j(this).find('.preview-popup').css('visibility','visible');	});	$j('#goods-list-as-picture .item').click(function(){		$j('.pp-overlay').css('display','block');		$j(this).find('.preview-popup').css('visibility','visible');	});	$j(document).keyup(function(event){ 		if (event.keyCode == 27) 		{  			$j('.preview-popup').css('visibility','hidden');  			$j('.pp-overlay').css('display', 'none'); 		}	});	$j('.preview-close').click(function(){  		$j('.preview-popup').css('visibility','hidden');  		$j('.pp-overlay').css('display', 'none');  		return false;	}); 	$j('.pp-overlay').click(function(){  		$j('.preview-popup').css('visibility','hidden');  		$j('.pp-overlay').css('display', 'none');	});});