//
//  PickerViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "PickerViewController.h"
#import "ColorPalette.h"

@implementation PickerViewController

- (id)initPickerWithView:(UIView *)view {
    self = [super init];
    
    [self setLocalOwner:view];
    [self setUiButtonCancel:[[UIButton alloc] init]];
    [self setUiButtonDone:[[UIButton alloc] init]];
    [self setRegularPicker:[[UIPickerView alloc] init]];
    [self setLocalUIContainer:[[UIView alloc] init]];
    [self setLocalUIViewPicker:[[UIView alloc] init]];
    
    return self;
}

- (NSInteger)returnHeight {
    UIDevice *device = [[UIDevice alloc] init];
    if ([device.systemName isEqualToString:@"iPhone OS"] || [device.systemName isEqualToString:@"iPhone Simulator"]) {
        return 380;
    } else {
        return 560;
    }
}

- (void)showPicker:(NSString *)title withData:(NSArray *)data {
    [[self localOwner] endEditing:TRUE];
    _dataArray = data;
    NSInteger pickerHeight = [self returnHeight];
    [self setLocalUIViewPicker:[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[self localOwner] bounds].size.width, pickerHeight)]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width - 20, 44)];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:primaryColor];
    
    [[self regularPicker] setFrame:CGRectMake(10, [label frame].origin.y + [label frame].size.height + 5, [[self localOwner] frame].size.width - 20, 162)];
    [[self regularPicker] setBackgroundColor:[UIColor whiteColor]];
    [[self regularPicker] setDataSource:self];
    [[self regularPicker] setDelegate:self];
    
    [[self uiButtonDone] setFrame:CGRectMake(10, [[self regularPicker] frame].origin.y + [[self regularPicker] frame].size.height + 5, [[self localOwner] bounds].size.width - 20, 44)];
    [[self uiButtonDone] setTitle:@"OK" forState:UIControlStateNormal];
    [[self uiButtonDone] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self uiButtonDone] setBackgroundColor:blue600];
    [[self uiButtonDone] showsTouchWhenHighlighted];
    
    [[self uiButtonCancel] setFrame:CGRectMake(10, [[self uiButtonDone] frame].origin.y + [[self uiButtonDone] frame].size.height + 5, [[self localOwner] bounds].size.width - 20, 44)];
    [[self uiButtonCancel] setTitle:@"Cancelar" forState:UIControlStateNormal];
    [[self uiButtonCancel] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self uiButtonCancel] setBackgroundColor:red500];
    [[self uiButtonCancel] showsTouchWhenHighlighted];
    
    [[self localUIViewPicker] addSubview:label];
    [[self localUIViewPicker] addSubview:[self regularPicker]];
    [[self localUIViewPicker] addSubview:[self uiButtonDone]];
    [[self localUIViewPicker] addSubview:[self uiButtonCancel]];
    [[self localUIViewPicker] sizeToFit];
    [[self localUIViewPicker] setBackgroundColor:[UIColor whiteColor]];
    
    [[self localUIContainer] addSubview:[self localUIViewPicker]];
    [[self localUIContainer] setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [[self localOwner] addSubview:[self localUIContainer]];
    
    [self localUIContainer].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self localUIViewPicker].backgroundColor = [UIColor clearColor];
    
    CGRect beginRectangleF = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
    [[self localUIViewPicker] setFrame:beginRectangleF];
    CGRect endRectangleF = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - pickerHeight, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
    
    [UIView animateWithDuration:0.55 animations:^{
        [[self localUIViewPicker] setFrame:endRectangleF];
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self dataArray] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_dataArray[(NSUInteger) row] description];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
}

- (void)dismiss {
    NSInteger pickerHeight = [self returnHeight];
    
    CGRect beginRectangleF = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - pickerHeight, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
    [[self localUIViewPicker] setFrame:beginRectangleF];
    CGRect endRectangleF = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, pickerHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        [[self localUIViewPicker] setFrame:endRectangleF];
    }                completion:(void (^)(BOOL)) ^{
        [UIView animateKeyframesWithDuration:0.25 delay:0 options:(UIViewKeyframeAnimationOptions) UIViewAnimationCurveEaseIn
                                  animations:^{
                                      [[self localUIViewPicker] setHidden:TRUE];
                                  } completion:(void (^)(BOOL)) ^{
                                      [[self localUIContainer] setHidden:TRUE];
                                  }];
    }];
}


@end
