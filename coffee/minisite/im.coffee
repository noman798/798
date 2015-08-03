elem = $ __inline("/html/coffee/minisite/im.html")
$('body').append elem


new Headroom(
    elem.find(".headroom")[0],
    {
        offset: 66
        tolerance: 1
        scroller : elem.find('.main')[0]
        classes: {
            "initial": "animated",
            "pinned": "swingInX",
            "unpinned": "swingOutX"
        }
    }).init()
