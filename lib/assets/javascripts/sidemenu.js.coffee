$.namespace("GoodsMaster.sidemenu")

GoodsMaster.sidemenu.init = ->
  $sidemenu = $(".sidemenu a")
  $submenu = $(".submenu")
  $content = $submenu.find(".content")

  # Displaying submenu when mouse goes over top menu
  $sidemenu.mouseenter ->
    $this = $(this)

    # Closing current open submenus
    $sidemenu.removeClass "hover"
    $submenu.hide()
    $content.hide()

    $this.addClass "hover"

    submenu = $this.attr("data-submenu")
    # Displaying submenu if exists
    if submenu?
      id = "#" + submenu
      $content.filter(id).show()
      $submenu.show()

  # Removing hover from sidemenu without submenu
  $sidemenu.mouseleave ->
    $sidemenu.removeClass "hover" unless $submenu.is(":visible")

  # Closing submenu
  $submenu.mouseleave ->
    $submenu.hide()
    $sidemenu.removeClass "hover"

$(document).ready ->
  GoodsMaster.sidemenu.init()


