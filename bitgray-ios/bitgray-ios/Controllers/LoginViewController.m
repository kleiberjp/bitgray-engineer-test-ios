//
//  LoginViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//
#import "ColorPalette.h"
#import "LoginViewController.h"
#import "NSString+NSStringExtension.h"
#import "ResultBase.h"

@interface LoginViewController ()

@property (retain, nonatomic) IBOutlet UITextField *tfUsername;
@property (retain, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btLogin;

@end

@implementation LoginViewController
@synthesize tfUsername, tfPassword;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
}

-(void) viewDidLoad{
    [self hideKeyboardOnTap];
    [super registerKeyboardNotifications];
    [super viewDidLoad];
    self.tfUsername.tag = 0;
    self.tfPassword.tag = 1;
    [self.btLogin setBackgroundColor:primaryColor];
    [self.tfUsername resignFirstResponder];
    if (![[self.services.userDefaults getLastUserIncome] isEqualToString:@""]) {
        [self.tfUsername setText:[self.services.userDefaults getLastUserIncome]];
        [self.tfPassword setText:[self.services.userDefaults getPasswordUserIncome]];
        [self doLogin];
        
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [super unregisterKeyboardNotifications];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.returnKeyType==UIReturnKeyDone) {
        [self doLogin];
    }
}


- (IBAction)loginUser:(id)sender {
    [self doLogin];
}


#pragma mark - Metodos generales View Controller

-(void) doLogin{
    [super hideKeyboard];
    if ([self validarCampos]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ResultBase *result = [self.services doLoginUser:self.tfUsername.text withPassword:self.tfPassword.text];
                if ([result isOk]) {
                    [self performSegueWithIdentifier:@"goToMain" sender:self];
                    return;
                }
        });
    }
}

- (BOOL) validarCampos {
    BOOL camposValidos = YES;
    BOOL error = NO;
    
    if (![self validateEmptyField: self.tfPassword]) {
        [self.tfPassword becomeFirstResponder];
        [self.tfPassword setError:[NSString getMessageTextError:@"field-required"]];
        error = YES;
    }
    
    if (![self validateEmptyField:self.tfUsername]) {
        [self.tfUsername becomeFirstResponder];
        [self.tfUsername setError:[NSString getMessageTextError:@"field-required"]];
        error = YES;
    } else {
        if (![self validateEmail:self.tfUsername]) {
            [self.tfUsername becomeFirstResponder];
            [self.tfUsername setError:[NSString getMessageTextError:@"mail-invalid"]];
            error = YES;
        }
    }
    
    if (error) {
        camposValidos = NO;
    }
    
    return camposValidos;
}

@end
