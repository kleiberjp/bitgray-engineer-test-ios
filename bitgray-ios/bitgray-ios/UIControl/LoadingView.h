//
//  LoadingView.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

-(LoadingView *)loadingView:(UIView *)toView withMessage:(NSString *)message andBackground:(UIImage *)imageBackground;

-(void)removeLoadingView;

@end
