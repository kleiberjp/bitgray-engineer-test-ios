//
//  UITextField+TextFieldExtension.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TextFieldExtension)

@property(retain, nonatomic) IBOutlet UILabel *label_error;

- (void)setError:(NSString *)error;
- (void)removeErrors;

@end
