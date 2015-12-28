//
//  Compras.m
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Compras.h"
#import "Sede.h"
#import "Producto.h"
#import "Cliente.h"


NSString *const kComprasPrecio = @"precio";
NSString *const kComprasDescripcion = @"descripcion";
NSString *const kComprasId = @"id";
NSString *const kComprasIdSede = @"id_sede";
NSString *const kComprasIdProducto = @"id_producto";
NSString *const kComprasIdCliente = @"id_cliente";
NSString *const kComprasFecha = @"fecha";


@interface Compras ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Compras

@synthesize precio = _precio;
@synthesize descripcion = _descripcion;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize idSede = _idSede;
@synthesize idProducto = _idProducto;
@synthesize idCliente = _idCliente;
@synthesize fecha = _fecha;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.precio = [[self objectOrNilForKey:kComprasPrecio fromDictionary:dict] doubleValue];
            self.descripcion = [self objectOrNilForKey:kComprasDescripcion fromDictionary:dict];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kComprasId fromDictionary:dict] doubleValue];
            self.idSede = [Sede modelObjectWithDictionary:[dict objectForKey:kComprasIdSede]];
            self.idProducto = [Producto modelObjectWithDictionary:[dict objectForKey:kComprasIdProducto]];
            self.idCliente = [Cliente modelObjectWithDictionary:[dict objectForKey:kComprasIdCliente]];
            self.fecha = [self objectOrNilForKey:kComprasFecha fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.precio] forKey:kComprasPrecio];
    [mutableDict setValue:self.descripcion forKey:kComprasDescripcion];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kComprasId];
    [mutableDict setValue:[self.idSede dictionaryRepresentation] forKey:kComprasIdSede];
    [mutableDict setValue:[self.idProducto dictionaryRepresentation] forKey:kComprasIdProducto];
    [mutableDict setValue:[self.idCliente dictionaryRepresentation] forKey:kComprasIdCliente];
    [mutableDict setValue:self.fecha forKey:kComprasFecha];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.precio = [aDecoder decodeDoubleForKey:kComprasPrecio];
    self.descripcion = [aDecoder decodeObjectForKey:kComprasDescripcion];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kComprasId];
    self.idSede = [aDecoder decodeObjectForKey:kComprasIdSede];
    self.idProducto = [aDecoder decodeObjectForKey:kComprasIdProducto];
    self.idCliente = [aDecoder decodeObjectForKey:kComprasIdCliente];
    self.fecha = [aDecoder decodeObjectForKey:kComprasFecha];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_precio forKey:kComprasPrecio];
    [aCoder encodeObject:_descripcion forKey:kComprasDescripcion];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kComprasId];
    [aCoder encodeObject:_idSede forKey:kComprasIdSede];
    [aCoder encodeObject:_idProducto forKey:kComprasIdProducto];
    [aCoder encodeObject:_idCliente forKey:kComprasIdCliente];
    [aCoder encodeObject:_fecha forKey:kComprasFecha];
}

- (id)copyWithZone:(NSZone *)zone
{
    Compras *copy = [[Compras alloc] init];
    
    if (copy) {

        copy.precio = self.precio;
        copy.descripcion = [self.descripcion copyWithZone:zone];
        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.idSede = [self.idSede copyWithZone:zone];
        copy.idProducto = [self.idProducto copyWithZone:zone];
        copy.idCliente = [self.idCliente copyWithZone:zone];
        copy.fecha = [self.fecha copyWithZone:zone];
    }
    
    return copy;
}


@end
