//
//  ResultBase.h
//
//  Created by Kleiber Perez on 28/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultBase : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) BOOL hasErrors;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL hasMessage;
@property (nonatomic, strong) NSString *user;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
-(BOOL) isOk;
-(BOOL) isThereAMessage;
@end
