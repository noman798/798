常用js函数
=======================================

NProgress.js
---------------------------------------

显示进度条::

    NProgress.start()
    
设定一个百分比::
    
    NProgress.set(0.4)

增加一点进度::
    
    NProgress.inc()

完成进度::
    
    NProgress.done()

store.js
---------------------------------------

store.js 是一个兼容所有浏览器的 LocalStorage 包装器，不需要借助 Cookie 或者 Flash。store.js 会根据浏览器自动选择使用 localStorage、globalStorage 或者 userData 来实现本地存储功能。

相关链接 :

    * `store.js的API <http://www.cnblogs.com/lhb25/p/store-js-for-localstorage.html>`_

__uri
---------------------------------------

js中，可以使用编译函数__uri(path)来定位资源，fis分析js文件或html中的script标签内内容时会替换该函数所指向文件的线上url路径。
如，源码::

    js = __uri('demo.js')

编译后::

    js = '/demo_33c5143.js'

798.coffee
---------------------------------------

解释一下该文件的代码

其中的::

    clientWidth = $(window).width()
    if clientWidth < 414
        scale = (clientWidth/414)
        document.write("<style>body{zoom:#{scale}}</style>")

用于做对手机的适配

其中的::

    if current_user
        current_user.fetch()
        src = __uri("/modules/798/login1.js")
    else
        src = __uri("/modules/798/login0.js")

    document.write("""<script src="#{src}"></script><script>require("798/login#{!!current_user-0}")</script>""")

当用户登录时，引用login1.js

当用户未登录时，引用login0.js


require.js的用法
---------------------------------------

引入require.js的原因：当我们要引用多个js文件时，首先，加载的时候，浏览器会停止网页渲染，加载文件越多，网页失去响应的时间就会越长；其次，由于js文件之间存在依赖关系，因此必须严格保证加载顺序，依赖性最大的模块一定要放到最后加载，当依赖关系很复杂的时候，代码的编写和维护都会变得困难。而require.js的异步加载方式和依赖加载方式能够很好地解决这一问题。

在coffee中引入依赖模块的写法::

    require_async(
       ["jquery","wow"]
        ->
           ... 
    ) 

其中require_async接收两个参数，一个是数组，数组元素即是依赖模块文件（省略.js);另一个是回调函数，当前面指定的模块都加载成功后，它将被调用。

有关模块化编程的相关链接 :

    * `模块的写法 <http://www.ruanyifeng.com/blog/2012/10/javascript_module.html/>`_

    * `AMD规范 <http://www.ruanyifeng.com/blog/2012/10/asynchronous_module_definition.html/>`_

    * `require.js的用法 <http://www.ruanyifeng.com/blog/2012/11/require_js.html/>`_





弹出窗效果modal.coffee
---------------------------------------

文件目录coffee/lib/modal.coffee

文件共两个调用函数：

    $.modal,$.modal_alert
    
$.modal接收四个参数，分别是html代码，semantic UI modal模块的配置option对象(可选，默认为空对象)，avalon view的id(可选)，view对应的回调函数(可选)。$.modal无返回值。

$.modal_alert接收两个参数，分别是html代码，semantic UI modal模块的配置option对象(可选，默认为空对象)

两者效果都是弹出框，前者是一般性的弹出框，后者弹出"我知道了"作为确认提示.

出错提示工具$.error_tip()
---------------------------------------

工具所在文件coffee/lib/jquery_ext.coffee

$.error_tip()接收两个参数，分别是出错提示对象elem，focus出错时是否选中文本并focus第一个出错位置。


引入js工具$$
---------------------------------------

工具所在文件coffee/lib/async.coffee

为了方便调用注册，登录等模块，我们经常将其写成js，并用$$工具引入。

$$引入的js有其固定的写法，当coffee文件的位置为 coffee/SSO/auth.coffee时，该文件的开头写成::

    $.SSO.auth = {
        new : ->
            ...
        login : ->
            ...
            }

可以用$$('SSO/auth.new')和$$('SSO/auth.login')调用

fail
---------------------------------------

一般向LeanCloud发送请求时，返回错误信息用error接收，但是我们补充用fail改写error接收。

具体查看coffee/lib/av_ext.coffee文件
