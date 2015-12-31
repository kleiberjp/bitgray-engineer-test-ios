//
//  ItemClienteCompras.m
//
//  Created by Kleiber Perez on 30/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ItemClienteCompras.h"


NSString *const kItemClienteComprasIdSedeSede = @"id_sede__sede";
NSString *const kItemClienteComprasIdProductoPrecio = @"id_producto__precio";
NSString *const kItemClienteComprasIdProductoId = @"id_producto_id";
NSString *const kItemClienteComprasPrecio = @"precio";
NSString *const kItemClienteComprasIdSedeId = @"id_sede__id";
NSString *const kItemClienteComprasIdProductoProducto = @"id_producto__producto";


@interface ItemClienteCompras ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ItemClienteCompras

@synthesize idSedeSede = _idSedeSede;
@synthesize idProductoPrecio = _idProductoPrecio;
@synthesize idProductoId = _idProductoId;
@synthesize precio = _precio;
@synthesize idSedeId = _idSedeId;
@synthesize idProductoProducto = _idProductoProducto;


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
            self.idSedeSede = [self objectOrNilForKey:kItemClienteComprasIdSedeSede fromDictionary:dict];
            self.idProductoPrecio = [[self objectOrNilForKey:kItemClienteComprasIdProductoPrecio fromDictionary:dict] doubleValue];
            self.idProductoId = [[self objectOrNilForKey:kItemClienteComprasIdProductoId fromDictionary:dict] doubleValue];
            self.precio = [[self objectOrNilForKey:kItemClienteComprasPrecio fromDictionary:dict] doubleValue];
            self.idSedeId = [[self objectOrNilForKey:kItemClienteComprasIdSedeId fromDictionary:dict] doubleValue];
            self.idProductoProducto = [self objectOrNilForKey:kItemClienteComprasIdProductoProducto fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.idSedeSede forKey:kItemClienteComprasIdSedeSede];
    [mutableDict setValue:[NSNumber numberWithDouble:self.idProductoPrecio] forKey:kItemClienteComprasIdProductoPrecio];
    [mutableDict setValue:[NSNumber numberWithDouble:self.idProductoId] forKey:kItemClienteComprasIdProductoId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.precio] forKey:kItemClienteComprasPrecio];
    [mutableDict setValue:[NSNumber numberWithDouble:self.idSedeId] forKey:kItemClienteComprasIdSedeId];
    [mutableDict setValue:self.idProductoProducto forKey:kItemClienteComprasIdProductoProducto];

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

    self.idSedeSede = [aDecoder decodeObjectForKey:kItemClienteComprasIdSedeSede];
    self.idProductoPrecio = [aDecoder decodeDoubleForKey:kItemClienteComprasIdProductoPrecio];
    self.idProductoId = [aDecoder decodeDoubleForKey:kItemClienteComprasIdProductoId];
    self.precio = [aDecoder decodeDoubleForKey:kItemClienteComprasPrecio];
    self.idSedeId = [aDecoder decodeDoubleForKey:kItemClienteComprasIdSedeId];
    self.idProductoProducto = [aDecoder decodeObjectForKey:kItemClienteComprasIdProductoProducto];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_idSedeSede forKey:kItemClienteComprasIdSedeSede];
    [aCoder encodeDouble:_idProductoPrecio forKey:kItemClienteComprasIdProductoPrecio];
    [aCoder encodeDouble:_idProductoId forKey:kItemClienteComprasIdProductoId];
    [aCoder encodeDouble:_precio forKey:kItemClienteComprasPrecio];
    [aCoder encodeDouble:_idSedeId forKey:kItemClienteComprasIdSedeId];
    [aCoder encodeObject:_idProductoProducto forKey:kItemClienteComprasIdProductoProducto];
}

- (id)copyWithZone:(NSZone *)zone
{
    ItemClienteCompras *copy = [[ItemClienteCompras alloc] init];
    
    if (copy) {

        copy.idSedeSede = [self.idSedeSede copyWithZone:zone];
        copy.idProductoPrecio = self.idProductoPrecio;
        copy.idProductoId = self.idProductoId;
        copy.precio = self.precio;
        copy.idSedeId = self.idSedeId;
        copy.idProductoProducto = [self.idProductoProducto copyWithZone:zone];
    }
    
    return copy;
}


@end
