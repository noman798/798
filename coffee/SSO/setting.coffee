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
