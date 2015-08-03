elem = $ __inline("/html/coffee/minisite/im.html")
$('body').append elem


new Headroom(
    elem.find(".headroom")[0],
    {
      "offset": 66,
      "tolerance": 1,
      scroller : elem.find('.main')[0]
      "classes": {
        "initial": "animated",
        "pinned": "swingInX",
        "unpinned": "swingOutX"
        }
    }).init()

$('.headroom .icon-search').click ->
    $.modal_alert '研发中，请稍后使用。。。'
    return false
