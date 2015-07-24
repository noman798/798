$.lib.sideshare = {
    open : ->
        sideshare = $(".sideshare")
        if not sideshare.length
            title = encodeURIComponent(document.title)
            link = location.href+".html"
            href = encodeURIComponent(link)
            
            $("body").append """<div class="sideshare">分<br/>享<div class="shareIcon"><a href="http://connect.qq.com/widget/shareqq/index.html?url=#{href}&desc=#{title}&site=#{location.host}"><i class="iconfont icon-qq"></i></a><a href="http://www.douban.com/share/service?url=#{href}&name=#{title}" target="_blank"><i class="iconfont icon-douban"></i></a><i class="iconfont icon-weixin"></i><a target="_blank" href="http://service.weibo.com/share/share.php?language=zh_cn&url=#{href}&title=#{title} // &content=utf-8""><i class="iconfont icon-weibo"></i></a></div></div>"""

            sideshare = $(".sideshare")
            sideshare.find('.icon-weixin').hover(
                ->
                    new QRCode(
                        sideshare.find('i.icon-weixin')[0]
                        {
                            text:link
                            width:200
                            height:200
                        }
                    )
                ->
                    sideshare.find('i.icon-weixin').html('')
            )
            sideshare.find('a').click ->
                window.open(@href)
                false
        
    close: ->
        $(".sideshare").remove()
}
