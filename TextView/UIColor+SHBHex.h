//
//  UIColor+SHBHex.h
//  TextView
//
//  Created by 沈红榜 on 16/2/19.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SHBHex)

+ (UIColor *)shbColorWithHexString:(NSString *)string alpha:(CGFloat)alpha;
+ (UIColor *)shbColorWithHexString:(NSString *)string;

@end
