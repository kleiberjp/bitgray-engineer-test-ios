//
//  ItemCompra.m
//
//  Created by Kleiber Perez on 30/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ItemCompra.h"


NSString *const kItemCompraProducto = @"producto";
NSString *const kItemCompraSede = @"sede";
NSString *const kItemCompraPrecio = @"precio";
NSString *const kItemCompraCliente = @"cliente";
NSString *const kItemCompraDescripcion = @"descripcion";
NSString *const kItemCompraFecha = @"fecha";


@interface ItemCompra ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ItemCompra

@synthesize producto = _producto;
@synthesize sede = _sede;
@synthesize precio = _precio;
@synthesize cliente = _cliente;
@synthesize descripcion = _descripcion;
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
            self.producto = [[self objectOrNilForKey:kItemCompraProducto fromDictionary:dict] doubleValue];
            self.sede = [[self objectOrNilForKey:kItemCompraSede fromDictionary:dict] doubleValue];
            self.precio = [[self objectOrNilForKey:kItemCompraPrecio fromDictionary:dict] doubleValue];
            self.cliente = [[self objectOrNilForKey:kItemCompraCliente fromDictionary:dict] doubleValue];
            self.descripcion = [self objectOrNilForKey:kItemCompraDescripcion fromDictionary:dict];
            self.fecha = [self objectOrNilForKey:kItemCompraFecha fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.producto] forKey:kItemCompraProducto];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sede] forKey:kItemCompraSede];
    [mutableDict setValue:[NSNumber numberWithDouble:self.precio] forKey:kItemCompraPrecio];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cliente] forKey:kItemCompraCliente];
    [mutableDict setValue:self.descripcion forKey:kItemCompraDescripcion];
    [mutableDict setValue:self.fecha forKey:kItemCompraFecha];

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

    self.producto = [aDecoder decodeDoubleForKey:kItemCompraProducto];
    self.sede = [aDecoder decodeDoubleForKey:kItemCompraSede];
    self.precio = [aDecoder decodeDoubleForKey:kItemCompraPrecio];
    self.cliente = [aDecoder decodeDoubleForKey:kItemCompraCliente];
    self.descripcion = [aDecoder decodeObjectForKey:kItemCompraDescripcion];
    self.fecha = [aDecoder decodeObjectForKey:kItemCompraFecha];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_producto forKey:kItemCompraProducto];
    [aCoder encodeDouble:_sede forKey:kItemCompraSede];
    [aCoder encodeDouble:_precio forKey:kItemCompraPrecio];
    [aCoder encodeDouble:_cliente forKey:kItemCompraCliente];
    [aCoder encodeObject:_descripcion forKey:kItemCompraDescripcion];
    [aCoder encodeObject:_fecha forKey:kItemCompraFecha];
}

- (id)copyWithZone:(NSZone *)zone
{
    ItemCompra *copy = [[ItemCompra alloc] init];
    
    if (copy) {

        copy.producto = self.producto;
        copy.sede = self.sede;
        copy.precio = self.precio;
        copy.cliente = self.cliente;
        copy.descripcion = [self.descripcion copyWithZone:zone];
        copy.fecha = [self.fecha copyWithZone:zone];
    }
    
    return copy;
}


@end
