//
//  ProgressVIew.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 31/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property UIProgressView *progress;
@property UILabel *labelProgres;
@property UIView *localView;

-(id) initWithView:(UIView *)toView andBackground: (UIImage *) imageBackground;

-(void) showProgress;

- (void)setProgressComplete:(float)progres;

-(void) removeProgressView;

@end
