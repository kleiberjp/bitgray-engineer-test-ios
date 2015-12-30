//
//  ItemCompra.h
//
//  Created by Kleiber Perez on 30/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ItemCompra : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double producto;
@property (nonatomic, assign) double sede;
@property (nonatomic, assign) double precio;
@property (nonatomic, assign) double cliente;
@property (nonatomic, strong) NSString *descripcion;
@property (nonatomic, strong) NSString *fecha;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
