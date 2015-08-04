###
@require minisite/url
@require minisite/init
@require minisite/const
@require /lib/AV.push.js
###


current_user = AV.User.current()
if current_user
    current_user.fetch()

require [
    "minisite/const"
    "minisite/url",
    "minisite/init"
]
