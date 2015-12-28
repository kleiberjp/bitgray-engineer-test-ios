//
//  UIView+ViewExtension.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "UIView+ViewExtension.h"

@implementation UIView (ViewExtension)

-(UIImage *)getBackGroundImage
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
    
}

@end
