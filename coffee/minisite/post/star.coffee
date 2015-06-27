$.minisite.post.star = (elem)->
    self = $ elem
    post = window._POST[elem.rel]
    kwds = {post_id:post.objectId, site_id:SITE.ID}
    star0 = 'star0'
    star1 = 'star1'
    a = $("a.star[rel=#{post.ID}]")
    if AV.User.current()
        if self.hasClass star0
            a.removeClass(star0).addClass star1
            func = "new"
            kwds.tag_list = post.tag_list
            post.is_star = 1
        else
            a.removeClass(star1).addClass star0
            func = "rm"
            post.is_star = 0
             
        AV.Cloud.run "PostStar.#{func}", kwds
    else
        $$('SSO/auth.new_or_login')

