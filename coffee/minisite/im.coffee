elem = $ __inline("/html/coffee/minisite/im.html")
$('body').append elem

Notification = window.Notification || window.mozNotification || window.webkitNotification

notification = ->


Notification.requestPermission(
    (permission) ->
        if permission
            notification = (name, body)->
                instance = new Notification(
                    name, {
                        body
                    }
                )

)

#instance.onclick = function () {
#    // Something to do
#};
#instance.onerror = function () {
#    // Something to do
#};
#instance.onshow = function () {
#    // Something to do
#};
#instance.onclose = function () {
#    // Something to do
#};

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

setTimeout(
    ->
        notification("张沈鹏","<b>你知道吗?</b>你知道吗?你知道吗?你知道吗?你知道吗?你知道吗?")
    100
)
