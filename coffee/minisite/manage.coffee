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
    _fetch = (action, options)->
        AV.Cloud.run "PostInbox."+action, {site_id:SITE.ID}, {
            success:([count, li])->
                for i in li
                    i.is_submit = !!i.is_submit
                    i.is_publish = !!i.is_publish
                options.success count, li
        }

        

    h1_now = h1[0][1]
    _fetch h1_now, {
        success:(count,li)->

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
                            now : 0
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
                                    elem.find("textarea.tag").tagEditor('destroy').val('').tagEditor({
                                        initialTags:el.tag_list.$model
                                        placeholder:'请输入文章标签'
                                    })

                                    $(this).addClass("now").siblings().removeClass("now")

                                submit:->
                                    v = V.PostManage
                                    {title, brief, objectId} = v.now.$model
                                    tag_list = elem.find("textarea.tag").tagEditor('getTags')[0].tags
                                    v.ribbon.show = 0
                                    
                                    AV.Cloud.run(
                                        "PostInbox.submit"
                                        {
                                            site_id:SITE.ID
                                            post_id:objectId
                                            title
                                            brief
                                            tag_list
                                        },{
                                            success:(m)->
                                        })
                            }
                        }

                        (v)->
                            _now = ->
                                if v.lside.li.length
                                    v.lside.click v.lside.li[0]
                                else
                                    v.now = 0
                                    v.ribbon.show = 0
                            _now()
                            v.lside.$watch "h1_now",(nv, ov)->
                                _fetch nv, (count,li)->
                                    v.lside.li = li
                                    v.lside.count = count
                                    _now()

                    ]
            )
    }

