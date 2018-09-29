//
//  CustomerManager.m
//  TransportPassenger
//
//  Created by Helly on 10/26/15.
//  Copyright © 2015 AnzeInfo. All rights reserved.
//

#import "CustomerManager.h"
#import "NotificationMacro.h"
#import "VendorMacro.h"
#import <YYModel.h>

@implementation CustomerManager

+ (instancetype)sharedInstance {
    
    static CustomerManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance fetchCustomerFromUserDefault];
    });
    
    return _sharedInstance;
}

- (void)saveNewDataWithCustomer:(Customer *)customer {
    NSData *encodedObject = [self.customer yy_modelToJSONData];//[NSKeyedArchiver archivedDataWithRootObject:customer];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kUserDefaultCustomer];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateCustomer {
    NSData *encodedObject = [self.customer yy_modelToJSONData];//[NSKeyedArchiver archivedDataWithRootObject:self.customer];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kUserDefaultCustomer];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateCustomerWithDictionary:(NSDictionary *)customerDictionary {
    
    self.customer = [Customer yy_modelWithJSON:customerDictionary];//[[Customer alloc] initWithDictionary:customerDictionary error:nil];
    if (self.isLogin == NO) {
        self.isLogin = YES;
    }
    
    //NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.customer];
    NSData *encodedObject = [self.customer yy_modelToJSONData];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kUserDefaultCustomer];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeCustomer {
    self.customer = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultCustomer];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fetchCustomerFromUserDefault {
    NSData *encodeObject = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultCustomer];
    
    if (encodeObject) {
        self.customer = [Customer yy_modelWithJSON:encodeObject];//[NSKeyedUnarchiver unarchiveObjectWithData:encodeObject];
    } else {
        self.customer = nil;
    }
}

- (void)setIsLogin:(BOOL)isLogin {

    if (self.customer.isLogin != isLogin) {
        self.customer.isLogin = isLogin;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginStatusChenged object:nil];
    }
    
    if (self.customer.isLogin == NO) {
        
      
        [self removeCustomer];
    }
}

- (BOOL)isLogin {
    return self.customer.isLogin;
}

@end
