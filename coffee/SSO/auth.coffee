modal = (html, color, id, callback)->
    $.modal(
        html
        {
            dimmerClassName : 'form '+color
        }
        id
        callback
    )
reload = ->
    AV.User.current().fetch success  : ->
        if location.href.indexOf("/-SSO/auth.") >= 0
            location.href = "/"
        else
            location.reload()

_email_alert = (email)->
    href="http://"+email.split("@")[1]
    $.modal_alert """<h1><p>验证邮件已发送至您的邮箱，请<a href="#{href}" target="_blank">点此查收</a></p><p>没有收到?<a class="resend" style="padding-left:30px;cursor:wait;" href="javascript:void(0)"><span class="timer"><span class="count"></span>秒后</span>点此重新发送</a></p></h1>""",{
        onApprove:->
            reload()
        onShow:->
            resend = $(@).find ".resend"
            timer = resend.find ".timer"
            count = timer.find '.count'
            run = ->
                c = 60
                count.css {display:"inline-block",width:"1.5em","text-align":"center"}
                counter =->
                    if c == 0
                        resend.click send
                        resend.css {cursor:"pointer",color:""}
                        timer.hide()
                    else
                        c-=1
                        setTimeout(counter,1000)
                    count.text c
                counter()
                resend.css {color:'#999'}
            send = ->
                AV.User.requestEmailVerify(email, {})
                resend.unbind 'click'
                run()
                timer.show()

            run()
    }

$.SSO.auth = {
    new_or_login : ->
        if store.get('username')
            $.SSO.auth.login()
        else
            $.SSO.auth.new()
    new : ->
        modal(
            __inline("/html/coffee/SSO/new.html")
            "green"
            "ssoAuthNew"
            (elem)->
                error_tip = $.error_tip(elem)
                m = {
                    o:{
                        email:""
                        mobilePhoneNumber:""
                        username:""
                        password:""
                    }
                    submit : ->
                        o = V.ssoAuthNew.o
                        AV.Cloud.run "SSO.auth.new", o.$model, {
                            success: (user) ->
                                AV.User.logIn(o.email, o.password, {
                                    success: (user) ->
                                        location.href="/-SSO/auth.phone_verify"
                                    error:(err)->
                                        error_tip.set {password:"""手机 或 邮箱 已经注册，<a href="javascript:URL('-SSO/auth.login')">请点此登录</a>"""}
                                })
                            fail: (error) ->
                                error_tip.set error
                        }
                        false
                }
        )
    phone_verify:(email) ->
        modal(
            __inline("/html/coffee/SSO/phone_verify.html")
            "green"
            "ssoPhoneVerify"
            (elem)->
                error_tip = $.error_tip(elem)
                phone = AV.User.current().getMobilePhoneNumber()
                resend = $(elem).find ".resend"
                timer = resend.find ".timer"
                count = timer.find '.count'

                run = ->
                    resend.css {color:'#999'}
                    timer.show()
                    c = 60
                    counter =->

                        if c == 0

                            resend.css {color:'#0cf'}
                            resend.click send
                            count.css {cursor:"pointer",color:""}
                            timer.hide()
                        else
                            c -= 1
                            count.text c
                            setTimeout(counter,1000)
                    counter()
                
                send = ->
                    AV.User.requestMobilePhoneVerify(AV.User.current().getMobilePhoneNumber()).then(
                        ->
                            false
                        (_error)->
                            tip_err = "手机验证码发送失败,您的发送请求过于频繁，请在1分钟后验证"
                            error={}
                            if _error
                                error.code = tip_err
                            error_tip.set error
                    )
                    resend.unbind 'click'
                    run()

                run()
                m = {
                        o:{
                            code:""
                            phone
                        }
                        submit : ->
                            o = V.ssoPhoneVerify.o
                            AV.User.verifyMobilePhone(o.code).then(
                                ->
                                    $.modal_alert """<h1><p>手机已验证成功。</p></h1>""" ,{
                                                onApprove:->
                                                    if email
                                                        URL('-SSO/auth.email_verify',email)
                                                    else
                                                        reload()
                                            }
                                ,
                                (_error)->
                                    error={}
                                    if _error.code==1
                                        error.code=_error.message

                                    error_tip.set error
                            )
                            false
                    }
                
        )
    mail_verify: ->
        $.modal_alert """<div class="container"><h3 id=SSO_mail_verify style="text-align:center;"></h3></div>""", {
                onApprove:->
                    reload()
                onShow:->
                    url = "https://api.leancloud.cn/1.1/verifyEmail/"
                    tip_err = "邮箱验证出错"
                    tip_success ="邮箱验证成功"
                    [token, username] = location.href.split("?")[1].split("!")
                    token = token.split("=")[1]
                    $.getJSON(
                        url+token+"?callback=?"
                        (r)->
                            tip = $("#SSO_mail_verify").show()
                            error = r.error
                            if error
                                tip.text(tip_err)
                            else
                                tip.html(tip_success)
                        )
            }
    login: ->
        require.async(
            "lib/store"
            ->
                modal(
                    __inline("/html/coffee/SSO/login.html")
                    "green"
                    "ssoAuthLogin"
                    (elem)->
                        error_tip = $.error_tip(elem)
                        avalon.nextTick(
                            ->
                                elem.find('[name=account]').focus().select()
                        )
                        m = {
                            o:{
                                account:store.get('username') or ''
                                password:""
                            }
                            submit:->
                                o = V.ssoAuthLogin.o
                                account = $.trim o.account
                                if isNaN(account-0)
                                    login = AV.User.logIn
                                else
                                    login = AV.User.logInWithMobilePhone
                                
                                error = {}
                                if not account
                                    error.account = ""
                                if not o.password
                                    error.password = ""
                                if not error_tip.set error
                                    AV.NProgress(login)(
                                        account
                                        o.password
                                        {
                                            success: (user)->
                                                store.set('username', user.getEmail())
                                                reload()
                                            error: (user, _error) ->
                                                if _error.code == 211
                                                    error.account = "该账号不存在"
                                                else if _error.code == 210
                                                    mail = o.account
                                                    mail = if mail.indexOf("@") > 0 then mail else ''
                                                    error.password = """密码错误。忘记密码了？<a href="javascript:URL('-SSO/auth.password_set_mail', '#{mail}');void(0)">点此找回。</a>"""
                                                error_tip.set error
                                        }
                                    )
                                false
                        }
                )
        )

    password_set_mail: (mail)->
        modal(
            __inline("/html/coffee/SSO/password_set_mail.html")
            "purple"
            "ssoAuthPasswordSetMail"
            (elem)->
                error_tip = $.error_tip(elem)
                m = {
                    o:{
                        mail
                    }
                    submit : ->
                        o = V.ssoAuthPasswordSetMail.o
                        error={}

                        if o.mail.indexOf("@") <= 0
                            error.mail = "请输入有效的邮箱地址"

                        if not error_tip.set error
                            AV.User.requestPasswordReset( o.mail, {
                                success: ->
                                    href="http://"+o.mail.split("@")[1]
                                    $.modal_alert """<h1><p><span style="padding-right:30px;">重置密码邮件已发送。</span><a target="_blank" href="#{href}">点此查看</a></p><p>没有收到?<a class="resend" style="padding-left:30px;cursor:wait;" href="javascript:void(0)"><span class="timer"><span class="count"></span>秒后</span>点此重新发送</a></p></h1>""", {
                                                onApprove:->
                                                    location.href="/"
                                                onShow:->
                                                    resend = $(@).find ".resend"
                                                    timer = resend.find ".timer"
                                                    count = timer.find '.count'
                                                    run = ->
                                                        c = 60
                                                        count.css {display:"inline-block",width:"1.5em","text-align":"center"}
                                                        counter =->
                                                            if c == 0
                                                                resend.click send
                                                                count.css {cursor:"pointer",color:""}
                                                                timer.hide()
                                                            else
                                                                c-=1
                                                                setTimeout(counter,1000)
                                                            count.text c
                                                        counter()
                                                        resend.css {color:'#999'}
                                                    send = ->
                                                        AV.User.requestPasswordReset(o.mail, {})
                                                        resend.unbind 'click'
                                                        run()

                                                    run()
                                                        
                                            }
                                error: (_error) ->
                                    if _error.code == 205
                                        error.mail = "该账号不存在"
                                    else
                                        error.mail = _error.message
                                    error_tip.set error
                            })
                        false
                }
        )
    set_password: ->
        [token, username] = location.href.split("?")[1].split("!")
        token = token.split("=")[1]
        modal(
            __inline("/html/coffee/SSO/set_password.html")
            "blue"
            "ssoSetPassword"
            (elem)->
                error_tip = $.error_tip(elem)
                m = {
                    o:{
                        username
                        password:""
                    }
                    submit : ->
                        o = V.ssoSetPassword
                        $.getJSON(
                            """https://api.leancloud.cn/1.1/resetPassword/#{token}?callback=?"""
                            {password:o.password}
                            (r)->
                                error = r.error
                                if error
                                    if error == "Token \u5df2\u7ecf\u8fc7\u671f\u3002"
                                        error ="""<h1><p>密码重置链接已经失效</p><p><a href="javascript:URL('-SSO/auth.password_set_mail');void(0)">点此再次申请重置密码</a></p></h1>"""
                                    $.modal_alert error
                                    return
                                require.async(
                                    "lib/store"
                                    ->
                                        $.modal_alert("""<h1><p>密码重置成功！</p></h1>""", {
                                            onApprove:->
                                                store.set('username', username)
                                                URL("-SSO/auth.login")
                                        })
                                )
                        )
                        false
                }
        )
    info_update : ->
        modal(
            __inline("/html/coffee/SSO/info_update.html")
            "green"
            "ssoInfoUpdate"
            (elem)->
                error_tip = $.error_tip(elem)
                currentUser=AV.User.current()
                
                if (currentUser)
                    o=currentUser
                    email=o.get("email")
                    mobilePhoneNumber=o.get("mobilePhoneNumber")
                    username=o.get("username")
                    m = {
                        o:{
                            email
                            mobilePhoneNumber
                            username
                        }
                        submit : ->
                            o = V.ssoInfoUpdate.o
                            AV.Cloud.run "SSO.auth.info_update", o.$model, {
                                success: (user) ->
                                    $.modal_alert """<h1><p>您的信息已修改成功。</p></h1>""", {
                                        onHidden:->
                                            currentUser.fetch(
                                                success:->
                                                    if o.mobilePhoneNumber != mobilePhoneNumber and o.email != email
                                                        URL('-SSO/auth.phone_verify',o.email)
                                                    else if o.mobilePhoneNumber != mobilePhoneNumber
                                                        URL('-SSO/auth.phone_verify')
                                                    else if o.email != email
                                                        URL('-SSO/auth.email_verify',o.email)
                                                    else if o.username != username
                                                        reload()
                                            )
                                    }
                                fail: (error) ->
                                    error_tip.set error
                            }
                            false
                    }
        )
    email_verify :(email) ->
        _email_alert email
    password_update : ->
        modal(
            __inline("/html/coffee/SSO/password_update.html")
            "green"
            "ssoPasswordUpdate"
            (elem)->
                error_tip = $.error_tip(elem)
                currentUser=AV.User.current()
                
                if (currentUser)
                    m = {
                        o:{
                            oldpassword:""
                            newpassword:""
                        }
                        submit : ->
                            o = V.ssoPasswordUpdate.o
                            AV.Cloud.run "SSO.auth.password_update", o.$model, {
                                success:(user) ->
                                    $.modal_alert """<h1><p>您的密码已修改成功。</p></h1>""", {
                                        onApprove:->
                                            currentUser.fetch success:-> URL "-SSO/setting"
                                    }
                                fail:(error) ->
                                    error_tip.set error
                            }
                            false
                    }
        )
}

