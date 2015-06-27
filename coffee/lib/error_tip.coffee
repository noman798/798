_error_tiper = (elem) ->
    return {
        set: (txt)->
            elem.addClass('error')
            txt = $.trim txt
            message = elem.find('.message')
            if txt
                if not message[0]
                    message = $('<div class="message" style="display:none">')
                    elem.append(message)
                message.stop(true).html(txt).fadeIn()
            else
                message.remove()
        reset:->
            message = elem.find('.message').fadeOut ->
                message.remove()
                elem.removeClass('error')
    }

$.error_tip = (o, focus=1) ->
    elem = $(o)
    if not elem[0]
        return
    kv = []
    return {
        reset : () ->
            for i in kv
                i.reset()
            kv = []
        set : (o) ->
            @reset()
            
            count = 0

            for k, v of o
                count += 1
                t = elem.find("[name=#{k}]") #:visable
                if not t[0]
                    console.log "[name=#{k}] NOT FOUND ! ERROR #{v}"
                    continue
                
                explain = t.parents('.field')
                if explain.length
                    tiper = _error_tiper(explain)
                    tiper.value = t.val()
                else
                    console.log "[name=#{k}] parents feild NOT FOUND ! ERROR #{v}"
                    continue

                if t[0].tagName == "INPUT" or t[0].tagName == "SELECT"

                    if t[0].type == "checkbox"
                        event = "change"
                    else
                        event = "keydown"
                    t[0]._tiper = tiper

                    t.bind("#{event}.error", ->
                        if @value != @_tiper.value
                            @_tiper.reset()
                            $(@).unbind("#{event}.error")
                    )

                tiper.set(v)
                kv.push tiper
                if focus
                    for i in elem.find('.error')
                        input = $(i).find('input')
                        if input[0]
                            type = input[0].type
                            if type!="checkbox" and type!="radio"
                                input.focus().select()
                                break
            return count
    }

