elem = $ __inline("/html/coffee/minisite/im.html")
$('body').append elem

Rbar = $ elem[0]
Rbar.scrollbar()

main = $ elem[1]
main.scrollbar()


console.log main
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

im_reply = main.find('#im_reply')
im_reply.focus ->
    autosize(im_reply)
im_reply.blur ->
    autosize.destroy(im_reply)

