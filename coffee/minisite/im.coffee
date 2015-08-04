###
@require "/lib/jquery-visibility.js"
###


IM = {
    CID:
        CHAT : 1000
}



$ ->
    current = AV.User.current()
    if current
        _im(current.get('username'))
    else
        $$('SSO/auth.new_or_login')

_im = (username)->
    elem = $ __inline("/html/coffee/minisite/im.html")
    $('body').append elem


    notification = ->
    NOTIFICATION_COUNT = 0
    ORIGINAL_TITLE = document.title

    Notification = window.Notification || window.mozNotification || window.webkitNotification

    _notification = (name, body, tag, icon)->
        icon = "http://www.qjis.com/uploads/allimg/130122/1024245024-38.jpg"
        params = {body}
        if tag
            params.tag = tag
        if icon
            params.icon = icon
        #icon , tag (替换) ， body
         
        instance = new Notification(
            name
            params
        )

        instance.onclick = ->
            window.focus()
            this.close()

        setTimeout(
            ->
                instance.close()
            5000
        )
        NOTIFICATION_COUNT += 1

        document.title = "( #{NOTIFICATION_COUNT} ) #{ORIGINAL_TITLE}"

    if Notification
        Notification.requestPermission(
            (permission) ->
                if permission == "granted"
                    if document.hidden
                        notification = _notification
                    $(document).on(
                        show: ->
                            notification = ->
                            NOTIFICATION_COUNT = 0
                            document.title = ORIGINAL_TITLE
                        hide: ->
                            ORIGINAL_TITLE = document.title
                            notification = _notification
                    )
        )

#instance.onclick = function () {
#    // Something to do
#};
#instance.onerror = function () {
#    // Something to do
#};
#instance.onshow = function () {
#    // Something to do
#};
#instance.onclose = function () {
#    // Something to do
#};

    Rbar = $ elem[0]
    Rbar.scrollbar()

    main = $ elem[1]
    main.scrollbar()

    new Headroom(
        main.find(".headroom")[0],
        {
            offset: 66
            tolerance: 1
            scroller : main[0]
            classes: {
                "initial": "animated",
                "pinned": "swingInX",
                "unpinned": "swingOutX"
            }
    }).init()

    _scroll_down = ->
        main.scrollTop(main.find(".body").height())

    _scroll_down()

    _render = (cid, data)->
        main.find('.body').append _render_html(cid, data)
    
    _render_html = (cid, data)->
        switch cid
            when IM.CID.CHAT
                return """<div class="C"><div class="item"><div class=line>#{$.txt2html(data.txt)}</div><div class="name">#{$.escape data.username}</div></div></div>"""


    $ ->
        im_reply = main.find('#im_reply')
        im_reply.focus ->
            autosize(im_reply)
        im_reply.blur ->
            if not $.trim(im_reply.val())
                im_reply.val ''
                autosize.destroy(im_reply)

        _reply = ->
            _render IM.CID.CHAT, {
                txt:im_reply.val().replace(/(\t| |\n|\r)+$/gm,"")
                username
            }

            im_reply.val ''
            im_reply.blur()
            _scroll_down()

        main.find('.replybar .send').click(_reply)
        im_reply.ctrl_enter(_reply)
        

    setInterval(
#setTimeout(
        ->
            notification("路人甲","你知道吗?", "121")
        3000
    )
