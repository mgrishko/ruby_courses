$j('document').ready(function(){
	$j('.drop-down').each(function(){
		$j(this).width($j(this).find('.drop-down-list-cont').width());
	});

	$j('.drop-down-link').click(function(){
		$j('.drop-down').css('visibility','hidden');
		$j('.dd-overlay').css('display','block');
		$j(this).parent().find('.drop-down').css('visibility','visible');

		return false;
	});

	$j('.dd-input').focus(function(){
		$j('.drop-down').css('visibility','hidden');
		$j('.dd-overlay').css('display','block');
		$j(this).parent().find('.drop-down').css('visibility','visible');
		$j(this).parent().css('z-index','2002');
	})

	$j(document).keyup(function(event){
 		if (event.keyCode == 27)
 		{
  			$j('.drop-down').css('visibility','hidden');
  			$j('.dd-overlay').css('display', 'none');
  			$j('.cont-dd-input').css('z-index', '1');
 		}
	});

 	$j('.dd-overlay').click(function(){
  		$j('.drop-down').css('visibility','hidden');
  		$j('.dd-overlay').css('display', 'none');
  		$j('.cont-dd-input').css('z-index', '1');
	});

	$j('.drop-down-list ul li a').click(function(){
		$j(this).parent().parent().find('li').removeClass('selected');
		$j(this).parent().parent().parent().find('li').removeClass('selected');
		$j(this).parent().addClass('selected');




		return false;
	});

	$j('.drop-down-cont.units .drop-down-list ul li a').click(function(){
		$j('.drop-down-cont.units').find('.drop-down-link').text($j(this).text());
		$j('#base_item_content_uom').val(uoms[$j(this).text()]);
		$j('.drop-down').css('visibility','hidden');
		$j('.dd-overlay').css('display', 'none');

		return false;
	});

	$j('.drop-down-cont.vat .drop-down-list ul li a').click(function(){
		$j('.drop-down-cont.vat').find('.drop-down-link').text($j(this).text());
    $j('#base_item_vat').val(vats[$j(this).text()]);
		$j('.drop-down').css('visibility','hidden');
		$j('.dd-overlay').css('display', 'none');

		return false;
	});


	$j('.drop-down-list-in ul li a').click(function(){
		$j(this).parent().parent().parent().parent().find('li').removeClass('selected');

		$j(this).parent().addClass('selected');
		return false;
	});


	$j('.choose-btn').click(function(){
		$j('.drop-down').css('visibility','hidden');
		$j('.dd-overlay').css('display', 'none');
		return false;
	})

	$j('.hint .drop-down-list ul li a').click(function(){
		$j('.drop-down').css('visibility','hidden');
		$j('.dd-overlay').css('display', 'none');
		$j(this).parent().parent().parent().parent().parent().siblings('.dd-input').val($j(this).text());


		return false;
	})
})

