//
//  IdProducto.h
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Producto : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *producto;
@property (nonatomic, assign) double idProductoIdentifier;
@property (nonatomic, assign) double precio;
@property (nonatomic, strong) NSString *descripcion;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
