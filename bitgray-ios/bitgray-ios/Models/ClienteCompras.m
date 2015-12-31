//
//  ClienteCompras.m
//
//  Created by Kleiber Perez on 30/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ClienteCompras.h"
#import "ItemClienteCompras.h"


NSString *const kClienteComprasDocumento = @"documento";
NSString *const kClienteComprasId = @"id";
NSString *const kClienteComprasDetalles = @"detalles";
NSString *const kClienteComprasNombres = @"nombres";
NSString *const kClienteComprasItemClienteCompras = @"item_cliente_compras";
NSString *const kClienteComprasTotalSpent = @"total_spent";


@interface ClienteCompras ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ClienteCompras

@synthesize documento = _documento;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize detalles = _detalles;
@synthesize nombres = _nombres;
@synthesize itemClienteCompras = _itemClienteCompras;
@synthesize totalSpent = _totalSpent;


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
            self.documento = [[self objectOrNilForKey:kClienteComprasDocumento fromDictionary:dict] doubleValue];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kClienteComprasId fromDictionary:dict] doubleValue];
            self.detalles = [self objectOrNilForKey:kClienteComprasDetalles fromDictionary:dict];
            self.nombres = [self objectOrNilForKey:kClienteComprasNombres fromDictionary:dict];
    NSObject *receivedItemClienteCompras = [dict objectForKey:kClienteComprasItemClienteCompras];
    NSMutableArray *parsedItemClienteCompras = [NSMutableArray array];
    if ([receivedItemClienteCompras isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedItemClienteCompras) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedItemClienteCompras addObject:[ItemClienteCompras modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedItemClienteCompras isKindOfClass:[NSDictionary class]]) {
       [parsedItemClienteCompras addObject:[ItemClienteCompras modelObjectWithDictionary:(NSDictionary *)receivedItemClienteCompras]];
    }

    self.itemClienteCompras = [NSArray arrayWithArray:parsedItemClienteCompras];
            self.totalSpent = [[self objectOrNilForKey:kClienteComprasTotalSpent fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.documento] forKey:kClienteComprasDocumento];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kClienteComprasId];
    [mutableDict setValue:self.detalles forKey:kClienteComprasDetalles];
    [mutableDict setValue:self.nombres forKey:kClienteComprasNombres];
    NSMutableArray *tempArrayForItemClienteCompras = [NSMutableArray array];
    for (NSObject *subArrayObject in self.itemClienteCompras) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForItemClienteCompras addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForItemClienteCompras addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItemClienteCompras] forKey:kClienteComprasItemClienteCompras];
    [mutableDict setValue:[NSNumber numberWithDouble:self.totalSpent] forKey:kClienteComprasTotalSpent];

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

    self.documento = [aDecoder decodeDoubleForKey:kClienteComprasDocumento];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kClienteComprasId];
    self.detalles = [aDecoder decodeObjectForKey:kClienteComprasDetalles];
    self.nombres = [aDecoder decodeObjectForKey:kClienteComprasNombres];
    self.itemClienteCompras = [aDecoder decodeObjectForKey:kClienteComprasItemClienteCompras];
    self.totalSpent = [aDecoder decodeDoubleForKey:kClienteComprasTotalSpent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_documento forKey:kClienteComprasDocumento];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kClienteComprasId];
    [aCoder encodeObject:_detalles forKey:kClienteComprasDetalles];
    [aCoder encodeObject:_nombres forKey:kClienteComprasNombres];
    [aCoder encodeObject:_itemClienteCompras forKey:kClienteComprasItemClienteCompras];
    [aCoder encodeDouble:_totalSpent forKey:kClienteComprasTotalSpent];
}

- (id)copyWithZone:(NSZone *)zone
{
    ClienteCompras *copy = [[ClienteCompras alloc] init];
    
    if (copy) {

        copy.documento = self.documento;
        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
        copy.detalles = [self.detalles copyWithZone:zone];
        copy.nombres = [self.nombres copyWithZone:zone];
        copy.itemClienteCompras = [self.itemClienteCompras copyWithZone:zone];
        copy.totalSpent = self.totalSpent;
    }
    
    return copy;
}


@end
