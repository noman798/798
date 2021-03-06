$.SSO.setting = AV.User.logined ->
    _ = $.html()
    _ """<div id="ssoSetting" class="ui right sidebar">#{__inline("/html/coffee/SSO/setting.html")}"""

    if SITE.SITE_USER_LEVEL>=CONST.SITE_USER_LEVEL.EDITOR
        _ """<a class="editor" href="javascript:URL('-minisite/manage.review');void(0)">投稿审核<i class=iconfont>&#xe61f;</i><i class="iconfont check">&#xe629;</i></a>"""

    if SITE.SITE_USER_LEVEL==CONST.SITE_USER_LEVEL.ROOT
        _ """<a class="root" href="javascript:URL('-minisite/member');void(0)">团队成员<i class=iconfont>&#xe626;</i></a>"""

    _ """<a class="logout" href="javascript:AV.User.logOut();URL();location.reload();void(0)">退出登录</a></div>"""

    bar = $ _.html()

    $('body').append(bar)
    
    bar.sidebar(
        "setting"
        {
            dimPage:false
            closable:false
            animation:"overlay"
            useLegacy:true
        }
    ).sidebar 'show'
    $('#ssoSetting .user .name').text AV.User.current().getUsername()
    bar.find(".user .icon-close").click ->
        bar.remove()

