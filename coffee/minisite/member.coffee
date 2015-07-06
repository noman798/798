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
                                    success: ([user_id,name])->
                                        level = V.Member.add.level
                                        for i in V.Member.li
                                            if i.id == user_id
                                                i.level = level
                                                return
                                        V.Member.li.$add {
                                            user_id
                                            name
                                            level
                                        }
                                }
                                V.Member.add.username = ''
                                V.Member.add.level = 800
                                false
                            rm:(el)->
                                alertify.confirm "真的要移除 #{$.escape el.name} 的所有权限？",(ok)->
                                    if ok
                                        el.level = 0
                        },
                        (v)->
                            current = AV.User.current()
                            current_id = current.id
                            v.li.$add = (el) ->
                                v.li.unshift el
                                _watch v.li[0]
                            _watch = (i)->
                                i.$watch 'level', (nv, ov)->
                                    if @_changing
                                        @_changing = 0
                                        return
                                    count = 0
                                    for _i in v.li
                                        if _i.level == CONST.SITE_USER_LEVEL.ROOT
                                            count=1
                                            break
                                    if ov == CONST.SITE_USER_LEVEL.ROOT
                                        if count == 0
                                            @_changing = 1
                                            @level = ov
                                            alertify.alert("至少有一个管理员")
                                            return
                                        if @id == current_id
                                            alertify.confirm "<p>真的要删除自己的管理员权限？</p><p>删除后，您将不能再修改团队成员！</p>",(ok)=>
                                                if ok
                                                    elem.modal('hide')
                                                else
                                                    @_changing = 1
                                                    @level = ov
                                                    nv = ov
                                    if nv == ov
                                        return
                                    if @id == current_id
                                        SITE.SITE_USER_LEVEL = nv
                                    AV.Cloud.run "SiteUserLevel.set_by_user_id", {
                                        user_id:@id
                                        site_id:SITE.ID
                                        level:@level
                                    }
                            for i in v.li
                                _watch i
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

