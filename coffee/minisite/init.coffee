$("body").append __inline("/html/minisite/init.html")

current = AV.User.current()

_tip_html = ->
    if window.devicePixelRatio < 2
        return """用 <a href="http://dwz.cn/798space" target="_blank">Retina屏</a> 的 Mac 浏览本站体验最佳"""

    else
        return """本站是开源项目 ，一起来 <a target="_blank" href="http://docs.798.space/foreword.html">撰写历史</a> 吧！"""

TIP = $("#BODY .headroom .tips .txt")

tip_html = 0

if current
    setting = $ """<a class="user" href="/-SSO/setting"><span class="name">#{current.getUsername()}</span><span class="triangle"></span></a>"""
    $('#BODY .headroom .wrapper .right').append setting
    setting.click ->
        URL @href.slice(location.protocol.length+location.host.length+3)
        false
    if not current.attributes.mobilePhoneVerified
        tip_html = """<a href="javascript:void(0);" name="phone">点击验证您的注册手机号</a>"""
        TIP.click ->
            AV.User.requestMobilePhoneVerify(AV.User.current().getMobilePhoneNumber()).then(
                ->
                    URL('-SSO/auth.phone_verify')
                (_error)->
                    tip_err = "手机验证码发送失败,您的发送请求过于频繁，请在1分钟后验证"
                    $.modal_alert tip_err,{
                        onApprove:->
                            location.href = "/"
                    }
            )
            false
    else if not current.attributes.emailVerified
        tip_html = """<a href="javascript:void(0);">点击验证您的注册邮箱</a>"""
        TIP.click ->
            AV.User.requestEmailVerify(AV.User.current().getEmail()).then(
                ->
                    URL('-SSO/auth.email_verify',AV.User.current().getEmail())
            )
            false

else
    if $(window).width()>1012
        $('#BODY .headroom .wrapper .right').append("""<a class="login" href="javascript:URL('-SSO/auth.login');void(0)">登录</a><a class="new" href="javascript:URL('-SSO/auth.new');void(0)">注册</a>""")
    else if $(window).width()<=1012
        $('#BODY .headroom .wrapper .right').append("""<a class="login" href="javascript:URL('-SSO/auth.login');void(0)" style="width:68px;">登录</a>""")

TIP.html(tip_html or _tip_html())

###
@require "/modules/minisite/site.js"
###
require "minisite/site"
$.fn.sidebar.settings.defaultTransition.mobile.left = 'overlay'
$.fn.sidebar.settings.defaultTransition.mobile.right = 'overlay'


