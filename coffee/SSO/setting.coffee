$.SSO.setting = AV.User.logined ->
    bar = $ """<div id="ssoSetting" class="ui right sidebar">#{__inline("/html/coffee/SSO/setting.html")}</div>"""
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

    if window.SITE.SITE_USER_LEVEL=="1000"
        console.log window.SITE.SITE_USER_LEVEL
        bar.find('.root').show()
        bar.find('.editor').show()
    else if window.SITE.SITE_USER_LEVEL=="900"
        bar.find('.editor').show()
        bar.find('.root').hide()
    else
        bar.find('.root').hide()
        bar.find('.editor').hide()
