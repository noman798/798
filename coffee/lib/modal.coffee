
###
@require /lib/avalon.modern.shim.js
@require /lib/semantic/semantic.js
###
#$.fn.modal =(parameters)->
#    )

$.modal_alert = (html, option={}) ->
    if html.indexOf("<") == -1
        html = "<h1>#{$.txt2html(html)}</h1>"

    option.closable = option.closable or false
    option.closeicon = option.closeicon or false
    $.modal("""<div class="ui basic modal">#{html}<div class="actions">
<div class="one fluid ui inverted buttons">
<div class="ui green ok basic inverted button">
<i class="checkmark icon"></i>
我知道了
</div>
</div>
</div>
</div>""", option)

#_COUNT = 0
$.modal = (html,  option, id,  callback)->
    
    

    if id
        html = $ """<div class="ui basic modal" id="#{id}" style="height:100%;">#{html}</div>"""
        html.attr("ms-view",id)
    option = option or {}
    #option.transition = option.transition or "horizontal flip"
    real = option.onHidden

    onHidden = ->
        #_COUNT -= 1
        #if 0 == _COUNT and "-" == location.pathname.charAt(1)
        #    URL()
        $(@parentNode).remove()
        if id and V[id]
            delete V[id]
       # alert html.html()

    if real
        option.onHidden = ->
            real.apply @
            onHidden.apply @
    else
        option.onHidden = onHidden

    elem = $(html)
    show = ->
        if not ("closable" of option)
            option.closable = false
        elem.modal(option).modal('show')
        elem.modal('internal',"event").keyboard = (event)->
            if 27 == event.which #ESC
                elem.modal('hide')
                event.preventDefault()

        if (not ('closeicon' of option)) or option.closeicon
            closeicon = $ '<i class="close icon">'
            elem.before closeicon
            closeicon.click ->
                closeicon.remove()
                elem.modal('hide')

        if id and callback
            r = callback(elem)
            if $.isArray(r)
                [o, view] = r
            else
                o = r
                view = undefined
            if o and not $.isEmptyObject o
                View(
                    id,
                    o,
                    view
                )

    #_COUNT += 1
    if not option.allowMultiple
        dbg = """<div class="ui dimmer modals page visible active #{option.dimmerClassName or ''}">"""
        $('body').prepend(dbg)
        ui = $(".ui.modal")
        if ui.length
            ui.modal('hide all', ->
                show()
            )
        else
            show()

