//
//  MainViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "MainViewController.h"
#import "ColorPalette.h"
#import "NSString+NSStringExtension.h"
#import "UIViewController+ViewControllerExtension.h"
#import "UserDefaults.h"

@implementation MainViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setBarTintColor:primaryColor];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
}

-(NSString *) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath{
    
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"firstSegue";
            break;
        case 1:
            identifier = @"secondSegue";
            break;
        case 2:
            [self closeLeftMenuAnimated:YES];
            [self showAlertLogout];
            break;
        default:
            break;
    }
    
    return identifier;
}

-(void) configureLeftMenuButton:(UIButton *)button{
    
    CGRect frame = button.frame;
    frame.origin = CGPointMake(0, 0);
    frame.size = CGSizeMake(40, 40);
    
    button.frame = frame;
    [button setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];

}

-(void)showAlertLogout{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString getMessageText:@"title-logout"]
                                                                             message:[NSString getMessageText:@"message-logout"]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *_continue = [UIAlertAction actionWithTitle:[NSString getMessageText:@"continue-button"]
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self doLogout];
                                                  }];
    
    UIAlertAction *_cancel = [UIAlertAction actionWithTitle:[NSString getMessageText:@"cancel-button"]
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [alertController dismissViewControllerAnimated:YES
                                                                                                completion:nil];
                                                        }];
    
    
    [alertController addAction:_continue];
    [alertController addAction:_cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) doLogout{
    [self showLoadingView];
    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    [userDefaults setAlreadyLoged:NO];
    [userDefaults setPasswordUserIncome:@""];
    [UIView animateWithDuration:5.0f animations:^{
        [self hideLoadingView];
    } completion:^(BOOL finished) {
        [self performSegueWithIdentifier:@"goToLogin" sender:self];
    }];
}

@end
