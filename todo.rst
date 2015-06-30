每个用户一个频道


用户订阅的频道 在leancloud上，每个用户只订阅一个自己的频道
    ->
        {
            channel:222
            www:121
        }

    #用户加入channel
    #只告诉用户有更新



---------------
投稿到首页


    侧栏

        顶部

            普通用户
                最新文章
                已经发布

            审核
                有待审核
                已经发布
                退回稿件

                
        
        底部是ICON

    红色代表待审核
    绿色代表已经发布 #59B122

    普通用户的文章管理的下拉

        会显示 【】投稿到首页 a target="_blank" ?

        如果已经投稿，会打上勾

        如果已经发布，会更新为
            【文章已于 2015-10-21 发布到首页】

        如果被退回，会重置为默认状态（并发退回提醒通知，等消息系统）


    编辑和撰稿人
        自己的文章管理
            会显示 【】发布到首页
            如果已经发布，会打上勾
    
        如果是审核页面
            会是一个下拉, 会根据当前状态显示
                ""
                退稿
                发布到首页
                #TODO 退稿和发布都会给对方推送消息提醒 




右上角的叉来一个动画效果




创建站点的时候自动新建会员



level = site_admin_level

AV.Cloud.run 'SiteAdmin.level', (level) ->
    if level >= SITE_ADMIN_LEVEL.ROOT
        pass
    elif level >= SITE_ADMIN_LEVEL.EDITOR
        pass

LEVEL_DECORATOR class SITE_ADMIN_LEVEL
    ROOT = 1000
    EDITOR = 500



        EDITOR:
        ROOT:(func)->
            self = @
            _ = (params, options)->
                DBSiteAdmin.level, (level) ->
                    if level >= SITE_ADMIN_LEVEL.ROOT
                        func.call self,params,options 
                    else
                        options?.error? {
                            code:403
                            message: 'need level '+SITE_ADMIN_LEVEL.ROOT
                        }
            _
    } 




@publish: SITE_ADMIN_LEVEL.$ROOT (params, options)->
    #TODO something


创建站点时候自动创建两个Role

管理员
编辑


SiteAdmin
    user
    site
    level

    LEVEL
        ROOT 
        EDITOR




管理员继承编辑子角色

同时设置Site的 admin_group 和 editor_group


抽取简介，同时把原来的简介html话，或者增加格式字段
让同步的日志可以显示图片 @wll

==================

0 . 更新config
1 . 默认显示印象笔记
2 . 
    "#{CONST.LEANCLOUD}/oauth/#{evernote or yinxiang}/#{CONST.HOST}/556eb0b8e4b0925e000409b9"
    "#{CONST.LEANCLOUD}/oauth/#{evernote or yinxiang}/#{CONST.HOST}/用户id"
3.   
    http://r.io/-minisite/bind.syncing!"id"

    #http://#{host}/-minisite/bind.show 

    
4.

    AV.Cloud.run 
        "Oauth.by_user"
        {}
        success: ->
            [
                [
                    id
                    类型
                    用户名
                    最后同步时间
                ]
                [
                    id
                    类型
                    用户名
                    最后同步时间
                ]
            ]
    按create at倒序排列

    Oauth.rm id
    Oauth.sync id



    oauth.sync_count id
        返回 -1 表示更新完成


        when run sync
            updateAt = 当前时间
            count = 0
            pre_count = 0

        当每同步一篇文章的 count+=1 ， 用incr函数
        当同步完成的时候 ，把count设置为-1

        如果 当前时间 - updateAt > 30s 
            if pre_count == count
                认为同步失败，设置count为-1
            else 
                更新pre_count和updateAt

        sync_count
            
        如果30秒内数量没有增加或者数量被重置为0，就认为更新已经完成 



    绑定成功，正在同步（ 已更新 32 篇 ）
    同步完成。本次更新了span.m03 32 篇文章。
    

5.  文案 -> 剑飞

6. API申请认证 -> 剑飞

7. 文章管理的页面 

8. 表单对齐

----------------------------------------

ImFriend
    from_user
    to_user
        -> 如果是群聊，to_user为null，通过room获取房间成员
    tag_list
    updated_time (默认有)
    room
    unread

    _messageReceived
        在于用户收到消息的时候，通过此会话，向服务器端发送一个transient的消息
        来重置未读数
        并拦截此消息

        'READED'

    by_user() : 根据最近联系时间倒序排列，只返回最近30天有联系过的, 最多100个, 当前用户,  每个人用户会set一个unread
    hide(to_user)
    read(to_user)
    new(to_user) : ->
        success(room.id)
        

ImLog
    room
    user
    data
    kind
    ID 自增字段

-------





ImChannelHistroy
    user
    data
    kind
        txt
        reply ->
                {
                    post_id
                    txt
                }

ImChannelUserReadCount
    channel
    user
    count

ImChannel
    name
    room
    count

ImChannelUser
    channel
    user












1. 聊天
    1. channel
    2. 用户
        历史留言
        留言未读数







unique

SiteHost -> host


标签不能有#和',",<,>,& , 引号可以被替换为 「」 『』 ♯


RSS -> Site


创建者

社区
    1-n 域名
    1-n 展示标签



    1-n 订阅的网站
        
        1-n 文章
        
        标题
        摘要
        创建时间
        来源网址
        创建者姓名
        创建者id
        正文
        正文格式
            HTML


   站点 - 文章
        所属站点


        1-n 展示标签
        1-n 回复 

    TODO
