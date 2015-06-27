如何贡献代码
--------------------------------

如果你想给798项目贡献代码，请遵循以下步骤

然后修改一下hg配置文件 ::
    
    vi ~/.hgrc

修改 ::

    username = undefined <undefined@798.com>

修改为你自己的昵称和邮箱

然后运行 ::

    ssh-keygen

一路回车生成你自己的公私钥， 然后 ::

    cat ~/.ssh/id_rsa.pub

然后注册 `bitbucket <HTTPS://BITBUCKET.ORG>`_  , 将这个公钥贴到 右上角头像 > Manage account -> 左侧栏 SSH keys -> Add Keys ，Label可以留空，内容为上面cat显示的公钥。

#. 注册 bitbucket 账户
#. 访问 https://bitbucket.org/798/798/fork fork 项目 798 
#. 修改 hgrc
#. 运行ssh-keygen生成私钥，并配置bitbucket的ssh私钥
#. 提交pull-request
