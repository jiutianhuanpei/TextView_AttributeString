//
//  SHBAttachMent.h
//  TextView
//
//  Created by 沈红榜 on 16/2/18.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SHBAttachMentType) {
    SHBAttachMentTypeImage,
    SHBAttachMentTypeVoice,
    SHBAttachMentTypeVideo,
};

@interface SHBAttachMent : NSTextAttachment

@property (nonatomic, assign) SHBAttachMentType     type;
@property (nonatomic, strong) UIImage               *originalImage;
@property (nonatomic, copy)   NSString              *realUrl;

@end
