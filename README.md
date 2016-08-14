# Group-buying-iPad
仿美团iPad版界面，数据展示来自大众点评

首页展示团购信息，下拉刷新，上拉加载更多。可以选择不同团购类型，切换区域，排序方式。
点击团购，进入详情页面。左边展示基本的团购信息，右边展示webView，团购的详情；同时支持收藏，未做分享的处理，集成了支付宝购买，但是没有项支付宝申请商户，所以还是无效的。
添加浏览历史记录，我的收藏，并且可以删除历史记录和收藏。
使用归档对数据存储，包括顶部菜单栏的选择，浏览以及收藏记录。
添加搜索功能，根据关键字，并且使用主页上选择的城市进行搜索，展示数据样式用主页一致。
添加地图搜索功能，获取用户当前位置城市，以及地图所展示区域的团购信息，自定义大头针标注在地图上；支持不同类别筛选团购信息。

注明：数据来自大众点评，经测试，团购数据有，但是比实际团购的数量少的多，不够全面。

因为多个控制器展示数据都是使用的collectionViewController展示数据，所以有多个继承关系。
父控制器XYMainDealsController实现数据源以及代理方法，
首页控制器XYDealsViewController继承父类XYMainDealsController，实现自定义导航栏，数据刷新等。
浏览记录XYHistoryDealsController，我的收藏XYCollectionDealsController,他俩使用相同的导航栏，创建新的父控制器继承XYMainDealsController，自定义导航栏，添加编辑，全选，取消，删除功能，处理相应的业务。
搜索XYSearchViewController继承XYMainDealsController

UI的布局使用xib的autolayout以及第三方的UIView+autolayouut, 多使用xib搭建UI，减少代码量，图片的拉伸则是在assects.xcassets中设置图片的水平，垂直拉伸。

