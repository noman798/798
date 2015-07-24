_POST_ID = undefined

$.minisite.post.id = (id, scroll_to_reply=0)->
    id = id - 0
    if _POST_ID == id
        return
    _POST_ID = id
    window._POST = window._POST or {}
    render = (post)->
        _render post, scroll_to_reply
    if id of window._POST
        return render window._POST[id]
    else
        AV.Cloud.run "Post.by_id", {
            host:location.host
            ID:id
        },{
            success: (post)->
                window.SITE = window.SITE or {}
                SITE.ID = post.site_id
                window._POST[post.objectId] = post
                render post
        }

CURRENT_USER = AV.User.current()
if CURRENT_USER
    CURRENT_USER_ID = CURRENT_USER.id
else
    CURRENT_USER_ID = null

_textarea = (id)->
    """<div class="textarea"><textarea id="#{id}" spellcheck="false" placeholder="点击这里，尽情地吐槽、调侃、表达态度吧。\n回复支持Markdown格式！" class="reply"></textarea><label for="#{id}" class="C"><b class="send iconfont icon-fly"></b><b class="tip">快捷键 CTRL+ENTER</b></label></div>"""

_quote = (txt)->
    r = []

    txt = txt.replace(/\r\n/g,"\\n").replace(/\r/g,"\\n")

    for i in txt.split("\n")
        r.push("> "+i)

    r.join("\n")

_reply_bind = (elem, post) ->

    elem.find('.icon-reply').click ->
        self = $ @
        li = self.parents('.li')
        if self.hasClass 'icon-reply'
            self.removeClass('icon-reply')
            self.addClass('icon-close')
            textarea = self.parents('.li').next('.textarea')
            if textarea[0]
                textarea.slideDown()
            else
                textarea = $ _textarea("reply"+@rel)
                li.after textarea
                _textarea_bind textarea, post
            textarea.find('textarea').focus()
        else
            self.removeClass('icon-close')
            self.addClass('icon-reply')
            li.next('.textarea').slideUp()


    elem.find('.icon-trash').click ->
        AV.Cloud.run(
            "PostTxt.rm"
            {
                id:@rel
                site_id:SITE.ID
            }
        )
        $(@).parents('.li').slideUp()

_render_reply = (post, reply)->
    [owner_id, owner_name] = reply.owner
    _ = $.html()
    if reply.rmer
        html = """<p class="rmer">此评论已被<a href="/@#{$.escape owner_name}">#{$.escape owner_name}</a>删除</p>"""
    else
        html = marked reply.txt
    _ """<div class="C li" id="li#{reply.id}" data-txt="#{$.escape reply.txt or ''}">#{html}"""
    if not reply.rmer
        _ """<p class=author><a class="iconfont icon-reply" href="javascript:void(0)" rel="#{reply.id}"></a>"""
        if CURRENT_USER_ID
            id = CURRENT_USER_ID
            if owner_id == id or id == post.owner?.objectId or SITE.SITE_USER_LEVEL >= CONST.SITE_USER_LEVEL.EDITOR
                _ """<a class="icon-trash iconfont" href="javascript:void(0)" rel="#{reply.id}"></a>"""
        _ """<span class=name><span class="owner">#{$.escape owner_name}</span><i>·</i>#{$.timeago reply.createdAt}</span></p>"""
    _ """</div>"""
    _.html()

_TITLE = 0
_render = (post, scroll_to_reply)->
    _TITLE = document.title
    document.title = post.title
    html = $ __inline("/html/coffee/minisite/post.html")

    html.find('.ui.form>.body').html post.html
    html.find('.ui.form>h1 span').text post.title
    html.find('.ui.form a.iconfont').addClass("star#{!!post.is_star-0}").attr('rel',post.ID)

    if post.owner
        author = post.owner.username
    else
        author = post.author

    editbar = $ """<p class="author C"><span class="name"><u></u>#{$.escape author}<span class="m06">·</span>#{$.timeago post.createdAt}</span></p>"""
    if window.SITE.SITE_USER_LEVEL >= CONST.SITE_USER_LEVEL.EDITOR or post.owner?.objectId == CURRENT_USER_ID
        editbar.prepend """<i class="iconfont icon-edit"></i>"""

    html.find('.ui.form>.body').append(editbar)
    $.modal(
        html.html()
        {
            autofocus:false
            dimmerClassName : 'read'
            transition:'fly left'

            onHide: ->
                document.title = _TITLE
                $$("lib/sideshare.close")

            onHidden: ->
                _POST_ID = undefined
                if CURRENT_USER
                    AV.Cloud._run(
                        "UserRead.end"
                        {
                            post_id:post.objectId
                            site_id:SITE.ID
                        }
                    )
        }
        "PostModal"
        (elem)->
            setTimeout(
                ->
                    elem.before """
<div>
<style>
.post_tip{
z-index: 10000;
position: fixed;
font-size: 32px;
right: 50px; 
border: 5px solid #f40;
padding: 14px 24px; 
background: #f60; 
font-weight: bold; 
color: #fff;
}
.post_tip_close{
top: 49px; 
}
.post_tip_close p{
margin:0;
padding:0;
margin-top:6px;
font-size:22px;
}
.ui.dimmer  .post_tip_share .close{
position: absolute;
left: -37px;
top: -50px;
}
.ui.dimmer  .post_tip_close .close{
position: absolute;
left: -37px;
top: 96px;
}
.ui.dimmer  .post_tip .close:before{
color:#f40;
font-weight:bold;
}
.post_tip_close:before{
border: 5px solid #f40;
border-bottom: 0;
border-left: 0;
right: -15px;
top: -15px;
width: 22px;
position: absolute;
content: "";
height: 21px;
}
.post_tip_share{
bottom:126px;
}
.post_tip_share:before{
border: 5px solid #f40;
border-left: 0;
border-top: 0;
right: -15px;
bottom: -15px;
width: 22px;
position: absolute;
content: "";
height: 21px;
}
</style>
<div class="post_tip post_tip_close animated lightSpeedIn">点此关闭窗口<p>快捷键 ESC</p><i class="close icon"></i></div>
<div class="post_tip post_tip_share animated lightSpeedIn">点此分享文章<i class="close icon"></i></div>
</div>
        """
            1000
            )

            $$("lib/sideshare.open")
            replyLi = elem.find('.replyLi')
            textarea = $ _textarea("postModelReply")
            replyLi.before textarea
            elem.find('.icon-edit').click ->
                if post.owner?.id==CURRENT_USER_ID
                    url = 'my'
                else if SITE.SITE_USER_LEVEL >= CONST.SITE_USER_LEVEL.EDITOR
                    url = 'review'
                URL '-minisite/manage.'+url,post.ID

            AV.Cloud.run(
                "PostTxt.by_post"
                {
                    post_id:post.objectId
                    site_id:window.SITE.ID
                }
                {
                    success:(o)->
                        if o.length == 0
                            return
                        _ = $.html()
                        for i in o
                            _ _render_reply(post, i)
                        replyLi.append(_.html())
                        _reply_bind replyLi, post
                        if scroll_to_reply
                            PostModal.scrollTop(
                                replyLi.offset().top-postModal.offset().top-300
                            )
                }
            )
            elem.find(".star").click ->
                $$('minisite/post/star', this)

            PostModal = $("#PostModal").removeClass('transition')
            postModal = $("#postModal").scrollbar()
            _textarea_bind textarea, post

)
_textarea_bind = (reply_div, post)->

    reply = reply_div.find 'textarea'

    autosize reply
    reply.focus ->
        if CURRENT_USER
            reply.addClass 'focus'
        else
            $$ "SSO/auth.new_or_login"

    reply.blur ->
        txt = $.trim $(this).val()
        if not txt
            reply.removeClass 'focus'

    send = ->
        _val = reply.val()
        reply.removeClass('focus').css('height','')
        if $.trim _val
            label_for = reply_div.find('label').attr('for')
            if label_for.slice(0,5) == "reply"
                reply_id = label_for.slice(5)
                li = $("#li#{reply_id}")
                _val = "#{_quote(''+li.data('txt'))}\n\n> ─  @#{li.find('.owner').text()}\n\n"+_val
                li.find('.icon-close').click()

            reply.val('')
            placeholder = reply.attr 'placeholder'
            reply.attr({
                disabled:true
                placeholder : '发送中 , 请稍等 ...'
            })
            
            AV.Cloud.run("PostTxt.new",{post_id:post.objectId,txt:_val},{
                success:(m)->
                    reply.attr({
                        disabled:false
                        placeholder
                    })
                    m.owner = [CURRENT_USER_ID, CURRENT_USER.get 'username']
                    PostModal = $("#PostModal")
                    postModal = $("#postModal")
                    replyLi = postModal.find('.replyLi')
                    m.id = m.objectId
                    replyLi.append _render_reply(post, m)
                    last_reply = replyLi.find('.C:last')
                    _reply_bind last_reply, post
                    PostModal.scrollTop(
                        last_reply.offset().top-postModal.offset().top
                    )
            })

    reply.ctrl_enter send
    reply_div.find('.send').click send
