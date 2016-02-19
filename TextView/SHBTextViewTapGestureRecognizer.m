//
//  SHBTextViewTapGestureRecognizer.m
//  TextView
//
//  Created by 沈红榜 on 16/2/19.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "SHBTextViewTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface UITextView (helps)

- (CGPoint)shb_pointFromTouch:(UITouch *)touch;

@end

@implementation UITextView (helps)

- (CGPoint)shb_pointFromTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    point.x -= self.textContainerInset.left;
    point.y -= self.textContainerInset.top;
    return point;
}

@end

@implementation SHBTextViewTapGestureRecognizer {
    NSTextAttachment        *_attachmant;
    NSURL                   *_url;
    NSRange                 _range;
}

@dynamic delegate;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    UITextView *textView = (UITextView *)self.view;
    
    NSAssert([textView isKindOfClass:[UITextView class]], @"view must be textView");
    
    NSTextContainer *container = textView.textContainer;
    NSLayoutManager *layoutManager = textView.layoutManager;
    
    CGPoint point = [textView shb_pointFromTouch:touch];
    
    NSUInteger characterIndex = [layoutManager characterIndexForPoint:point inTextContainer:container fractionOfDistanceBetweenInsertionPoints:nil];
    if (characterIndex >= textView.text.length) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    NSRange shbRange = [layoutManager glyphRangeForCharacterRange:NSMakeRange(characterIndex, 1) actualCharacterRange:nil];
    CGRect boundingRect = [layoutManager boundingRectForGlyphRange:shbRange inTextContainer:container];
    if (!CGRectContainsPoint(boundingRect, point)) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    _attachmant = [textView.attributedText attribute:NSAttachmentAttributeName atIndex:characterIndex effectiveRange:&_range];
    if (_attachmant) {
        return;
    }
    _attachmant = nil;
    
    _url = [textView.attributedText attribute:NSLinkAttributeName atIndex:characterIndex effectiveRange:&_range];
    if (_url) {
        return;
    }
    _url = nil;
    self.state = UIGestureRecognizerStateFailed;
}

- (void)setState:(UIGestureRecognizerState)state {
    [super setState:state];
    
    if (state == UIGestureRecognizerStateRecognized) {
        if (_attachmant) {
            if ([self.delegate respondsToSelector:@selector(gesture:handleTapOnTextAttachment:inRange:)]) {
                [self.delegate gesture:self handleTapOnTextAttachment:_attachmant inRange:_range];
            }
            
            _attachmant = nil;
        }
        if (_url) {
            if ([self.delegate respondsToSelector:@selector(gesture:handleTapOnURL:inRange:)]) {
                [self.delegate gesture:self handleTapOnURL:_url inRange:_range];
            }
            
            _url = nil;
        }
    } else {
        _attachmant = nil;
        _url = nil;
    }
}

@end
