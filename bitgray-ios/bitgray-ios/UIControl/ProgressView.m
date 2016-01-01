//
//  ProgressVIew.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 31/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "ProgressView.h"
#import "ColorPalette.h"
#import "UIView+ViewExtension.h"
#import "UIImage+ImageExtension.h"
#import "NSString+NSStringExtension.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProgressView

-(id) initWithView:(UIView *)toView andBackground: (UIImage *) imageBackground{
    self = [[ProgressView alloc] initWithFrame:toView.bounds];
    if(!self) return nil;
    
    [self setLocalView:toView];
    [self setProgress:[[UIProgressView alloc] init]];
    [self setLabelProgres:[[UILabel alloc] init]];
    
    const CGFloat DEFAULT_LABEL_WIDTH = toView.frame.size.width - 60;
    const CGFloat DEFAULT_LABEL_HEIGHT = 40.0;
    CGRect frameContent = CGRectMake(0,0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
    
    self.progress.tintColor = primaryColor;
    self.progress.progress = 0.0f;
    self.progress.frame = CGRectMake(10, 10, DEFAULT_LABEL_WIDTH - 20, 20);
    [self addSubview:self.progress];
    
    [self.labelProgres setFrame:frameContent];
    self.labelProgres.backgroundColor = [UIColor clearColor];
    self.labelProgres.textAlignment = NSTextAlignmentCenter;
    self.labelProgres.textColor = [UIColor lightGrayColor];
    self.labelProgres.font = [self.labelProgres.font fontWithSize:14];
    self.labelProgres.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.labelProgres.text = [NSString stringWithFormat:[NSString getMessageText:@"title-progress"], 0.0];
    [self addSubview:self.labelProgres];
    
    CGFloat totalHeight = self.progress.frame.size.height + self.labelProgres.frame.size.height;
    frameContent.origin.x = floor(0.5 * (self.frame.size.width - DEFAULT_LABEL_WIDTH));
    frameContent.origin.y = floor(0.5 * (self.frame.size.height - totalHeight));
    self.progress.frame = frameContent;
    frameContent.size.height = totalHeight + 50;
    
    CGRect lblRect = self.labelProgres.frame;
    lblRect.origin.x = 0.5 * (self.frame.size.width - lblRect.size.width);
    lblRect.origin.y = self.progress.frame.origin.y + self.progress.frame.size.height;
    self.labelProgres.frame = lblRect;
    
    return self;
    
}

-(void)showProgress{
    [self.localView addSubview:self];
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[self.localView layer] addAnimation:animation forKey:@"layerAnimation"];
}

-(void)setProgressComplete:(float)progres{
    self.labelProgres.text = [NSString stringWithFormat:[NSString getMessageText:@"title-progress"], progres];
    [self.progress setProgress:progres animated:YES];
}

-(void)removeProgressView{
    UIView *aSuperview = [self superview];
    [super removeFromSuperview];
    
    // Set up the animation
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

@end
