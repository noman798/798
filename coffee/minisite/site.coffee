
$ ->
    AV.Cloud.run(
        "Space.by_host"
        {
            host:location.host
        }
        error : ->
            if location.host != CONST.HOST
                location.href = "//#{CONST.HOST}"
        success : (site) ->
            SITE = {}
            [
                SITE.id
                SITE.name
                SITE.name_cn
                SITE.tag_list
                SITE.logo
                SITE.slogo
                SITE.social
                SITE.user_level
                css_updated_at
            ] = site

            require.async(
                [
                    'minisite/init'
                    'minisite/head'
                    "minisite/Rbar"
                ]
                ->
                    RBAR.push(
                        renderRbar(SITE)
                        ->
                            $('#BODY .Rbar .scrollbar-macosx').scrollbar()
                    )
                    RBAR.init()
            )
            window.SITE = {
                ID : SITE.id
                TAG_LIST:SITE.tag_list
                SITE_USER_LEVEL:SITE.user_level
            }
            document.title = SITE.name+" · "+SITE.name_cn
    )


renderRbar = (site)->
    user = AV.User.current()
    _ = $.html()

    _ """<div class="scrollbar-macosx"><div class="vc2"><div class="vc1"><div class="vc0"><div class="body">"""

    _ """<div class="profile"><a class="logo" href="//#{location.host}"><b class="bg"><b class="svg" style="background-image:url(#{site.logo})"></b></b></a><h1><a class="header" href="//#{location.host}">#{$.escape site.name}</a></h1><p class=header>#{$.escape site.slogo}</p></div>"""

    _ """<div class="socialWay hrline"><ul>"""


    for [way,website] in site.social

        if way=="weixin"

            _ """<li class="weixin"><a target="_blank" class="ico-#{way}"></a><div class="pics"><img src="#{website}"></div></li>"""

        else
            if way == "email"
                website = "mailto:"+website
                target=''
            else
                target="""target="_blank" """
            _ """<li><a href="#{website}" #{target}class="ico-#{way}"></a></li>"""

    _ """</ul></div>"""

    _ """<div class="channel hrline"><div class="tag"><p><a class="now" href="/">最近更新</a></p>"""

    _ """<div class="ui accordion">"""

    _ """<div class="title"><i class="dropdown icon"></i>分类浏览</div>"""
    _ """<div class="content">"""

    for tag in site.tag_list
        _ """<div><a href="/##{$.escape tag}#">#{$.escape tag}</a></div>"""

    if user
        username = user.get('username')
        star_link = username+"/star"
        read_link = username+"/read"
    else
        read_link = star_link = "-SSO/auth.new_or_login"

    _ """</div></div></div><div class="link"><p><a href="/#{star_link}">我的收藏</a></p><p><a href="/#{read_link}">阅读历史</a></p></div>"""

    _ "</div>"

    _ """</div></div></div></div>"""
    html = $ _.html()
    html.find(".ui.accordion").accordion()
    html.find('.channel a').click ->
        URL this.href.slice(location.protocol.length+location.host.length+3)
        false
    html

