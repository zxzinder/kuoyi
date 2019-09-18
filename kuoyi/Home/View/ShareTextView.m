//
//  ShareTextView.m
//  kuoyi
//
//  Created by alexzinder on 2019/9/18.
//  Copyright © 2019 kuoyi. All rights reserved.
//

#import "ShareTextView.h"

@implementation ShareTextView

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 2;
    return originalRect;
}


@end
