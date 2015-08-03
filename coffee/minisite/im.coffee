elem = $ __inline("/html/coffee/minisite/im.html")
$('body').append elem

main = elem.find('.main')
main.scrollbar()

Rbar = elem.find('.Rbar')
Rbar.scrollbar()

new Headroom(
    elem.find(".headroom")[0],
    {
        offset: 66
        tolerance: 1
        scroller : main[0]
        classes: {
            "initial": "animated",
            "pinned": "swingInX",
            "unpinned": "swingOutX"
        }
    }).init()
