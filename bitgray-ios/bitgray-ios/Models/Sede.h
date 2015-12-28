//
//  IdSede.h
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Sede : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double idSedeIdentifier;
@property (nonatomic, strong) NSString *sede;
@property (nonatomic, strong) NSString *direccion;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
