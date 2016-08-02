window.showWishPageExternal = (popup) ->
  viewButton()
  if popup
    getWishCreatorandShop()

window.lastClickedId = []

viewButton = ->
  if $('body').data('logged-in') == true
    $('.see_more, .img-container a').off().click (e) ->
      e.preventDefault()
      path   = $(this).closest('.gift-idea').find('.img-container').data('path')
      idThis = $(this).closest('.gift-idea').data('id')
      window.lastClickedId = [idThis]
      loadShowWishExternal(path,idThis)

window.loadShowWishExternal = (path,idThis,fromSuggestions) ->
  if !fromSuggestions
    window.lastClickedId = [idThis]
  showLoading()
  container = '<div class="showOverlay showWish squeeze"></div>'
  $(container).insertAfter('.mobileWrapp')
  $('.showOverlay').load(path, (response,status,xhr) ->
    if status == 'success'
      $('.jquery-modal.blocker').spin(false)
      $('body').css('overflow','hidden')
      GiftIdeasShow('popup')
      addEventsToArrows(idThis,fromSuggestions)
      $(this).removeClass('squeeze')
      $('#waFrame').remove()
      loadWAScript()
      FB.XFBML.parse()
    else
      console.log status + ' ' + xhr
      hideLoading()
  ).modal()
  $('.jquery-modal.blocker').spin({color:'#3f9ccb',lines:'12',length:'0',width:'4',radius:'15'}).addClass('showWish').eq(1).remove()
  $(document).on 'modal:close', ->
    hideLoading()
    $('.showOverlay').remove()
    $('body').css('overflow','visible')

addEventsToArrows = (idThis,fromSuggestions) ->
  hideLoading()
  ids       = []
  collected = $('#content #gift-ideas .gift-idea')
  collected.sort( (a,b) ->
    return +a.getAttribute('data-order') - +b.getAttribute('data-order')
  )
  collected.each ->
    ids.push($(this).data('id'))
  if fromSuggestions? then idThis = lastClickedId[0] else idThis
  index = ids.indexOf(idThis)
  if index == 0
    $('.prevGI').hide()
    if ids.length == 1
      $('.nextGI').hide()
  else if index == ids.length-1
    $('.nextGI').hide()
  $('.nextGI').on 'click', ->
    next     = ++index
    nextId   = ids[next]
    nextGI   = $('#content #gift-ideas .gift_idea_' + nextId)
    nextPath = nextGI.find('.img-container').data('path')
    $('.showOverlay').fadeOut(300,->
      $(this).remove()
      $.modal.close()
      loadShowWishExternal(nextPath,nextId)
    )
  $('.prevGI').on 'click', ->
    prev     = --index
    prevId   = ids[prev]
    prevGI   = $('#content #gift-ideas .gift_idea_' + prevId)
    prevPath = prevGI.find('.img-container').data('path')
    $('.showOverlay').fadeOut(300,->
      $(this).remove()
      $.modal.close()
      loadShowWishExternal(prevPath,prevId)
    )
