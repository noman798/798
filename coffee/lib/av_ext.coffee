###
@require /lib/nprogress/nprogress.js 
###

AV.User.logined = (func)->
    (params...)->
        if AV.User.current()
            return func.apply @,params
        else
            $ ->
                $$("SSO/auth.new_or_login")

_RUNING = {}

AV.NProgress = (func) ->
    (name, data, options)->
        key = name+JSON.stringify(data)
        if _RUNING[key]
            return
        _RUNING[key] = 1
        NProgress.inc()
        if $.isFunction options
            options = {
                success:options
            }
        error = options.error
        options.error = ->
            delete _RUNING[key]
            NProgress.done()
            error?.apply @, arguments
               
        success = options.success
        options.success = ->
            delete _RUNING[key]
            NProgress.done()
            success?.apply @, arguments
        func(name,data,options)


_run  = (run)->
    (name, data, options={})->

        if options.fail
            options.error = (error) ->
                options.fail error.message
        
        error = options.error

        options.error = (_error) ->
            if _error.code == 403 and _error.message == 403
                $$ "SSO/auth.login"
            else
                error?.call @, _error
        
        run(name,data,options)

AV.Cloud._run = _run AV.Cloud.run
AV.Cloud.run = _run AV.NProgress(AV.Cloud.run)

