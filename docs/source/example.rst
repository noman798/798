实例讲解
=======================================

下面是coffee/SSO/auth.coffee的部分代码::

    modal = (html, color, id, callback)->
        $.modal(
            html
            {
                dimmerClassName : 'form '+color
            }
            id
            callback
        )
    $.SSO.auth = {
        password_set_mail: (mail)->
            self = modal(
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

                            error={}

                            if m.o.mail.indexOf("@") <= 0
                                error.mail = "请输入有效的邮箱地址"

                            if not error_tip.set error
                                AV.User.requestPasswordReset( m.o.mail, {
                                    success: ->
                                        href="http://"+m.o.mail.split("@")[1]
                                        $.modal_alert """<h1><p><span style="padding-right:30px;">重置密码邮件已发送。</span><a target="_blank" href="#{href}">点此查看</a></p><p>没有收到?<a class="resend" style="padding-left:30px;cursor:wait;" href="javascript:void(0)">点此重新发送<span class="timer"></span></a></p></h1>""", {
                                                    onApprove:->
                                                        location.href="/"
                                                    onShow:->
                                                        resend = $(@).find(".resend")
                                                        timer = resend.find(".timer")
                                                        run = ->
                                                            c = 60
                                                            counter =->
                                                                if c == 0
                                                                    clock = ""
                                                                    resend.click send
                                                                    resend.css {cursor:"pointer",color:""}
                                                                else
                                                                    c-=1
                                                                    clock = "(#{c})"
                                                                    setTimeout(counter,1000)
                                                                timer.text clock
                                                            counter()
                                                            resend.css {color:'#444'}
                                                        send = ->
                                                            AV.User.requestPasswordReset(m.o.mail, {})
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
    }

其中$.SSO.auth.password_set_mail是实现发送重置密码邮件的方法

该方法中调用了modal()函数，modal()函数在文件的开始定义,用于显示弹出窗。该调用分别传了__inline("/html/coffee/SSO/password_set_mail.html"),"purple","ssoAuthPasswordSetMail"和一个回调函数这四个参数。第一个参数是个内嵌的html，用了fis的写法；第二个参数是一个class名的一部分;第三个参数是View的id名；最后的回调函数是该方法的主体。m对象作为avalon的View方法的第二个参数传进。m中包括对象o和方法submit,对象o即为View中的变量,用于avalon变量绑定，submit()作为提交函数定义。submit()中的AV.user.requestPasswordReset函数用于LeanCloud向用户的Email地址发送重置密码邮件,它接收一个email地址字符串，一个包含成功和错误回调函数的对象。发送成功后，success方法执行，我们用$.modal_alert来提示发送成功，弹出框里我们可以点击链接查看邮箱网站，也可以点击链接重新发送重置密码邮件。重发邮件每隔1分钟可点击一次，该部分效果写在onshow方法里。如果发送邮件失败，error方法执行，接收参数_error(加下划线用于区分error,error用于定义错误提示对象，在一定的情况下显示一定的错误信息。),然后根据错误提示码显示出错提示信息,其中$.error_tip()用于提示出错。

