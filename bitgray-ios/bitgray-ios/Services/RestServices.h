//
//  RestServices.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultBase.h"

@class ReadFileJson, ParentViewController;

@interface RestServices : NSObject

@property (nonatomic, strong) ReadFileJson *services;
@property (nonatomic, retain) ParentViewController *superView;

-(ResultBase *)doLoginUser:(NSString *)username withPassword:(NSString *)password;
-(instancetype) initWithSuperView:(ParentViewController *) view;
@end
