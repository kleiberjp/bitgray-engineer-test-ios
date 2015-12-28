//
//  ParentViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "ParentViewController.h"
#import "UIView+ViewExtension.h"
#import "NSString+NSStringExtension.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerKeyboardNotifications];
    [self hideKeyboardOnTap];
}

- (void)viewDidAppear:(BOOL)animated {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            self.scrollView = (UIScrollView *) view;
            [(UIScrollView *) view setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, (CGFloat) ([UIScreen mainScreen].bounds.size.height + 200.0))];
            [(UIScrollView *) view setDelaysContentTouches:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterKeyboardNotifications];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Metodos de Uso Generico

- (void)hideKeyboardOnTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardOnTapGesture:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)hideKeyboardOnTapGesture:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)showLoadingView {
    UIImage *image = [self.view.superview getBackGroundImage];
    self.loadingView = [[LoadingView alloc] loadingView:self.view.superview withMessage:[NSString getMessageText:@"wait"] andBackground:image];
}

- (void)hideLoadingView {
    if (self.loadingView) {
        [self.loadingView performSelector:@selector(removeLoadingView) withObject:nil afterDelay:0.0];
    }
}

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

- (void)unregisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    self.keyboardIsShowing = YES;
    self.keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self moveViewOnKeyboardHide];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    self.keyboardIsShowing = NO;
    [self returnToOriginalFrame];
}

- (void)moveViewOnKeyboardHide {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (CGFloat) (self.keyboardFrame.size.height + 10.0), 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect view = self.scrollView.frame;
    view.size.height -= self.keyboardFrame.size.height;
    
    if (!CGRectContainsPoint(view, self.activeTextField.frame.origin)) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
        }];
    }
}

- (void)returnToOriginalFrame {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (BOOL)validateEmptyField:(UITextField *)uiTextField {
    if (uiTextField.text.length == 0 || [uiTextField.text isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)validateEmail:(UITextField *)uiTextField {
    return [uiTextField.text stringIsValidEmailAddress];
}


#pragma mark - Delegados

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.activeTextField) {
        [self.activeTextField resignFirstResponder];
        self.activeTextField = nil;
    }
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !([touch.view isKindOfClass:[UIControl class]] ||
             [touch.view isKindOfClass:[UITableViewCell class]] ||
             [touch.view.superview isKindOfClass:[UITableViewCell class]]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    
    // Se ubica el siguiente responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Encontrado el next Responder se setea
        [nextResponder becomeFirstResponder];
    } else {
        // No encontrado se hace dismiss keyboard
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField removeErrors];
    self.activeTextField = textField;
    /*if (self.keyboardIsShowing) {
     [self moveViewOnKeyboardHide];
     }*/
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}

@end
