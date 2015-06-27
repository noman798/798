require 'lib/jquery_ext'
require 'lib/route'
require 'lib/async'
require 'lib/error_tip'
require 'lib/av_ext'
require 'lib/avalon_ext'
require 'lib/modal'

marked.setOptions({
    renderer: new marked.Renderer()
    breaks: true
    sanitize:true
})

if console
    console['log'](
        '%c本站是开源项目!\n快来参与开发吧!\n详情见 http://docs.798.space', 'color:#060;font-size:2.3em')
    console['log'](
        '%c\n\n\n\n\n'
        'line-height:50px;padding-left:320px;padding-bottom:180px;background:url(http://dn-ac08.qbox.me/coding.jpg) no-repeat 0 100% / 320px;'
    )
