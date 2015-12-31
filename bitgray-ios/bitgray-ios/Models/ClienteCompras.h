//
//  ClienteCompras.h
//
//  Created by Kleiber Perez on 30/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ClienteCompras : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double documento;
@property (nonatomic, assign) double internalBaseClassIdentifier;
@property (nonatomic, assign) id detalles;
@property (nonatomic, strong) NSString *nombres;
@property (nonatomic, strong) NSArray *itemClienteCompras;
@property (nonatomic, assign) double totalSpent;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
