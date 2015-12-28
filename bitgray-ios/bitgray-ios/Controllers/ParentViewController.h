//
//  ParentViewController.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "UITextField+TextFieldExtension.h"


@interface ParentViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

#define kPreferredTextFieldToKeyboardOffset 20.0

@property(nonatomic) CGRect keyboardFrame;
@property(nonatomic) BOOL keyboardIsShowing;
@property(weak, nonatomic) UITextField *activeTextField;
@property(weak, nonatomic) UIScrollView *scrollView;
@property(retain, nonatomic) LoadingView *loadingView;

- (void)registerKeyboardNotifications;

- (void)unregisterKeyboardNotifications;

- (void)hideKeyboardOnTap;

- (void)hideKeyboard;

- (void)showLoadingView;

- (void)hideLoadingView;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (BOOL)validateEmptyField:(UITextField *)uiTextField;

- (BOOL)validateEmail:(UITextField *)uiTextField;

@end
