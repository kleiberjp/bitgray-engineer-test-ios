//
//  ParentViewController.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+TextFieldExtension.h"
#import "LoadingView.h"
#import "RestServices.h"

@interface ParentViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

#define kPreferredTextFieldToKeyboardOffset 20.0

@property(nonatomic) CGRect keyboardFrame;
@property(nonatomic) BOOL keyboardIsShowing;
@property(weak, nonatomic) UITextField *activeTextField;
@property(weak, nonatomic) UIScrollView *scrollView;
@property(retain, nonatomic) LoadingView *loadingView;
@property (nonatomic, strong) RestServices *services;

- (void)registerKeyboardNotifications;

- (void)unregisterKeyboardNotifications;

- (void)hideKeyboardOnTap;

- (void)hideKeyboard;

- (void)showLoadingView;

- (void)hideLoadingView;

-(void) showAlert:(NSString *) title withMessage:(NSString *) message;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (BOOL)validateEmptyField:(UITextField *)uiTextField;

- (BOOL)validateEmail:(UITextField *)uiTextField;

@end
