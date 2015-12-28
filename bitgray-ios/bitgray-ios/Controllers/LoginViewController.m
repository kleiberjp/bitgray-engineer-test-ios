//
//  LoginViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+NSStringExtension.h"

@implementation LoginViewController

@synthesize tfUsername,
            tfPassword,
            btLogin;


-(void) viewDidLoad{
    [self hideKeyboardOnTap];
    [super registerKeyboardNotifications];
    [super viewDidLoad];
    self.tfUsername.delegate = self;
    self.tfPassword.delegate = self;
    [self.tfUsername resignFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [super unregisterKeyboardNotifications];
}


#pragma mark - Metodos generales View Controller

- (BOOL)validarCampos {
    BOOL camposValidos = YES;
    BOOL error = NO;
    
    if (![self validateEmptyField: tfPassword]) {
        [tfPassword becomeFirstResponder];
        [tfPassword setError:[NSString getMessageTextError:@"field-required"]];
        error = YES;
    }
    
    if (![self validateEmptyField:tfUsername]) {
        [tfUsername becomeFirstResponder];
        [tfUsername setError:[NSString getMessageTextError:@"field-required"]];
        error = YES;
    } else {
        if (![self validateEmail:tfUsername]) {
            [tfUsername becomeFirstResponder];
            [tfUsername setError:[NSString getMessageTextError:@"mail-invalid"]];
            error = YES;
        }
    }
    
    if (error) {
        camposValidos = NO;
    }
    
    return camposValidos;
}

@end
