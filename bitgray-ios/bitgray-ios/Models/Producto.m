//
//  IdProducto.m
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Producto.h"


NSString *const kIdProductoProducto = @"producto";
NSString *const kIdProductoId = @"id";
NSString *const kIdProductoPrecio = @"precio";
NSString *const kIdProductoDescripcion = @"descripcion";


@interface Producto ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Producto

@synthesize producto = _producto;
@synthesize idProductoIdentifier = _idProductoIdentifier;
@synthesize precio = _precio;
@synthesize descripcion = _descripcion;


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
            self.producto = [self objectOrNilForKey:kIdProductoProducto fromDictionary:dict];
            self.idProductoIdentifier = [[self objectOrNilForKey:kIdProductoId fromDictionary:dict] doubleValue];
            self.precio = [[self objectOrNilForKey:kIdProductoPrecio fromDictionary:dict] doubleValue];
            self.descripcion = [self objectOrNilForKey:kIdProductoDescripcion fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.producto forKey:kIdProductoProducto];
    [mutableDict setValue:[NSNumber numberWithDouble:self.idProductoIdentifier] forKey:kIdProductoId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.precio] forKey:kIdProductoPrecio];
    [mutableDict setValue:self.descripcion forKey:kIdProductoDescripcion];

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

    self.producto = [aDecoder decodeObjectForKey:kIdProductoProducto];
    self.idProductoIdentifier = [aDecoder decodeDoubleForKey:kIdProductoId];
    self.precio = [aDecoder decodeDoubleForKey:kIdProductoPrecio];
    self.descripcion = [aDecoder decodeObjectForKey:kIdProductoDescripcion];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_producto forKey:kIdProductoProducto];
    [aCoder encodeDouble:_idProductoIdentifier forKey:kIdProductoId];
    [aCoder encodeDouble:_precio forKey:kIdProductoPrecio];
    [aCoder encodeObject:_descripcion forKey:kIdProductoDescripcion];
}

- (id)copyWithZone:(NSZone *)zone
{
    Producto *copy = [[Producto alloc] init];
    
    if (copy) {

        copy.producto = [self.producto copyWithZone:zone];
        copy.idProductoIdentifier = self.idProductoIdentifier;
        copy.precio = self.precio;
        copy.descripcion = [self.descripcion copyWithZone:zone];
    }
    
    return copy;
}


@end
