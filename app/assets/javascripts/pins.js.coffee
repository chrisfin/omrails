# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery -> 
	$('#shop').ImagesLoaded ->
		$('#shop').masonry 
      itemSelector: ".shop_pic"
      columnWidth: 410

  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        alert("Yo Yo Yo")
        # $('.pagination').text("Fetching more pins...")
        # $.getScript(url)
      $(window).scroll()