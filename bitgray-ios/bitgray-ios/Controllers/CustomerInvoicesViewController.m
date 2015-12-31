//
//  CustomerInvoicesViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 30/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//
#import "ColorPalette.h"
#import "CustomerInvoicesViewController.h"
#import "NSString+NSStringExtension.h"

@implementation CustomerInvoicesViewController
@synthesize searchIcon = _searchIcon;

CGRect initialFrame, finalFrame;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.searchIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SearchIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    finalFrame = CGRectMake(5, (self.tfClientSearch.bounds.size.height - self.tfClientSearch.bounds.size.height/2)/2 , self.tfClientSearch.bounds.size.height/2, self.tfClientSearch.bounds.size.height/2);
    initialFrame = CGRectMake(self.tfClientSearch.bounds.size.width/2, (self.tfClientSearch.bounds.size.height - self.tfClientSearch.bounds.size.height/2)/2, self.tfClientSearch.bounds.size.height/2, self.tfClientSearch.bounds.size.height/2);
    self.searchIcon.tintColor = primaryColor;
    [self.searchIcon setFrame:initialFrame];
    [self.tfClientSearch addSubview:self.searchIcon];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}


- (void)keyboardWillShow:(NSNotification*)aNotification {
    self.tfClientSearch.leftViewMode = UITextFieldViewModeAlways;
    self.tfClientSearch.leftView = self.searchIcon;
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ // tweak here to adjust the moving position
                         [self.searchIcon setFrame:finalFrame];
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if ([NSString isEmpty:self.tfClientSearch.text]) {
        self.tfClientSearch.leftView = nil;
        [self.tfClientSearch addSubview:self.searchIcon];
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.searchIcon setFrame:initialFrame];
                         }
                         completion:^(BOOL finished) {
                             nil;
                         }
         ];
    }
}


@end
