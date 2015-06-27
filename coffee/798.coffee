###
@require minisite/url 
###
require "minisite/url"
NProgress.inc()

$ ->
    NProgress.done()

clientWidth = $(window).width()
if clientWidth < 414
    scale = (clientWidth/414)
    $("body").css({zoom:scale})

current_user = AV.User.current()

if current_user
    current_user.fetch()
    require.async "798/login1"
else
    window.Route.init()
    require.async "798/login0"



