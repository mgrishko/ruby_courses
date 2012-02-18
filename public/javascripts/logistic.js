// document ready
$('document').ready(function(){
  drawLines();
})

function initjNice(){
  $('.jNice').jNice();
}
function addLeaf(obj, data)
{
  parent = $(obj).parent().parent().parent();
  leaf = '<div class=\'pi-cont edited\'>'+data +'</div>';
  leaf = data;
  branch = '<div class=\'branch\'></div>';
  $('.tree-cont').width($('.tree-cont').children('.branch').width()+300);
  if(parent.hasClass('hasChild'))
  {
    var branch = parent.next('.branch');
    branch.find(">:first-child").css('clear','left').addClass('secondChild');
    branch.prepend(leaf);
  }
  else
  {
    parent.addClass('hasChild');
    parent.after('<div class="branch">'+leaf+'</div>');
  }
  $('.jNice').jNice();
  drawLines();
  return false;
}
var drawLines = function()
{
  $('.tree-cont .pi-cont').each(function(){
    $(this).find('.bt').width($(this).parent().width());
  });
  $('.tree-cont .branch').each(function(){
    if($(this).children('.pi-cont:last').index()==0)
    {
$(this).css('border-left','2px solid white');
    }
    else
    {
      $(this).css('border-left','2px solid #3a5a99');
    }

    if($(this).width()<$(this).siblings().width())
    {
      $(this).width($(this).siblings().width());
    }
  });
}
function deleteLeaf(obj)
{
  parent = $(obj).parent();
  if(parent.hasClass('hasChild'))
  {
    return;
  }
  else
  {
    if(parent.parent().index()==0 && parent.index()==0)
    {
      return;
    }
    else
    {
      tmp = parent.parent();
      parent.remove();
      if(tmp.html().trim()=='')
      {
        tmp2 = tmp.parent();
        tmp.remove();
        tmp2.find('.hasChild').removeClass('hasChild');
      }
      else
      {
        tmp.find('.pi-cont:first').removeClass('secondChild');
      }
    }
  }

  drawLines();
  return false;
}
