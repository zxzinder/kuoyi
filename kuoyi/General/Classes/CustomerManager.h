//
//  CustomerManager.h
//  TransportPassenger
//
//  Created by Helly on 10/26/15.
//  Copyright © 2015 AnzeInfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface CustomerManager : NSObject

@property (nonatomic, strong) Customer *customer;

@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)sharedInstance;

- (void)saveNewDataWithCustomer:(Customer *)customer;

- (void)updateCustomer;

- (void)updateCustomerWithDictionary:(NSDictionary *)customerDictionary;

@end
