//
//  UIColor+SHBHex.m
//  TextView
//
//  Created by 沈红榜 on 16/2/19.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "UIColor+SHBHex.h"

@implementation UIColor (SHBHex)

+ (UIColor *)shbColorWithHexString:(NSString *)string alpha:(CGFloat)alpha {
    
    // 去除空格
    NSString *color = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (color.length < 6) {
        return [UIColor clearColor];
    }
    
    if ([color hasPrefix:@"0x"]) {
        color = [color substringFromIndex:2];;
    }
    
    if ([color hasPrefix:@"#"]) {
        color = [color substringFromIndex:1];
    }
    
    if (color.length != 6) {
        return [UIColor clearColor];
    }
    
    NSString *rString = [color substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [color substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [color substringWithRange:NSMakeRange(4, 2)];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    UIColor *col = [UIColor colorWithRed:((float)r / 255.) green:((float)g / 255.) blue:((float)b / 255.) alpha:alpha];
    
    return col;
}

+ (UIColor *)shbColorWithHexString:(NSString *)string {
    return [UIColor shbColorWithHexString:string alpha:1];
}

@end
