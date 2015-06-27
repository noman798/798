
###
@require /lib/director.js
###
ROUTER = 0

_COFNIG = {
    convert_hash_in_init:false
    html5history:true
}
_URLMAP = {}


window.Route = (route, config)->
    $.extend _URLMAP, route
    $.extend _COFNIG, config
    Route

window.Route.init = ->
    ROUTER = new Router(_URLMAP)
    ROUTER.configure(_COFNIG)
    ROUTER.init()

window.URL = (url="/", params...) ->
    if url != "/"
        suffix=""
        if params.length
            if params.length == 1 and not $.isArray(params[0])
                params = params[0]
            suffix = "!"+JSON.stringify params
        url = "/"+url+suffix
    ROUTER.setRoute url
