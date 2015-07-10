NOW = 0
#HACK = 1
_LOADING = 0

$.minisite.post.li = (action, params)->
    _now = action+(JSON.stringify params)
    if _now == _NOW
        return
    _NOW = _now
    _post_li action, params

window._POST = window._POST or {}

_footer_loading = ->
    $('#BODY>.main .footer').html '<div class=loading></div>'

_footer_end = ->
    $("#BODY>.main .footer").html "<div class=end></div>"

_post_li = (action, params)->
    if _LOADING
        return
    _LOADING = 1
    params.site_id = SITE.ID
    main = $("#BODY .main .inner").parent('.main')
    
    if not params.since
        main.scrollTop 0
        _footer_loading()
        tag = params.tag
        html = ''
        if tag
            _tag_title(tag)
            if SITE.TAG_LIST.indexOf(tag) < 0
                tag_color = $.hashcolor tag
                html = """<div class=tagSearch><div class=post><span style="color:##{tag_color}" class="hash">#</span><span class=tag style="border-color:##{tag_color};color:##{tag_color}">#{$.escape tag}</span></div></div>"""
        $("#BODY>.main .inner.content").html html
    AV.Cloud.run(
        action
        params
        success:(r)->
            [li, since] = r
            _LOADING = 0
            if li.length
                r = [li]
                if params.tag
                    r.push(params.tag)
                render_tag.apply @, r

                if since
                    main.unbind('scroll.post_li')
                    win = $(window)
                    main.bind(
                        'scroll.post_li'
                        ->
                            if (@scrollTop + 2*win.height()) > @scrollHeight
                                _footer_loading()
                                main.unbind('scroll.post_li')
                                params.since = since
                                _post_li(action, params)

                    )
                else
                    _footer_end()
            else
                _footer_end()
    )


render_tag = (post_list, tag) ->
    _ = $.html()
    
    for post in post_list
        _POST[post.ID] = post
        _ """<div class="hr">"""
        href = "/#{post.ID}"
        console.log post
        if post.brief
            _ """<div class="post"><h2><a rel="#{post.ID}" class="iconfont star star#{!!post.is_star-0}" href="#{href}"></a><a class="title" href="#{href}">#{post.title}</a></h2><div class="brief"><p>#{post.brief}</p>"""
        else
            _ """<div class="post"><h2><a rel="#{post.ID}" class="iconfont star star#{!!post.is_star-0}" href="#{href}"></a><a class="title" href="#{href}">#{post.title}</a></h2><div class="brief">"""


        _ """<p class="author C"><span class="name">#{post.author || post.owner.username}<i>·</i>#{$.timeago post.createdAt}</span>"""
        _ """<span class="reply">"""
        _ """<a class=replynum href="#{href}"><span class=num>#{post.reply_count or 0}</span>评论</a>"""
        _ """<span class="m06">&amp;</span>"""
        _ """<span class=starnum><span class=num>#{post.star_count or 0}</span>收藏</span>"""
        _ """</span>"""
        if post.tag_list and post.tag_list.length
            _ "<span class=tag>"
            for tag in post.tag_list
                color = $.hashcolor tag
                _ """<a style="color:##{color};border-color:##{color}" href="/##{$.escape tag}#">#{$.escape tag}</a>"""
            _ "</span>"

        _ """</p>"""
        
        _ """</div></div></div>"""

    html = $ _.html()
    html.find(".replynum").click ->
        id = this.href.slice(location.protocol.length+3+location.host.length)
        $$('minisite/post/id',id,1)
        URL(id)
        false

    html.find(".star").click ->
        $$('minisite/post/star', this)
        false

    html.find('.author .tag a').click ->
        URL this.href.slice(location.protocol.length+location.host.length+3)
        false

    $("#BODY>.main .inner.content").append(html).find("a.title").click ->
        URL this.href.slice(location.protocol.length+3+location.host.length)
        false

    main = $("#BODY>.main").addClass('scrollbar-macosx').scrollbar()
    #if HACK
    #    $.getScript("/static/lib/debuggap.js?192.168.21.88:11111")
    #    HACK = 0


_tag_title = (tag) ->
    if tag
        title = "##{tag}#"
    else
        title = location.host.toUpperCase()
    document.title = title


