//
//  SHBInputVifew.h
//  TextView
//
//  Created by 沈红榜 on 16/2/20.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   inputView 显示样式
 */
typedef NS_ENUM(NSUInteger, SHBInputStyle) {
    /**
     *   初始值
     */
    SHBInputStyleDefault,
    /**
     *   录音样式
     */
    SHBInputStyleRecord,
    /**
     *   停止录音样式
     */
    SHBInputStyleStop,
    /**
     *   播放样式
     */
    SHBInputStylePlay,
    /**
     *   暂停样式
     */
    SHBInputStylePause,
};

@protocol SHBInputViewDelegate <NSObject>

- (void)inputViewHasNoPower;
- (void)inputViewCancel;
- (void)inputViewSure:(NSString *)recordPath;

@end

@interface SHBInputView : UIView

@property (nonatomic, assign) id<SHBInputViewDelegate> delegate;


@end
