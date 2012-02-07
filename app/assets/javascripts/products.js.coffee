$.namespace("GoodsMaster.products")

$(document).ready ->
  GoodsMaster.products.init()

GoodsMaster.products.init = ->
  GoodsMaster.products.initPager()

GoodsMaster.products.autoScrolledCount = 0

# Initializes product pager.
# It request first 5 new products page if pager is shown on scroll.
GoodsMaster.products.initPager = ->
  GoodsMaster.products.pageRequested = false

  # If pager is visible on load then request next page
  if GoodsMaster.products.isPagerShown()
    GoodsMaster.products.nextPage()

  $(window).on "scroll", (event) ->
    return if GoodsMaster.products.pageRequested || GoodsMaster.products.autoScrolledCount >= 5

    if GoodsMaster.products.isPagerShown()
      GoodsMaster.products.autoScrolledCount += 1
      GoodsMaster.products.nextPage()
      alert(GoodsMaster.products.autoScrolledCount)


# Requests new page
GoodsMaster.products.nextPage = ->
  GoodsMaster.products.pageRequested = true
  $pager_link = $("#pager a")
  # Requesting next page
  $pager_link.click()
  $pager_link.replaceWith(GoodsMaster.ajax_loader.img)


# Returns true if pager is shown
GoodsMaster.products.isPagerShown = ->
  $pager = $("#pager")

  viewTop = $(window).scrollTop()  # Top position of the visible part of page to the window top
  viewBottom = viewTop + $(window).height() # Bottom position of the visible part of page to the window top

  pagerTop = $pager.offset().top # Offset of pager to the window top

  pagerTop < viewBottom