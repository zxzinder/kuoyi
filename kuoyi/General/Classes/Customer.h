//
//  Customer.h
//  kuoyi
//
//  Created by alexzinder on 2018/6/5.
//  Copyright © 2018年 kuoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *district_county;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, assign) NSInteger userid;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *is_effect;
@property (nonatomic, copy) NSString *machine_class;
@property (nonatomic, copy) NSString *machinecode;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *register_class;
@property (nonatomic, copy) NSString *third_partyid;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, assign) NSInteger fabulous;
@property (nonatomic, assign) NSInteger collect;
@property (nonatomic, assign) NSInteger share;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, assign) NSInteger danmu_len;
@property (nonatomic, strong) NSString *lable_ids;

@property (nonatomic, assign) BOOL isLogin;


//"lable_ids" = "3,5,8,9";
//birthday = "<null>";
//city = "<null>";
//country = "<null>";
//createtime = 1528206357;
//"district_county" = "<null>";
//email = "<null>";
//error = 0;
//gender = 0;
//headimg = "<null>";
//id = 68;
//info = "<null>";
//"is_effect" = 1;
//"machine_class" = 2;
//machinecode = "<null>";
//"member_id" = "<null>";
//message = "\U767b\U5f55\U6210\U529f";
//mobile = 15200000001;
//nickname = "<null>";
//openid = "<null>";
//province = "<null>";
//"register_class" = 0;
//"third_partyid" = "<null>";
//uuid = b8802026273f1e6bcd1c6cb52f4b7152;

@end
