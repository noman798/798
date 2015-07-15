

fis.config.set('pack', {
    "pkg/base.js":[
        "/lib/mod.js",
        "/lib/jquery.js",
        "/lib/headroom/headroom.js",
        "/lib/avalon.modern.shim.js",
        "/lib/nprogress/nprogress.js",
        "/lib/director.js",
        "/lib/jquery.cookie.js",
        "/lib/semantic/semantic.js",
        "/lib/config.js",
        "/lib/json2.js",
        "/lib/alertify.js",
        "/lib/scrollbar/jquery.scrollbar.js",
        "/lib/marked.js",
        "/lib/autosize.js",
        "/lib/qrcode.js",
        "/lib/tageditor/jquery.caret.min.js",
        "/lib/tageditor/jquery.tag-editor.js",
        "/lib/AV.realtime.js",
        "/modules/lib/jquery_ext.js",
        "/modules/lib/error_tip.js",
        "/modules/lib/async.js",
        "/modules/lib/avalon_ext.js",
        "/modules/lib/modal.js",
        "/modules/lib/av_ext.js",
        "/modules/lib/route.js",
        "/modules/lib/init.js",
    ],



    "pkg/base.css":[
        "/lib/semantic/semantic.css",
        "/lib/scrollbar/jquery.scrollbar.css",
        "/lib/headroom/headroom.css",
        "/lib/nprogress/nprogress.css",
        "/css/init.css",
    ]
});

//静态资源域名，使用pure release命令时，添加--domains或-D参数即可生效
fis.config.set('roadmap.domain', '//${CONFIG.CDN}');

//如果要兼容低版本ie显示透明png图片，请使用pngquant作为图片压缩器，
//否则png图片透明部分在ie下会显示灰色背景
//使用spmx release命令时，添加--optimize或-o参数即可生效
//fis.config.set('settings.optimzier.png-compressor.type', 'pngquant');

//设置jshint插件要排除检查的文件，默认不检查lib、jquery、backbone、underscore等文件
//使用pure release命令时，添加--lint或-l参数即可生效
fis.config.set('settings.lint.jshint.ignored', [ 'components/**', 'lib/**', /jquery|underscore/i ]);

fis.config.set('livereload.port', ${CONFIG.LIVERELOAD.PORT});

//fis-conf.js
fis.config.set('livereload.hostname', '${CONFIG.LIVERELOAD.HOST}');
//fis.config.set('settings.postpackager.simple.autoCombine', true);


fis.config.set('modules.optimizer.js', 'shutup, uglify-js');
fis.config.set('modules.postprocessor.css', 'autoprefixer');

fis.config.merge({
    settings : {
        postprocessor : {
          autoprefixer : {
              // detail config (https://github.com/postcss/autoprefixer#browsers)
              "browsers": ["Android >= 2.3", "ChromeAndroid > 1%", "iOS >= 4"],
              "cascade": true
            }
        }
    }
});


//file : path/to/project/fis-conf.js
//使用simple插件，自动应用pack的资源引用
//fis.config.set('modules.postpackager', 'simple');
//开始autoCombine可以将零散资源进行自动打包
//fis.config.set('settings.postpackager.simple.autoCombine', true);
//开启autoReflow使得在关闭autoCombine的情况下，依然会优化脚本与样式资源引用位置
//fis.config.set('settings.postpackager.simple.autoReflow', true);

//csssprite处理时图片之间的边距，默认是3px
fis.config.set('settings.spriter.csssprites.margin', 20);


//file : path/to/project/fis-conf.js
fis.config.set('modules.postpackager', 'autoload');

//useSiteMap设置使用整站/页面异步资源表配置，默认为false
fis.config.set('settings.postpackager.autoload.useSiteMap', true);

//useInlineMap设置内联resourceMap还是异步加载resourceMap，默认为false
fis.config.set('settings.postpackager.autoload.useInlineMap', false);

//通过include属性将额外的资源增加入resourceMap中
fis.config.set('settings.postpackager.autoload.include', /^\/somepath\//i);

//设置占位符
fis.config.set('settings.postpackager.autoload.scriptTag', '<!--SCRIPT_PLACEHOLDER-->');
fis.config.set('settings.postpackager.autoload.styleTag', '<!--STYLE_PLACEHOLDER-->');
fis.config.set('settings.postpackager.autoload.resourceMapTag', '<!--RESOURCEMAP_PLACEHOLDER-->');
