Route(

    "/-([^!]+)" : (src)->
        $$ src
    "/-([^!]+)!(.+)" : (src, params)->
        params = $.parseJSON(decodeURIComponent(params))
        if not $.isArray params
            params = [params]
        params.unshift src
        $$.apply $$,params
)

