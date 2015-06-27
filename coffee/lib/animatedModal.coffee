(($) ->
    _loading = 0
    $.fn.animatedModal = (options) ->
        if _loading
            return
        _loading = 1
        id = $ @
        $('body').append id
        console.log id
        #Defaults
        settings = $.extend({
            modalTarget: 'animatedModal'
            position: 'fixed'
            width: '100%'
            height: '100%'
            top: '0px'
            left: '0px'
            zIndexIn: '9999'
            zIndexOut: '-9999'
            color: '#f3f4f5'
            opacityIn: '1'
            opacityOut: '0'
            animatedIn: 'lightSpeedIn'
            animatedOut: 'lightSpeedOut'
            animationDuration: '.6s'
            overflow: 'auto'
            beforeOpen: ->
            afterOpen: ->
            beforeClose: ->
            afterClose: ->

        }, options)
        closeBt = $('.close-' + settings.modalTarget)

        afterClose = ->
            id.css 'z-index': settings.zIndexOut
            settings.afterClose()
            id.remove()
            #afterClose
            return

        afterOpen = ->
            settings.afterOpen()
            #afterOpen
            _loading = 0
            return

        id.addClass 'animated'
        id.addClass settings.modalTarget + '-off'
        #Init styles
        initStyles =
            'position': settings.position
            'width': settings.width
            'height': settings.height
            'top': settings.top
            'left': settings.left
            'background-color': settings.color
            'overflow-y': settings.overflow
            'z-index': settings.zIndexOut
            'opacity': settings.opacityOut
            '-webkit-animation-duration': settings.animationDuration
        #Apply stles
        id.css initStyles

        $('body, html').css 'overflow': 'hidden'
        if id.hasClass(settings.modalTarget + '-off')
            id.removeClass settings.animatedOut
            id.removeClass settings.modalTarget + '-off'
            id.addClass settings.modalTarget + '-on'
        if id.hasClass(settings.modalTarget + '-on')
            settings.beforeOpen()
            id.css
                'opacity': settings.opacityIn
                'z-index': settings.zIndexIn
            id.addClass settings.animatedIn
            id.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', afterOpen

        closeBt.click (event) ->
            event.preventDefault()
            $('body, html').css 'overflow': 'auto'
            settings.beforeClose()
            #beforeClose
            if id.hasClass(settings.modalTarget + '-on')
                id.removeClass settings.modalTarget + '-on'
                id.addClass settings.modalTarget + '-off'
            if id.hasClass(settings.modalTarget + '-off')
                id.removeClass settings.animatedIn
                id.addClass settings.animatedOut
                id.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', afterClose
            return
        return

    # End animatedModal.js
    return
) jQuery
