$.minisite.member = AV.User.logined ->
    AV.Cloud.run(
        "SiteUserLevel.by_site_id"
        {site_id:SITE.ID}
        (member)->
            _li=[]
            for [id,name,level] in member
                _li.push {
                    title:level
                    name
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
                    error_tip = $.error_tip(elem)
                    [
                        {
                            add:{
                                    title:1000
                                    name:""
                                }
                        }
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

