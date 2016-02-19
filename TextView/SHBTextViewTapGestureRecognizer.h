//
//  SHBTextViewTapGestureRecognizer.h
//  TextView
//
//  Created by 沈红榜 on 16/2/19.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBTextViewGestureRecognizerDelegate <UIGestureRecognizerDelegate>

@optional

- (void)gesture:(UIGestureRecognizer *)gesture handleTapOnURL:(NSURL *)url inRange:(NSRange)characterRange;

- (void)gesture:(UIGestureRecognizer *)gesture handleTapOnTextAttachment:(NSTextAttachment *)attachment inRange:(NSRange)characterRange;

@end

@interface SHBTextViewTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, assign) id<SHBTextViewGestureRecognizerDelegate> delegate;

@end
