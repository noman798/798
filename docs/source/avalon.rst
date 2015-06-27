avalon - 前端
=====================================

avalon是很好用的双向绑定框架。

为了方便使用，我们做了一些小修改。

首先，ms-controller 改名叫做 ms-view ，我们觉得 controller 这个单词太长了。

其次，事件的回调函数中 return false 可以阻止事件继续传播 , 这可以jquery的使用习惯保持一致。

然后，为了方便不同的 view (controller) 之间相互调用，我们引入了一个全局变量 V 指向 avalon.vmodels 。

最后，我们因为已经使用了百度fis提供的mod作为require加载器，所以我们使用的avalon的shim版本。


