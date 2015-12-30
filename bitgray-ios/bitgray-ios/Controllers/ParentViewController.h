//
//  ParentViewController.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+TextFieldExtension.h"
#import "RestServices.h"

@interface ParentViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

#define kPreferredTextFieldToKeyboardOffset 20.0

@property(nonatomic) CGRect keyboardFrame;
@property(nonatomic) BOOL keyboardIsShowing;
@property(weak, nonatomic) UITextField *activeTextField;
@property(weak, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) RestServices *services;

- (void)registerKeyboardNotifications;

- (void)unregisterKeyboardNotifications;

-(void) addBackButton: (NSString *)imageName andAction:(SEL)action;

- (void)hideNavigationBar;

- (void)hideKeyboardOnTap;

- (void)hideKeyboard;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (BOOL)validateEmptyField:(UITextField *)uiTextField;

- (BOOL)validateEmail:(UITextField *)uiTextField;

-(NSDate *) getCurrentTime;
@end
