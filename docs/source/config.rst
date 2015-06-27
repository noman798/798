手工配置开发环境
========================================

生成配置文件
-----------------------------------------


首先创建主配置文件::

    cp 798/cli/docker/config.example.py 798/cli/docker/config.py

修改 config.py 中的 HOST ， 然后生成nginx和fis（pure）的配置文件 ::

    /798/cli/docker $ python make_config.py

这个脚本会输出生成的配置文件的路径。

然后打开nginx的配置文件::

    sudo vi /etc/nginx/nginx.conf

在http段的靠前位置加入::

   include /home/web/798/build/nginx.conf 

其中，include后面的路径应为你实际生成nginx配置文件的路径。

然后重启nginx ::

    sudo /etc/init.d/nginx restart
