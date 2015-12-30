//
//  PickerViewController.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PickerViewController : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property UIButton *uiButtonCancel;
@property UIButton *uiButtonDone;
@property UIPickerView *regularPicker;
@property UIView *localOwner;
@property UIView *localUIViewPicker;
@property UIView *localUIContainer;
@property NSArray *dataArray;

- (id)initPickerWithView:(UIView *)view;

- (void)showPicker:(NSString *)title withData:(NSArray *)data;

- (void)dismiss;

@end
