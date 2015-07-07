$.minisite.manage = (rel)->

    html = $ __inline("/html/coffee/minisite/postmanage.html")

    $.modal(
        html.html()
        {
            dimmerClassName:'read'
        }
        "PostManage"
        (elem)->
            $("#PostManage .leftside").scrollbar()
            $("#PostManage .rightside").scrollbar()

            AV.Cloud.run(
                "Space.by_host"
                {
                    host:location.host
                }
                error : ->
                    if location.host != CONST.HOST
                        location.href = "//#{CONST.HOST}"
                success : (site) ->
                    SITE = {}
                    [
                        SITE.id
                        SITE.name
                        SITE.name_cn
                        SITE.tag_list
                        SITE.logo
                        SITE.slogo
                        SITE.social
                    ] = site
                    AV.Cloud.run(
                        "Space.post_by_tag"
                        {tag:"",site_id:SITE.id}
                        success:(r)->
                            console.log r
                            [li, since] = r
                            
                            _ = $.html()
                            if li.length

                                _ """<h1>#{li.length} 篇文章</h1>"""
                                if rel

                                    for i in li
                                        if rel==i.objectId
                                            $("#PostManage .rightside .content").append("""<h1><span>#{i.title}</span></h1>""").append(i.html)
                                            
                                            if window.SITE.SITE_USER_LEVEL > 850
                                                $("#PostManage .rightside .content").append("""<p class="author C"><i class="iconfont icon-trash"></i><span class="name"><span></span>#{i.author} · #{$.timeago  i.createdAt}</span>""")
                                            else
                                                $("#PostManage .rightside .content").append("""<p class="author C"><span class="name"><span></span>#{i.author} · #{$.timeago  i.createdAt}</span>""")
                                else
                                    $("#PostManage .rightside .content").append("""<h1><span>#{li[0].title}</span></h1>""").append(li[0].html)

                                    if window.SITE.SITE_USER_LEVEL > 850
                                        $("#PostManage .rightside .content").append("""<p class="author C"><i class="iconfont icon-trash"></i><span class="name"><span></span>#{li[0].author} · #{$.timeago  li[0].createdAt}</span>""")
                                    else
                                        $("#PostManage .rightside .content").append("""<p class="author C"><span class="name"><span></span>#{li[0].author} · #{$.timeago  li[0].createdAt}</span>""")

                                toggle=0
                                $('.rightside #ribbon').click ->
                                    if toggle==0
                                        $(this).parent().addClass("show")
                                        toggle=1
                                    else if toggle==1
                                        $(this).parent().removeClass("show")
                                        toggle=0

                                for post,num in li
                                    if rel
                                        if rel==post.objectId
                                            _ """<p class="focus" rel="#{post.objectId}">#{post.title}</p>"""
                                        else

                                            _ """<p rel="#{post.objectId}">#{post.title}</p>"""

                                    else
                                        if num==0

                                            _ """<p class="focus" rel="#{post.objectId}">#{post.title}</p>"""
                                        else
                                            _ """<p rel="#{post.objectId}">#{post.title}</p>"""


                            else
                                _ """<h1 class="none">当前站点没有文章</h1>"""
                                $("#PostManage .rightside .content").append("""<h1 class="none">当前站点没有文章</h1>""")

                            $("#PostManage .leftside .scroll-content").append(_.html())

                            $("#PostManage .leftside").find("p").click ->
                                $(this).addClass("focus").siblings().removeClass("focus")
                                for i in li

                                    if $(this).attr("rel")==i.objectId
                                        
                                        if window.SITE.SITE_USER_LEVEL > 850
                                            $("#PostManage .rightside .content").html("""<h1><span>#{i.title}</span></h1>""").append(i.html).append("""<p class="author C"><i class="iconfont icon-trash"></i><span class="name"><span></span>#{i.author} · #{$.timeago  i.createdAt}</span>""")
                                        else
                                            $("#PostManage .rightside .content").html("""<h1><span>#{i.title}</span></h1>""").append(i.html).append("""<p class="author C"><span class="name"><span></span>#{i.author} · #{$.timeago  i.createdAt}</span>""")
                    )
            )
            {}
    )
