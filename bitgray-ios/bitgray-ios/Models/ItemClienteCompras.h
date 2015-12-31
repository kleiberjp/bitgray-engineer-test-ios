//
//  ItemClienteCompras.h
//
//  Created by Kleiber Perez on 30/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ItemClienteCompras : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *idSedeSede;
@property (nonatomic, assign) double idProductoPrecio;
@property (nonatomic, assign) double idProductoId;
@property (nonatomic, assign) double precio;
@property (nonatomic, assign) double idSedeId;
@property (nonatomic, strong) NSString *idProductoProducto;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
