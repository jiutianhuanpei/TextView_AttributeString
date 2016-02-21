//
//  UIImage+ResizeMagick.h
//
//
//  Created by Vlad Andersen on 1/5/13.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizeMagick)

- (UIImage *) resizedImageByMagick: (NSString *) spec;
- (UIImage *) resizedImageByWidth:  (NSUInteger) width;
- (UIImage *) resizedImageByHeight: (NSUInteger) height;
- (UIImage *) resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *) resizedImageWithMinimumSize: (CGSize) size;

/**
 *   在 图片上 合成一张图片
 *
 *   @param image
 *   @param size  要合成图片的size 可为空
 *
 *   @return 
 */
- (UIImage *)addImage:(UIImage *)image size:(CGSize)size;

@end
