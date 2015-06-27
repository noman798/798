$.minisite.manage = ->

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
                            [li, since] = r
                            
                            _ = $.html()
                            if li.length
                                _ """<h1>#{li.length} 篇文章</h1>"""
                                $("#PostManage .rightside .content").append("""<h1><span>#{li[0].title}</span></h1>""").append(li[0].html)
                                toggle=0
                                $('.rightside #ribbon').click ->
                                    if toggle==0
                                        $(this).parent().addClass("show")
                                        toggle=1
                                    else if toggle==1
                                        $(this).parent().removeClass("show")
                                        toggle=0

                                for post,num in li
                                    if num==0

                                        _ """<p class="focus" rel="#{num}">#{post.title}</p>"""
                                    else
                                        _ """<p rel="#{num}">#{post.title}</p>"""

                            else
                                _ """<h1 class="none">当前站点没有文章</h1>"""
                                $("#PostManage .rightside .content").append("""<h1 class="none">当前站点没有文章</h1>""")

                            $("#PostManage .leftside .scroll-content").append(_.html())

                            $("#PostManage .leftside").find("p").click ->
                                $(this).addClass("focus").siblings().removeClass("focus")
                                $("#PostManage .rightside .content").html("""<h1><span>#{li[$(this).attr("rel")].title}</span></h1>""").append(li[$(this).attr("rel")].html)
                            
                    )
            )
            {}
    )
