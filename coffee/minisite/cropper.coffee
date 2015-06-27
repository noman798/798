$.minisite.cropper = ->
    html = $ __inline("/html/coffee/minisite/cropper.html")
    $.modal(
        html.html()
        {
            dimmerClassName:'read'
        }
        "Cropper"
        (elem)->
            $('.cropper > img').cropper({
                aspectRatio: 16 / 9,
                autoCropArea: 0.65,
                strict: false,
                guides: false,
                highlight: false,
                dragCrop: false,
                cropBoxMovable: false,
                cropBoxResizable: false,
                mouseWheelZoom:false,
                doubleClickToggle:false,
                preview:''
                built:->
                    uploader = Simple.uploader()
                    $("#test").change ->
                        uploader.upload(@files)
                        uploader.readImageFile(@files,->
                            editor=new MediumEditor('.editable')
                            $('.editable').mediumInsert({editor:editor})
                        )
                    w=$('.cropper .cropper-canvas > img').width()
                    h=$('.cropper .cropper-canvas > img').height()
                    $('.slide input[type="range"]').change ->
                        v=$(this).val()
                        console.log w,v,$('.cropper .cropper-canvas > img')
                        $('.cropper').setCanvasData({width:w*v,height:h*v})
                    $('.upload').find('.icon-upload').click ->
                        $('#test').click()
            })
            {}
    )
