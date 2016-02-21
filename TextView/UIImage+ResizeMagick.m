//
//  UIImage+ResizeMagick.m
//
//
//  Created by Vlad Andersen on 1/5/13.
//
//

#import "UIImage+ResizeMagick.h"

@implementation UIImage (ResizeMagick)

// width	Width given, height automagically selected to preserve aspect ratio.
// xheight	Height given, width automagically selected to preserve aspect ratio.
// widthxheight	Maximum values of height and width given, aspect ratio preserved.
// widthxheight^	Minimum values of width and height given, aspect ratio preserved.
// widthxheight!	Exact dimensions, no aspect ratio preserved.
// widthxheight#	Crop to this exact dimensions.

- (UIImage *) resizedImageByMagick: (NSString *) spec
{

    if([spec hasSuffix:@"!"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        NSUInteger width = [[widthAndHeight objectAtIndex: 0] unsignedIntegerValue];
        NSUInteger height = [[widthAndHeight objectAtIndex: 1] unsignedIntegerValue];
        UIImage *newImage = [self resizedImageWithMinimumSize: CGSizeMake (width, height)];
        return [newImage drawImageInBounds: CGRectMake (0, 0, width, height)];
    }

    if([spec hasSuffix:@"#"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        NSUInteger width = [[widthAndHeight objectAtIndex: 0] unsignedIntegerValue];
        NSUInteger height = [[widthAndHeight objectAtIndex: 1] unsignedIntegerValue];
        UIImage *newImage = [self resizedImageWithMinimumSize: CGSizeMake (width, height)];
        return [newImage croppedImageWithRect: CGRectMake ((newImage.size.width - width) / 2, (newImage.size.height - height) / 2, width, height)];
    }

    if([spec hasSuffix:@"^"]) {
        NSString *specWithoutSuffix = [spec substringToIndex: [spec length] - 1];
        NSArray *widthAndHeight = [specWithoutSuffix componentsSeparatedByString: @"x"];
        return [self resizedImageWithMinimumSize: CGSizeMake ([[widthAndHeight objectAtIndex: 0] longLongValue],
                                                              [[widthAndHeight objectAtIndex: 1] longLongValue])];
    }
    
    NSArray *widthAndHeight = [spec componentsSeparatedByString: @"x"];
    if ([widthAndHeight count] == 1) {
        return [self resizedImageByWidth: [spec integerValue]];
    }
    if ([[widthAndHeight objectAtIndex: 0] isEqualToString: @""]) {
        return [self resizedImageByHeight: [[widthAndHeight objectAtIndex: 1] unsignedIntegerValue]];
    }
    return [self resizedImageWithMaximumSize: CGSizeMake ([[widthAndHeight objectAtIndex: 0] longLongValue],
                                                          [[widthAndHeight objectAtIndex: 1] longLongValue])];
}

- (CGImageRef) CGImageWithCorrectOrientation CF_RETURNS_RETAINED
{
    if (self.imageOrientation == UIImageOrientationDown) {
        //retaining because caller expects to own the reference
		CGImageRef cgImage = [self CGImage];
        CGImageRetain(cgImage);
        return cgImage;
    }
    UIGraphicsBeginImageContext(self.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 180 * M_PI/180);
    }

    [self drawAtPoint:CGPointMake(0, 0)];

    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();

    return cgImage;
}


- (UIImage *) resizedImageByWidth:  (NSUInteger) width
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = width/original_width;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, width, round(original_height * ratio))];
}

- (UIImage *) resizedImageByHeight:  (NSUInteger) height
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = height/original_height;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * ratio), height)];
}

- (UIImage *) resizedImageWithMinimumSize: (CGSize) size
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat width_ratio = size.width / original_width;
    CGFloat height_ratio = size.height / original_height;
    CGFloat scale_ratio = width_ratio > height_ratio ? width_ratio : height_ratio;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * scale_ratio), round(original_height * scale_ratio))];
}

- (UIImage *) resizedImageWithMaximumSize: (CGSize) size
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat width_ratio = size.width / original_width;
    CGFloat height_ratio = size.height / original_height;
    CGFloat scale_ratio = width_ratio < height_ratio ? width_ratio : height_ratio;
    CGImageRelease(imgRef);
    return [self drawImageInBounds: CGRectMake(0, 0, round(original_width * scale_ratio), round(original_height * scale_ratio))];
}

- (UIImage *) drawImageInBounds: (CGRect) bounds
{
    UIGraphicsBeginImageContext(bounds.size);
    [self drawInRect: bounds];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage*) croppedImageWithRect: (CGRect) rect {

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height);
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    [self drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return subImage;
}

- (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    
    // 添加logo
    CGFloat logoW = self.size.width / 5.;
    CGRect logoFrame = CGRectMake(logoW * 2, logoW * 2, logoW, logoW);
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [logo drawInRect:logoFrame];
    UIImage *kk = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return kk;
}

- (UIImage *)addImage:(UIImage *)image size:(CGSize)size {
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    
    CGFloat x = (self.size.width - size.width) / 2.;
    CGFloat y = (self.size.height - size.height) / 2.;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        x = (self.size.width - image.size.width) / 2.;
        y = (self.size.height - image.size.height) / 2.;
        width = image.size.width;
        height = image.size.height;
    }
    
    [image drawInRect:CGRectMake(x, y, width, height)];
    
    UIImage *commitImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return commitImage;
}


@end
