$.minisite.member = AV.User.logined ->
    AV.Cloud.run(
        "SiteUserLevel.by_site_id"
        {site_id:SITE.ID}
        (member)->
            _li=[]
            for [id,name,level] in member
                _li.push {
                    level
                    name
                    id
                }
            li=_li

            $.modal(
                __inline("/html/coffee/minisite/member.html")
                {
                    dimmerClassName:'read'
                    autofocus:false
                }
                "Member"
                (elem)->
                    elem.find('.scrollbar-macosx').scrollbar()
                    error_tip = $.error_tip(elem.find('form.button'))
                    [
                        {
                            li
                            add:{
                                level:800
                                username:""
                            }
                            add_submit:->
                                AV.Cloud.run "SiteUserLevel.set", $.extend({site_id:SITE.ID},V.Member.add.$model), {
                                    fail: (error) ->
                                        error_tip.set error
                                }
                                V.Member.add.username = ''
                                V.Member.add.level = 800
                                false
                        }
                        (v)->
                            current = AV.User.current()
                            current_id = current.id

                            for i in v.li
                                i.$watch 'level', (nv, ov)->
                                    count = 0
                                    for _i in v.li
                                        if _i.level == CONST.SITE_USER_LEVEL.ROOT
                                            count+=1
                                    if ov == CONST.SITE_USER_LEVEL.ROOT
                                        #if count <= 1
                                        #    @level = ov
                                        #    alertify.alert("至少有一个管理员")
                                        #    return
                                        if @id == current_id
                                            alertify.confirm "<p>真的要取消自己的管理员权限？</p><p>取消后，您将不能再修改团队成员！</p>",(ok)->
                                                if not ok
                                                    @level = ov
                                                    return
                                                else
                                                    elem.modal('hide')


                    ]
                    #[
                    #    {
                    #        click:->
                    #            error={}
                    #            if V.Member.add.name

                    #                AV.Cloud.run(
                    #                    "SiteUserLevel.set"
                    #                    {username:V.Member.add.name,site_id:SITE.ID,level:V.Member.add.title}
                    #                    success:(member)->
                    #                        V.Member.li.push {
                    #                            title:V.Member.add.title
                    #                            name:V.Member.add.name
                    #                        }
                    #                        V.Member.add.name=""
                    #                    error:(_error)->
                    #                        if _error
                    #                            error.username="没有找到该用户"

                    #                        error_tip.set error
                    #                )
                    #            else
                    #                error.username="请输入他的昵称、邮箱或手机号"
                    #                error_tip.set error
                    #                
                    #        li
                    #        rm:(el)->
                    #            if confirm "确认要删除团队成员 #{el.name} 吗?"

                    #                console.log V.Member.li
                    #                for i,_ in V.Member.li

                    #                    if i.name == el.name

                    #                        AV.Cloud.run(
                    #                            "SiteUserLevel.set"
                    #                            {username:el.name,site_id:SITE.ID,level:0}
                    #                            (member)->
                    #                                V.Member.li.splice _,1
                    #                        )
                    #    }
                    #    (v)->
                    #        console.log window.SITE.SITE_USER_LEVEL
                    #]
            )
    )

