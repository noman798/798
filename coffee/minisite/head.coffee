new Headroom(
    $(".headroom")[0],
    {
      "offset": 66,
      "tolerance": 1,
      scroller : $("#BODY>.main")[0]
      "classes": {
        "initial": "animated",
        "pinned": "swingInX",
        "unpinned": "swingOutX"
        }
    }).init()

$('.headroom .icon-search').click ->
    $.modal_alert '研发中，请稍后使用。。。'
    return false
    ###
    $('#BODY').prepend(__inline("/html/coffee/minisite/search.html"))
    if AV.User.current()
        user=AV.User.current().getUsername()
        $('.overlay .searchbar .wrap span').text(user)

    $('.searchbar .query input').focus()

    View(
        "search"
        {
            keyWords:""
        }
        (v)->
            if AV.User.current()
                if v.keyWords==""
                    $('.suggest-wrap').hide()
                $('.query input').keyup ->
                    if v.keyWords==""
                        $('.suggest-wrap').hide()
                    else
                        $('.suggest-wrap').show()
            else
                $('.suggest-wrap').hide()
    )

    $('.overlay .icon-search').click ->
        $('.overlay').remove()
    $('.overlay .icon-close').click ->
        $('.overlay').remove()

    if $(window).width()>1012
        $('.overlay .searchbar .wrap').width($('.Rbar').width())

    $(window).resize ->
        if $(window).width()<1012
            $('.overlay .searchbar .wrap').width(100)
        else
            $('.overlay .searchbar .wrap').width($('.Rbar').width())
    ###
