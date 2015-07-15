###
    侧栏

        顶部

            普通用户
                最新文章
                已经发布

            审核
                有待审核
                已经发布
                退回稿件


    红色代表待审核
    绿色代表已经发布 #59B122

    普通用户的文章管理的下拉

        会显示 【】投稿到首页 a target="_blank" ?

        如果已经投稿，会打上勾

        如果已经发布，会更新为
            【文章已于 2015-10-21 发布到首页】
###

$.minisite.manage  = {
    my : ->

        if SITE.SITE_USER_LEVEL >= CONST.SITE_USER_LEVEL.WRITER
            submit_bar = 2
        else
            submit_bar = 1

        _indox submit_bar,[
            [ "我的文章","by_current" ]
            [ "已经发布","by_current_published" ]
        ]
    review:->
        _indox 3,[
            [ "有待审核","by_site" ]
            [ "已经发布","by_site_published" ]
            [ "退回稿件","by_site_rmed" ]
        ]
}
_indox = (submit_bar, h1)->
    _fetch = (action, callback, params={})->
        params.site_id = SITE.ID
        AV.Cloud.run "PostInbox."+action, params, {
            success:([count, li])->
                if submit_bar != 3
                    for i in li
                        i.is_submit = !!i.is_submit
                        i.is_publish = !!i.publisher
                else if submit_bar == 3
                    for i in li
                        if i.publisher
                            i.state = 1
                        else if i.rmer
                            i.state = 2
                        else
                            i.state = 0
                r = []
                for i in li
                    r.push i
                    r.push i
                    r.push i
                    r.push i
                callback count, r
        }

        

    h1_now = h1[0][1]
    _fetch h1_now, (count,li)->

        $.modal(
            __inline("/html/coffee/minisite/manage.html")
            {
                dimmerClassName:'read'
            }
            "PostManage"
            (elem)->
                
                [
                    {
                        submit_bar
                        pub:->
                            alertify.confirm "勾选并保存文章将发布到 TECH2IPO 首页并通过 RSS 向站外发布，发布之前请确认文章标题、摘要及标签正确。"
                        sub:->
                            alertify.confirm "勾选并保存，文章将提交编辑审核，如审核通过文章将发布到 TECH2IPO 首页并通过 RSS 向站外发布，发布之前请确认标题、摘要及标签正确，编辑审核过程中可能会对您的文章做出部分修改。"
                        now : {
                            state:0
                        }
                        ribbon:{
                            show:0
                            toggle: ->
                                V.PostManage.ribbon.show = !V.PostManage.ribbon.show
                        }
                        lside:{
                            h1
                            h1_now
                            count
                            li
                            click:(el)->
                                v = V.PostManage
                                v.ribbon.show = 0
                                v.now = el
                                elem.find('.ribbon .dropdown select').val el.state
                                elem.find(".rside").scrollTop(0)
                                elem.find("textarea.tag").tagEditor('destroy').val('').tagEditor({
                                    initialTags:el.tag_list.$model
                                    placeholder:'请输入文章标签'
                                })
                                    
                                $(this).addClass("now").siblings().removeClass("now")

                            submit:->
                                v = V.PostManage
                                {title, brief, objectId, publisher, is_submit} = v.now.$model
                                tag_list = elem.find("textarea.tag").tagEditor('getTags')[0].tags
                                if submit_bar != 3

                                    if publisher
                                        action = "publish"
                                    else if is_submit
                                        action = "submit"
                                    else
                                        action = "rm"

                                else if submit_bar == 3
                                    if v.now.state==1
                                        action = "publish"
                                    else if v.now.state==0
                                        action = "save"
                                    else if v.now.state==2
                                        action = "rm"

                                AV.Cloud.run(
                                    "PostInbox."+action
                                    {
                                        site_id:SITE.ID
                                        post_id:objectId
                                        title
                                        brief
                                        tag_list
                                    },{
                                        success:(m)->

                                            v.ribbon.show = 0
                                    })
                        }
                    }

                    (v)->
                        _now = ->
                            if v.lside.li.length
                                v.lside.click v.lside.li[0]
                            else
                                v.now = {}
                                v.ribbon.show = 0
                        _now()
                        v.lside.$watch "h1_now",(nv, ov)->
                            _fetch nv, (count,li)->
                                v.lside.li = li
                                v.lside.count = count
                                _now()

                                _post_li()

                        _footer_loading = ->
                            elem.find('.lside .footer').addClass 'loading'

                        _footer_end = ->
                            elem.find(".lside .footer").removeClass 'loading'

                        _post_li = ->
                            li=v.lside.li
                            if li.length
                                lside=elem.find(".lside")
                                lside.unbind('scroll.post_li')
                                win = $(window)
                                lside.bind(
                                    'scroll.post_li'
                                    ->
                                        if (@scrollTop + 2*win.height()) > @scrollHeight
                                            _footer_loading()
                                            lside.unbind('scroll.post_li')
                                            _fetch(
                                                h1_now
                                                ([count,_li])->
                                                    if _li.length
                                                        for i in _li
                                                            v.lside.li.push i
                                                        _post_li()
                                                    else
                                                        _footer_end()
                                                {
                                                    since : li[li.length-1].ID
                                                }
                                            )
                                )
                            else
                                _footer_end()


                ]
        )

