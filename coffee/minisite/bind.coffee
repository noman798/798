$.minisite.bind = AV.User.logined (bind_id)->
    AV.Cloud.run(
        "Oauth.by_user"
        {}
        (li)->
            _li = []

            for [id,kind,name,update] in li
                _li.push {
                    id,kind,name
                    syncing:0
                    syncing_count:0
                    finish:0
                    binded:(bind_id==id)
                    update: $.isotime new Date(update)
                }

            li = _li

            $.modal(
                __inline("/html/coffee/minisite/bind.html")
                {
                    dimmerClassName:'read'
                    autofocus:false
                }
                "Bind"
                (elem)->
                    [
                        {
                            rm:(el)->
                                if confirm "确认要解除 #{el.name} 的绑定吗?"
                                    for i,_ in V.Bind.li
                                        if i.id == el.id
                                            V.Bind.li.splice _,1
                                        AV.Cloud.run(
                                            "Oauth.rm"
                                            {id:el.id}
                                            success:(o)->
                                                false
                                       )
                                false
                            sync:(el)->
                                el.syncing = 1
                                el.finish = 0
                                AV.Cloud.run(
                                    "EvernoteSync.sync"
                                    {id:el.id}
                                    success: ->
                                        count(el)
                                )

                                count =(el)->
                                    setTimeout(
                                        ->
                                            AV.Cloud._run(
                                                "EvernoteSync.count"
                                                {id:el.id}
                                                success:(num)->
                                                    if num<0
                                                        el.syncing=0
                                                        el.finish=1
                                                    else
                                                        el.syncing_count=num
                                                        count(el)
                                            )
                                        1000
                                    )

                            o:
                                app:'yinxiang'
                            binding:0
                            bind:->
                                V.Bind.binding = 1
                                location.href="#{CONST.LEANCLOUD}/oauth/#{V.Bind.o.app}/#{location.host}/#{AV.User.current().id}"
                            li
                        }
                        (v)->
                            elem.find('.scrollbar-macosx').scrollbar()

                            for i in v.li
                                if bind_id == i.id
                                    v.sync(i)
                    ]
            )
        )
