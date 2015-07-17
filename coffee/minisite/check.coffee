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

$.minisite.check = (rel)->

    AV.Cloud.run "PostInbox.by_current", {site_id:SITE.ID},{
        success:(li)->
            _li=[]
            console.log li
            for i in li
                console.log i.ID,i.createAt,i.html,i.is_submit,i.kind,i.objectId,i.owner,i.tag_list,i.title,i.updateAt
                _li.push {
                    createdAt:i.createdAt
                    title:i.title
                    updatedAt:i.updatedAt
                    html:i.html
                    is_submit:i.is_submit
                    owner:i.owner
                    createAt:i.createAt
                    brief:i.brief || ''
                    objectId:i.objectId
                    tag_list:i.tag_list
                }

            $.modal(
                __inline("/html/coffee/minisite/check.html")
                {
                    dimmerClassName:'read'
                }
                "PostManage"
                (elem)->
                    
                    [
                        {
                            lside:{
                                h1:[
                                    [ "我的文章","by_current" ]
                                    [ "有待审核","by_current_published" ]
                                ]
                                h1_now : "by_current"
                                num:_li.length
                                _li
                                click:(el)->
                                    $(this).addClass("now").siblings().removeClass("now")
                                    $('.rside').find('.content').html("""<h1><span>#{el.title}</span></h1>""")
                                    $('.rside').find('.content').append(el.html)
                                    $('.publish .title').val(el.title)
                                    $('.publish .title').attr("rel",el.objectId)
                                    $('.publish .summary').val(el.brief)
                                    if window.SITE.SITE_USER_LEVEL > 850
                                        $(".rside .content").append("""<p class="author C"><i class="iconfont icon-trash"></i><span class="name"><span></span>#{el.owner} · #{$.timeago  el.createdAt}</span>""")
                                    else
                                        $(".rside .content").append("""<p class="author C"><span class="name"><span></span>#{el.owner} · #{$.timeago  el.createdAt}</span>""")
                                submit:->
                                    for i in V.PostManage.lside._li
                                        if i.objectId==$('.publish').find('.title').attr('rel')
                                            check=$('.checkbox:checked').val()
                                            if check
                                                AV.Cloud.run("PostInbox.publish",{site_id:SITE.ID,post_id:i.objectId,title:$('.publish .title').val(),brief:$('.publish .summary').val()},{success:(m)->
                                                    console.log m
                                                })
                                            else
                                                AV.Cloud.run("PostInbox.rm",{site_id:SITE.ID,post_id:i.objectId,title:$('.publish .title').val(),brief:$('.publish .summary').val()},{success:(m)->
                                                    console.log m
                                            })
                            }
                        }

                        (v)->
                            if v.lside._li.length
                                $('.rside').find('.content').append(v.lside._li[0].html)

                                if window.SITE.SITE_USER_LEVEL > 850
                                    $(".rside .content").append("""<p class="author C"><i class="iconfont icon-trash"></i><span class="name"><span></span>#{v.lside._li[0].owner} · #{$.timeago  v.lside._li[0].createdAt}</span>""")
                                else
                                    $(".rside .content").append("""<p class="author C"><span class="name"><span></span>#{v.lside._li[0].owner} · #{$.timeago  v.lside._li[0].createdAt}</span>""")

                            publish=->
                                width=$('.lside').outerWidth(true)
                                $('.rside .publish').css('marginLeft',width+'px')
                                $('.rside #ribbon').css('marginLeft',width+'px')

                            publish()
                            $(window).resize ->
                                publish()

                            toggle=0
                            $('.rside #ribbon').click ->
                                if toggle==0
                                    $(this).parent().addClass("show")
                                    toggle=1
                                else if toggle==1
                                    $(this).parent().removeClass("show")
                                    toggle=0

                            fetch = (nv)->
                                
                                AV.Cloud.run "PostInbox."+nv, {site_id:SITE.ID},{
                                    success:(new_li)->
                                        li_=[]
                                        if new_li.length==0
                                            console.log v,V
                                            V.PostManage.lside._li=[]
                                            V.PostManage.lside.num=0
                                        else
                                            for i in new_li
                                                li_.push {
                                                    createdAt:i.createdAt
                                                    title:i.title
                                                    updatedAt:i.updatedAt
                                                    html:i.html
                                                    is_submit:i.is_submit
                                                    owner:i.owner
                                                    brief:i.brief || ''
                                                }
                                            V.PostManage.lside._li=li_
                                            V.PostManage.lside.num=li_.length
                                }
                            v.lside.$watch "h1_now", fetch
                    ]
            )
    }
