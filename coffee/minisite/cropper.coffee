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
                    that=$(this)
                    $("#test").change ->
                        uploader.upload(@files)
                        uploader.on('uploadcomplete',(e,@files,responseText)->
                            console.log @files.xhr.responseJSON.key,responseText
                            $('.cropper .cropper-canvas > img').attr('src',"http://7xjfna.com1.z0.glb.clouddn.com/#{@files.xhr.responseJSON.key}")
                            $('.cropper .cropper-view-box > img').attr('src',"http://7xjfna.com1.z0.glb.clouddn.com/#{@files.xhr.responseJSON.key}")
                            )
                                
                        uploader.readImageFile(@files,(o)->
                            
                            editor=new MediumEditor('.editable')
                            $('.editable').mediumInsert({editor:editor})
                        )
                    w=$('.cropper .cropper-canvas > img').width()
                    h=$('.cropper .cropper-canvas > img').height()
                    $('.slide input[type="range"]').change ->
                        v=$(this).val()
                        that.cropper('setCanvasData',{width:w*v,height:h*v})
                    $('.upload').find('.icon-upload').click ->
                        $('#test').click()
            })
            {}
    )
