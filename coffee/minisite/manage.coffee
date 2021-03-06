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
    my : (post_id)->

        if SITE.SITE_USER_LEVEL >= CONST.SITE_USER_LEVEL.WRITER
            submit_bar = 2
        else
            submit_bar = 1

        _indox post_id, submit_bar,[
            [ "我的文章","by_current" ]
            [ "已经发布","by_current_published" ]
        ]
    review:(post_id)->
        if post_id
            _indox post_id, 3,[
                [ "已经发布","by_site_published" ]
                [ "有待审核","by_site" ]
                [ "退回稿件","by_site_rmed" ]
            ]
        else
            _indox  post_id,3,[
                [ "有待审核","by_site" ]
                [ "已经发布","by_site_published" ]
                [ "退回稿件","by_site_rmed" ]
            ]

}
_indox = (post_id, submit_bar, h1)->

    _parser = (i)->
        i.brief = i.brief or ''
        if submit_bar == 3
            if i.rmer
                i.state = 2
            else if i.publisher
                i.state = 1
            else
                i.state = 0
        i.is_submit = !!i.is_submit
        i.is_publish = !!i.publisher

    _fetch = (action, callback, params={})->
        params.site_id = SITE.ID
        AV.Cloud.run "PostInbox."+action, params, {
            success:([count, li])->
                for i in li
                    _parser i
                callback count, li
                $("#PostManage .lside").scrollbar()
        }
        
    _render = (fetch)->
        h1_now = h1[0][1]
        fetch h1_now, (count,li)->
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
                            edit:->

                            pub:->
                                alertify.confirm "勾选并保存文章将发布到 #{$.escape SITE.NAME} 首页并通过 RSS 向站外发布，发布之前请确认文章标题、摘要及标签正确。"
                            sub:->
                                alertify.confirm "<p>勾选并保存，文章将提交编辑审核，如审核通过文章将发布到 #{$.escape SITE.NAME} 首页并通过 RSS 向站外发布<p><p>发布之前请确认标题、摘要及标签正确，编辑审核过程中可能会对您的文章做出部分修改。</p>"
                            rm:->
                                alertify.confirm "<h1>确定要删除此篇文章吗？</h1>",(m)->
                                    if m
                                        v = V.PostManage

                                        _rm = (i,_pos)->
                                            if i.ID==v.now.ID
                                                AV.Cloud.run(
                                                   "Post.rm"
                                                    {
                                                        site_id:SITE.ID
                                                        id:v.now.objectId
                                                    },{
                                                        success:(m)->
                                                            if _pos == 0
                                                                pos = 1
                                                            else
                                                                pos = _pos-1
                                                            if v.lside.li[pos]
                                                                v.lside.click v.lside.li[pos]
                                                            else
                                                                v.now = {}
                                                            v.lside.li.splice _pos,1
                                                            v.lside.count -= 1
                                                    })

                                        for i,_pos in v.lside.li
                                            _rm i,_pos
                            now : {}
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
                                    console.log v.now.author,v.now.owner
                                    if el.ID
                                        v.now.time=$.timeago el.createdAt
                                        elem.find('.rside .author .name i').html v.now.time
                                        elem.find('.publish .dropdown select').val el.state
                                        elem.find(".rside").scrollTop(0).scrollbar()
                                        elem.find("textarea.tag").tagEditor('destroy').val('').tagEditor({
                                            initialTags:el.tag_list.$model
                                            placeholder:'请输入文章标签'
                                        })
                                            

                                submit:->
                                    v = V.PostManage
                                    {title, brief, objectId, is_publish, is_submit} = v.now.$model
                                    tag_list = elem.find("textarea.tag").tagEditor('getTags')[0].tags

                                    if submit_bar == 3
                                        action = ['save','publish','rm'][v.now.state]
                                    else
                                        action = "rm"
                                        if SITE.SITE_USER_LEVEL >= CONST.SITE_USER_LEVEL.EDITOR
                                            if is_publish
                                                action = "publish"
                                        else if is_submit
                                            action = "submit"

                                    data = {
                                            site_id:SITE.ID
                                            post_id:objectId
                                            title
                                            tag_list
                                        }
                                    if brief
                                        data.brief = brief
                                    AV.Cloud.run(
                                        "PostInbox."+action
                                        data
                                        {
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

                            _post_li = ->

                                footer = elem.find(".lside .footer")

                                _footer_end = ->
                                    footer.removeClass 'loading'

                                li=v.lside.li
                                if li.length
                                    lside=elem.find(".lside")
                                    lside.unbind('scroll.post_li')
                                    win = $(window)
                                    lside.bind(
                                        'scroll.post_li'
                                        ->
                                            if (@scrollTop + 2*win.height()) > @scrollHeight
                                                footer.addClass 'loading'
                                                lside.unbind('scroll.post_li')
                                                _fetch(
                                                    h1_now
                                                    (count,_li)->
                                                        if _li.length
                                                            for i in _li
                                                                if i.ID != li[0].ID
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

                            _post_li()
                    ]
        )

    if post_id
        AV.Cloud.run "Post.by_id", {
            host:location.host
            ID:post_id
        },{
            success: (post)->
                post.tag_list = post.tag_list or []
                _parser(post)
                _render (action, callback)->
                    _fetch action, (count, li)->
                        r = [post]
                        for i in li
                            if i.ID != post.ID
                                r.push i
                        callback(count, r)
        }
    else
        _render _fetch

