//
//  UITextField+TextFieldExtension.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "UITextField+TextFieldExtension.h"
#import <objc/runtime.h>

#define kFloatingLabelShowAnimationDuration 0.3f
#define kFloatingLabelHideAnimationDuration 0.3f

static char const *const errorPropertyKey = "errorPropertyKey";

@implementation UITextField (TextFieldExtension)

@dynamic label_error;

- (void)setLabel_error:(UILabel *)label_error {
    objc_setAssociatedObject(self, errorPropertyKey, label_error, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)label_error {
    return objc_getAssociatedObject(self, errorPropertyKey);
}

- (void)setError:(NSString *)error {
    CGRect frame = self.frame;
    
    [self addTarget:self action:@selector(removeErrors) forControlEvents:UIControlEventEditingChanged];
    
    //UILabel *label
    self.label_error = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height / 2)];
    self.label_error.text = error;
    self.label_error.font = [UIFont systemFontOfSize:12.5];
    self.label_error.textColor = [UIColor redColor];
    [self.superview addSubview:self.label_error];
    
    void(^showLabel)() = ^{
        self.label_error.alpha = 1.0f;
        /*CGRect labelFrame = self.frame;
         labelFrame.origin.y -= 5.0;
         self.frame = labelFrame;*/
        self.label_error.frame = CGRectMake(self.label_error.frame.origin.x,
                                            frame.origin.y + frame.size.height,
                                            self.label_error.frame.size.width,
                                            self.label_error.frame.size.height);
    };
    
    
    [UIView animateWithDuration:kFloatingLabelShowAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:showLabel
                     completion:nil];
    
    /*CATransition *animation = [CATransition animation];
     [animation setType:kCATransitionFromTop];
     [[self.superview layer] addAnimation:animation forKey:@"layerAnimation"];*/
}

- (void)removeErrors {
    UIView *aSuperview = [self superview];
    [self.label_error removeFromSuperview];
    
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFromTop];
    
    [[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

@end
