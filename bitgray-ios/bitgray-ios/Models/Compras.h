//
//  Compras.h
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sede, Producto, Cliente;

@interface Compras : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double precio;
@property (nonatomic, strong) NSString *descripcion;
@property (nonatomic, assign) double internalBaseClassIdentifier;
@property (nonatomic, strong) Sede *idSede;
@property (nonatomic, strong) Producto *idProducto;
@property (nonatomic, strong) Cliente *idCliente;
@property (nonatomic, strong) NSString *fecha;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
