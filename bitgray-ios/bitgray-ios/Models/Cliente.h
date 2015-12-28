//
//  IdCliente.h
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Cliente : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double documento;
@property (nonatomic, assign) double idClienteIdentifier;
@property (nonatomic, strong) NSString *detalles;
@property (nonatomic, strong) NSString *nombres;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
