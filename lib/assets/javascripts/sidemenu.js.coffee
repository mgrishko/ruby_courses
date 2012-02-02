$.namespace("GoodsMaster.sidemenu")

GoodsMaster.sidemenu.init = ->
  $sidemenu = $(".sidemenu a")
  $frame = $(".submenu")
  $content = $frame.find(".content")

  $sidemenu.mouseenter ->
    $this = $(this)
    $sidemenu.removeClass "hover"
    $content.hide()

    $this.addClass "hover"

    submenu = $this.attr("data-submenu")

    if submenu?
      id = "#" + submenu
      $content.filter(id).show()
      $frame.show()
    else
      $frame.hide()

  $frame.mouseleave ->
    $frame.hide()
    $sidemenu.removeClass "hover"

$(document).ready ->
  GoodsMaster.sidemenu.init()


