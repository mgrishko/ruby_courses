$('document').ready(function(){
	$('.drop-down').each(function(){
		$(this).width($(this).find('.drop-down-list-cont').width());
	});

	$('.drop-down-link').click(function(){
		$('.drop-down').css('visibility','hidden');
		$('.dd-overlay').css('display','block');
		$(this).parent().find('.drop-down').css('visibility','visible');

		return false;
	});

	$('.dd-input').focus(function(){
		$('.drop-down').css('visibility','hidden');
		$('.dd-overlay').css('display','block');
		$(this).parent().find('.drop-down').css('visibility','visible');
		$(this).parent().css('z-index','2002');
	})

	$(document).keyup(function(event){
 		if (event.keyCode == 27)
 		{
  			$('.drop-down').css('visibility','hidden');
  			$('.dd-overlay').css('display', 'none');
  			$('.cont-dd-input').css('z-index', '1');
 		}
	});

 	$('.dd-overlay').click(function(){
  		$('.drop-down').css('visibility','hidden');
  		$('.dd-overlay').css('display', 'none');
  		$('.cont-dd-input').css('z-index', '1');
	});

	$('.drop-down-list ul li a').click(function(){
		$(this).parent().parent().find('li').removeClass('selected');
		$(this).parent().parent().parent().find('li').removeClass('selected');
		$(this).parent().addClass('selected');




		return false;
	});

	$('.drop-down-cont.units .drop-down-list ul li a').click(function(){
		$('.drop-down-cont.units').find('.drop-down-link').text($(this).text());
		$('#base_item_content_uom').val(uoms[$(this).text()]);
		$('.drop-down').css('visibility','hidden');
		$('.dd-overlay').css('display', 'none');

		return false;
	});

	$('.drop-down-cont.vat .drop-down-list ul li a').click(function(){
		$('.drop-down-cont.vat').find('.drop-down-link').text($(this).text());
    $('#base_item_vat').val(vats[$(this).text()]);
		$('.drop-down').css('visibility','hidden');
		$('.dd-overlay').css('display', 'none');

		return false;
	});


	$('.drop-down-list-in ul li a').click(function(){
		$(this).parent().parent().parent().parent().find('li').removeClass('selected');

		$(this).parent().addClass('selected');
		return false;
	});


	$('.choose-btn').click(function(){
		$('.drop-down').css('visibility','hidden');
		$('.dd-overlay').css('display', 'none');
		return false;
	})

	$('.hint .drop-down-list ul li a').click(function(){
		$('.drop-down').css('visibility','hidden');
		$('.dd-overlay').css('display', 'none');
		$(this).parent().parent().parent().parent().parent().siblings('.dd-input').val($(this).text());


		return false;
	})
})

