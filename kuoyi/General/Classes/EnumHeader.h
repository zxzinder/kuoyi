//
//  EnumHeader.h
//  TransportPassenger
//
//  Created by  HCD on 15/10/22.
//  Copyright © 2015年 AnzeInfo. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h


typedef NS_ENUM(NSInteger, WebProtocolType) {
    kWebProtocolTypeBook             = 100001,  //书
    kWebProtocolTypeActivity                   = 100002,  //活动
    kWebProtocolTypeLesson             = 100003,  //课程
    kWebProtocolTypeSpace      = 100004,  //店
    kWebProtocolTypeStory      = 100005,  //故事
    kWebProtocolTypeArticle      = 100006,  //商品
    kWebProtocolTypeAboutUs      = 13,
    kWebProtocolTypeGuide      = 14,
    kWebProtocolTypeAgreement      = 15
};


typedef NS_ENUM(NSUInteger, BuyType) {
    AllKind = 0,
    BuyGoods = 1,
    BuyBook = 2,
    OrderHotel = 3,
    OrderLesson = 4,
    OrderActivity = 5,
    OrderSpace = 6,
    BookAndGoods = 7,
    SendDM = 8 //发送弹幕
    //0 全部  1商品 2书 3园区产品 4课程 5活动 6店铺 7书和商品（属于一类）
};
typedef NS_ENUM(NSUInteger, CollectionType) {
    PeopleCollection = 1,
    StoryCollection = 5
    //  1 人 5 故事
};
//支付页面支付类型
typedef NS_ENUM(NSUInteger, PayType) {
    PayForCarPool = 0, //景区拼车
    Other, //其他，目前其他几种类型是通过网络请求数据后的type来判断的，景区例外
};
typedef NS_ENUM(NSUInteger, LoginType) {
    OtherLogin = 0,//其他
    WechatLogin = 1,
    QQLogin = 2,
    DBLogin = 3,//豆瓣
    WBLogin = 4
};
typedef NS_ENUM(NSUInteger, CodeType) {
    RegisterCode = 1,
    ChangePhoneCode = 2,
    FindPWDCode = 3
};
typedef NS_ENUM(NSInteger,OrderType)
{
    OrderTypeAll = 0, //全部
    OrderTypeWaitPay = 1,      //待支付
    OrderTypeWaitSend = 4, //未发货
    OrderTypeSend = 5,    //已发货
    OrderTypeConfirm = 6,    //确认收货
    OrderTypeRefunding = 7,// 7 退款处理中
    OrderTypeRefunded = 8, // 8退款完成
    OrderTypeRefundChecked = 9, //9退款审核通过
    OrderTypeRefundReject = 10,// 10拒绝退款
    OrderTypeFinished = 11 // 11订单完成
};

typedef NS_ENUM(NSInteger,OrderProcess)
{
   // 常规订单状态   0待支付 1已支付 2已派车(待接驾) 3执行中 4完成 5异常结束 6已取消 8退订中（跳转订单） 9已退订（跳转订单）10 已提交 11线下处理 12 待乘车
    OrderProcessCommit = 0, //待支付
    OrderProcessPay = 1,      //支付
    OrderProcessDistribute = 2, //派车
    OrderProcessExecute = 3,    //执行
    OrderProcessFinish = 4,     //完成
    OrderProcessAbnormalEnd = 5,
    OrderProcessCancel = 6,
    OrderProcessRefunding = 8,
    OrderProcessRefundEnd = 9,
    OrderProcessUpOrder = 10,
    OrderProcessOffline = 11,
    OrderProcessWaitCar = 12
};


typedef NS_ENUM(NSInteger,OrderStatus)
{


    //#滚动班次订单状态 0待支付 1待行程审核  2待确认 3待派单 4派单中 5待执行 6执行中 9完成  10待退订（退订中） 11已退订 12待乘车 13已检票 21待业务审核 22待财务确认 90待预调度 91已取消 92派单失败 93异常结束 94线下处理
    OrderStatusWaitPay = 0,
    OrderStatusWaitTripCheck = 1,
    OrderStatusWaitConfirm = 2,
    OrderStatusWaitArrange = 3,
    OrderStatusArranging = 4,
    OrderStatusWaitExecute = 5,
    OrderStatusCarExeCute = 6,//执行中
    OrderStatusUseCarFinish = 7,//用车完成
    OrderStatusCalculated = 8,  //已结算
    OrderStatusFinsh = 9,       //完成
    OrderStatusWaitRefunding = 10,
    OrderStatusReturned = 11,  //已退订
    OrderStatusWaitPassengerOn = 12,
    OrderStatusCheckedTicket = 13,
    OrderStatusWaitAdminCheck = 21,
    OrderStatusWaitFinanceCheck =22,
    OrderStatusWaitPreDispatch = 90,
    OrderStatusCanceled = 91, //已取消
    OrderStatusArrangeFail = 92,
    OrderStatusAbend =  93,  //异常结束
    OrderStatusHandleOffLine = 94
   
};

#endif /* EnumHeader_h */
