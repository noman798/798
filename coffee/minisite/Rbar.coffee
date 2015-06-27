
# Rbar.set
# Rbar.push
# Rbar.show
# Rbar.pop -> pop到最后一个的时候就不再pop了
# Rbar.hide

Rbar = $("#BODY .Rbar")
Rbody = Rbar.find('.Rbody')
_MAIN = $("#BODY>.main")

min_width = 1012

_clear_now = ->
    $('.Rbar .channel a').removeClass('now')
    $(".Rbar .tag .ui.accordion").accordion('close',0)

_link_now = ()->
    href = location.href
    for i in $(".Rbar .link a")
        if i.href.slice(0, href.length) == href
            self = $ i
            if self.hasClass('now')
                return
            _clear_now()
            self.addClass 'now'
            document.title = "##{self.text()}#"
            break



_tag_now = (tag)->
    channel_a = $('.Rbar .channel a')
    if tag
        for i in $('.Rbar .tag a')
            i_ = $(i)
            if i_.text() == tag
                _i = i_
                break
    else
        _i = $(channel_a[0])
    if _i and not _i.hasClass 'now'
        channel_a.removeClass('now')
        _i.addClass('now')
        accordion = $(".Rbar .tag .ui.accordion")
        if SITE.TAG_LIST.indexOf(tag) >= 0
            action = 'open'
        else
            action = 'close'
        accordion.accordion(action,0)

_tag_by_location = ->
    tag = ''
    if location.pathname == "/"
        hash = location.hash
        hash = hash.replace(/#-\d+$/,"#")
        if hash.charAt(0) == "#" and hash.charAt(hash.length-1) =="#"
            tag = hash.slice(1,-1)
    
        return tag
    else
        return

window.RBAR = class RBAR
    @_buffer = []

    @push : (html,callback)->
        frame = Rbody.find('.frame')
        if frame[0]
            @_buffer.push frame
        f = $ """<div class=frame>"""
        f.append(html)
        Rbody.append f
        callback?()

    @pop : ->

    @show : ->
        _Rbarshow(win.width())

    @hide : ->


    @init : ->
        if resize() > min_width
            RBAR.show()
        else
            rbarOpen.animate(width:'toggle')
        win.resize resize

        _post_li = (username, action)->
            _link_now()
            ACTION = {
                star:"PostStar"
                read:"UserRead"
            }
            $$('minisite/post/li', ACTION[action]+".by_username", {username})

        _render_id = (id) ->

        $ ->
            tag = _tag_by_location()
            if tag!=undefined or location.pathname.slice(0,2) == "/-" or /\d+/.test(location.pathname.slice(1))
                $$('minisite/post/li',"Space.post_by_tag", {
                    tag:tag or ''
                })

        Route(
            {
                "/(\\d+)" : (id)->
                    $$ "minisite/post/id", id
                "/([^/]+)/(star|read)":(username,action)->
                    _post_li(username, action)
            }
            {
                notfound: ->
                    tag = _tag_by_location()
                    if tag != undefined
                        $$('minisite/post/li',"Space.post_by_tag", {tag})
                        _tag_now tag
                    else
                        _clear_now()
            }
        ).init()

rbarOpen = $("#BODY .rbarOpen").click RBAR.show


win = $(window)


_Rbarshow = (width)->
    if width < min_width
        config = {
            dimPage:true
            closable:true
            transition:"scale down"
        }
        Rbar.removeClass "uncover"
    else
        config = {
            dimPage:false
            closable:false
        }
        Rbar.removeClass "scale down"
        Rbar.addClass "uncover"

    config.onHide = ->
        Rbar.removeClass "scale down uncover"
        if not rbarOpen.is(":visible") and width>450
            rbarOpen.animate {width:'toggle'}
    config.onShow = ->
        if rbarOpen.is(":visible") and width > 450
            rbarOpen.animate {width:'toggle'}
        if width > 1012
            Rbar.removeClass "scale down"

    Rbar.sidebar('setting', config).sidebar 'show'


_Rbarhide = ->
    Rbar.sidebar 'hide'

Rbar.find('.rbarClose').click _Rbarhide

_TIMEOUT = 0

resize = ->
    if _TIMEOUT
        clearTimeout _TIMEOUT
    width = win.width()
    sidebar = sidebar
    is_hidden = Rbar.sidebar('is hidden')
    if width < min_width
        _Rbarhide()
        $("#ssoSetting").sidebar 'hide'
    else
        not_uncover = not (Rbar.hasClass "uncover")
        if is_hidden or not_uncover
            if not_uncover
                _Rbarhide()
            _TIMEOUT = setTimeout(
                ->
                    _TIMEOUT = 0
                    _Rbarshow width
                300
            )
        else
            Rbar.sidebar "push page"
    width

