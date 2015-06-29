配置开发环境
=======================================

基础知识
---------------------------------------

如果你连SSH登录Linux都不会，不妨看一看以下教程 

* `windows用户 - xshell入门使用教程 <http://jingyan.baidu.com/article/295430f13fb4db0c7f005065.html>`_
* `mac iTerm2 使用指南 <http://note.youdao.com/share/?id=14cf561e686b889a495c0e9ebeb3e270&type=note>`_ 
 
向服务器上传文件

* `FileZilla使用 SFTP-SSH协议向服务器上传文件 <http://note.youdao.com/share/?id=a6578268d247d5981e7f49dc337ba318&type=note>`_

  
运行docker镜像
---------------------------------------

配置开发环境是一个既繁琐又无趣的事情。

人生漫漫，有很多山峰等值我们去征服。但毫无疑问，配置开发环境不是其中之一。

| 我们希望尽可能去简化这一部分工作，所以我们用Docker对开发环境进行了打包。
| 执行几个小命令，就可以获得“开箱即用”(Batteries Included)的环境。

| Docker是一种虚拟机中的虚拟机，它可以运行在云服务器的虚拟机中，并且本身没有性能损耗。
| Docker的强大之处不是我们今天的主题。
| 大家请参考 `Docker中文指南 <http://www.widuu.com/chinese_docker/>`_ 自行安装Docker。


我们以基于Centos7.0为例讲讲一下部署步骤。

大家可以在 `QingCloud <https://www.qingcloud.com>`_ 上开启一个全新的Centos7.0系统运行该脚本。

以下各步骤都以root身份运行。

如果不是root用户，可以先sudo su切换到root用户 ::

    sudo su

我们先更新升级系统 ， 安装 docker 和 hg ::

    yum update -y
    yum install epel-release -y
    yum install docker mercurial nginx tmux -y

然后启动 docker ，并添加到开机启动 ::
    
    service docker start
    service nginx start
    systemctl enable docker
    systemctl enable nginx 

因为众所周知的原因，国内的docker被墙了，我们需要启用一下加速服务

访问 `DaoCloud的docker加速服务器 <https://dashboard.daocloud.io/mirror>`_ （登录后点此链接），按照网页底部的 操作手册->Centos 篇配置一下docker加速服务器。

接下来，我们pull最新798的镜像。

这个需要的时间比较漫长，我们通过nohup让其在后台一直运行，这段时间，我们可以断开ssh去睡觉了。 ::

    nohup docker pull 798space/798 &

我们可以通过tail来观察pull的进度( Ctrl+\ 退出观察) ::

    tail -f nohup.out

如果出现以下文字就是更新完毕::

    Status: Downloaded newer image for 798/798:latest

我们可以通过 docker images 浏览看到 798 镜像。

如果出现问题可以重新pull一下，多尝试几次也许就好了。



接下来我们用hg clone下我们开发环境的home目录 ，并且启动docker ::

    mkdir -p /home/
    cd /home/
    hg clone git+ssh://git@github.com:noman798/798.git
    rm -rf /home/798/.hg
    cd /home/798/
    hg clone https://bitbucket.org/798space/798

最后启动docker ::

    docker run -d -i -p 4242:4242 \
    -p 10922:22 -p 10900:10900 -p 10901:10901 \
    -p 10902:10902 -v /home:/home --name 798 \
    798space/798 /etc/init.d/ssh start -D

注意，你需要配置云主机的防火墙，暴露 10922 , 4242 端口以便于我们从远程ssh访问登录docker镜像和修改html后浏览器自动刷新。

启动后，我们可以通过 ::
    
    docker ps

看到我们正在运行的docker

关机后重启这个docker镜像的命令是 ::
    
    docker start 798

然后我们就可以ssh登录进入docker ::

    ssh 798@127.0.0.1 -p10922

127.0.0.1 也可以改为你服务器远程访问的IP

docker的798用户默认的密码是 798devos

登录进入docker镜像后，我们先修改一下文件权限 ::

    sudo chown 798:798 /home/798 -R

然后我们需要生成一下nginx的配置文件 ::

    cd ~/798/cli/docker
    cp config.example.py config.py


你可以编辑config.py ::

    vi config.py

修改域名为你自己域名。如果你想启用真实的域名，请将裸域名和泛域名都指向这台服务器

如果只是为了开发，可以保留原来的测试域名，然后在本机修改hosts文件指向此服务器。

如何配置hosts ?
******************************************


windows用户用笔记本打开 ::

    C:\Windows\System32\drivers\etc\hosts

mac和linux用户请修改 /etc/hosts

在末尾添加3个域名 ，其中IP改为你自己服务器的IP，域名为你自己配置的域名，ministe.xxx通过798.space创建的垂直社区的域名，可以是任意域名 ::

    192.168.10.169 798.space 
    192.168.10.169 798-docs.798.space 
    192.168.10.169 minisite.xxx 


生成配置文件
******************************************

运行脚本生成配置文件 ::

    python ~/798/cli/docker/make_config.py


注意，因为我们的vim默认配置了折叠插件，命令模式下zn可以打开折叠

然后我们 ** 回到docker的母机 ** ，修改nginx的配置文件 ::
   
    vi /etc/nginx/nginx.conf

删除配置文件最后整个 server 那一大段（因为default server冲突）

然后软链nginx的配置文件，重启nginx服务器 ::

    cd /etc/nginx/conf.d
    ln -s /home/798/798/build/nginx.conf 798.conf
    service nginx restart


OK，大功告成。

我们回到docker服务器中，启动开发环境 ::

    cd ~/798
    ./cli/dev

你应该可以看到网页了，COOL !

如何发布到线上？
******************************************

还是先编辑 /cli/docker/config.py

修改HOST域名为线上服务器的域名，修改STATIC_HOST为静态文件服务器的域名。

其中STATIC_HOST静态文件最好是与主站完全不同的根域名，这可以避免http请求头中总是包含cookie的开销。

我们建议使用 `七牛云存储 <https://qiniu.com>`_  的 空间设置 -> 镜像存储，直接镜像主域名，做它的CDN的反向代理，以加速访问。

同时还建议在启用其 空间设置 -> 域名设置 中的 HTTPS， 然后就把这个支持https的qbox.me的域名作为STATIC_HOSTd的域名即可。

完成以上步骤后，运行 make_config.py 生成配置文件。重启母机的nginx。

然后运行 ./cli/publish 更新发布的html即可。

参考文献
-------------------

#. `用Hg操作GitHub <http://www.worldhello.net/gotgithub/06-side-projects/hg-git.html>`_

