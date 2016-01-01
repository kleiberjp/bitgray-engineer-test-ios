//
//  LoadingView.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+ViewExtension.h"
#import "UIImage+ImageExtension.h"

CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
    //
    // Create the boundary path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height);
    
    // Top left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius);
    
    // Top right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom right corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
    // Bottom left corner
    CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
    // Close the path at the rounded rect
    CGPathCloseSubpath(path);
    
    return path;
}

@implementation LoadingView

-(LoadingView *)loadingView:(UIView*)aSuperview withMessage:(NSString *)message andBackground:(UIImage *)imageBackground;
{
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:[aSuperview bounds]];
    if (!loadingView)
    {
        return nil;
    }
    
    UIView *blurMask = [[UIView alloc] initWithFrame:CGRectMake(0,0, aSuperview.frame.size.width, aSuperview.frame.size.height)];
    blurMask.backgroundColor = [UIColor whiteColor];
    
    UIImageView *blurredBgImage = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, aSuperview.frame.size.width, aSuperview.frame.size.height)];
    //[blurredBgImage setContentMode:UIViewContentModeScaleToFill];
    
    loadingView.opaque = NO;
    loadingView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [aSuperview addSubview:loadingView];
    [loadingView addSubview:blurredBgImage];
    
    const CGFloat DEFAULT_LABEL_WIDTH = aSuperview.frame.size.width - 60;
    const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
    CGRect labelFrame = CGRectMake(0,0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
    
    
    UIView *fondoLoading = [[UIView alloc] initWithFrame:labelFrame];
    fondoLoading.layer.cornerRadius = 5;
    fondoLoading.layer.masksToBounds = YES;
    [loadingView addSubview:fondoLoading];
    
    UILabel *loadingLabel =[[UILabel alloc] initWithFrame:labelFrame];
    loadingLabel.text = NSLocalizedString(message, nil);
    loadingLabel.textColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    loadingLabel.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    [loadingView addSubview:loadingLabel];
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.backgroundColor = [UIColor clearColor];
    activityIndicatorView.color = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
    [loadingView addSubview:activityIndicatorView];
    activityIndicatorView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    [activityIndicatorView startAnimating];
    
    CGFloat totalHeight = loadingLabel.frame.size.height + activityIndicatorView.frame.size.height;
    labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
    labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight));
    loadingLabel.frame = labelFrame;
    labelFrame.size.height = totalHeight + 20;
    fondoLoading.frame = labelFrame;
    
    fondoLoading.backgroundColor = [UIColor colorWithPatternImage:[[imageBackground cropImage:CGRectMake(30, labelFrame.origin.y, labelFrame.size.width, totalHeight)] applyExtraLightEffect]];
    
    //blurredBgImage.image = [imageBackground applyDarkEffect];
    blurredBgImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    blurredBgImage.layer.mask = blurMask.layer;
    
    CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.origin.x = 0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
    activityIndicatorRect.origin.y = loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
    activityIndicatorView.frame = activityIndicatorRect;
    
    // Set up the fade-in animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    return loadingView;
}

-(void)removeLoadingView{
    UIView *aSuperview = [self superview];
    [super removeFromSuperview];
    
    
    // Set up the animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}


@end
