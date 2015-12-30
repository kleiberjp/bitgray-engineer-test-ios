//
//  UIViewController+ViewControllerExtension.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface UIViewController (ViewControllerExtension)

@property(retain, nonatomic) LoadingView *loadingView;

- (void)showLoadingView;

- (void)hideLoadingView;

-(void) showAlert:(NSString *) title withMessage:(NSString *) message;

@end
