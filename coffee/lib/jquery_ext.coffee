###
@require /lib/json2.js 
@require /lib/jquery.cookie.js 
@require /lib/scrollbar/jquery.scrollbar.css 
@require /lib/scrollbar/jquery.scrollbar.js 
@require /lib/autosize.js 
###

window.devicePixelRatio = window.devicePixelRatio or 1

(->
    _COLOR_LIST = "f44336 E91E63 9C27B0 673AB7 3F51B5 2196F3 058 039 460 060 840 c40".split(" ")
    _COLOR_LIST_LENGTH = _COLOR_LIST.length
    $.hashcolor = (tag) ->
        color_num = $.hash tag
        _COLOR_LIST[color_num%_COLOR_LIST_LENGTH]
)()

$.extend({
    hash : (str)->
        hash = 5381
        i = str.length
        while i
            hash = (hash * 33) ^ str.charCodeAt(--i)
        return hash >>> 0
    escape : avalon.filters.escape
    html : ->
        r = []
        _ = (o) -> r.push o
        _.html = -> r.join ''
        _
    txt2html : (txt)->
        r = []
        for i in txt.replace(/\r\n/g, "\n").replace(/\r/g, "\n").split("\n")
            r.push($.escape i)
        return "<p>" + (r.join("</p><p>")) + "</p>"

    isotime : (timestring) ->
      date = new Date(timestring )
      hour = date.getHours()
      minute = date.getMinutes()
      hour = "0" + hour  if hour < 9
      minute = "0" + minute  if minute < 9
      result = [date.getMonth() + 1, date.getDate()]
      now = new Date()
      full_year = date.getFullYear()
      result.unshift full_year  unless now.getFullYear() is full_year
      result.join("-") + " " + [hour, minute].join(":")

    timeago : (timestring) ->
      date = new Date(timestring )
      ago = parseInt((new Date().getTime() - date.getTime()) / 1000)
      minute = undefined
      if ago <= 0
        return "刚刚"
      else if ago < 60
        return ago + "秒前"
      else
        minute = parseInt(ago / 60)
        if minute < 60
            return minute + "分钟前"
        hour = parseInt(minute / 60)
        if hour < 24
            return hour + "小时前"

      jQuery.isotime(timestring).split(" ")[0]

    scrollTop : (top=0, callback)->
        $("html,body").animate(scrollTop:top, callback)
})

$.fn.extend(
    ctrl_enter : (callback) ->
        $(this).keydown(
            (event) ->
                event = event.originalEvent
                if event.keyCode == 13 and (event.metaKey or event.ctrlKey)
                    callback?()
                    false
        )
)



$( document ).ajaxError ->
      $.modal_alert '<h1><p>出错了 !</p><p><a href=".">点此这里</a> 刷新页面试试？</p></h1>'

