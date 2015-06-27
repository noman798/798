
###
@require minisite/url 
@require minisite/init
@require /lib/AV.realtime.js
@require minisite/im
###


current_user = AV.User.current()
if current_user
    current_user.fetch()

require [
    "minisite/url",
    "minisite/init"
    "minisite/im"
]
