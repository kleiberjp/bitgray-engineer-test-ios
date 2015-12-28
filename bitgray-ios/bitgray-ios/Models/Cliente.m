//
//  IdCliente.m
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Cliente.h"


NSString *const kIdClienteDocumento = @"documento";
NSString *const kIdClienteId = @"id";
NSString *const kIdClienteDetalles = @"detalles";
NSString *const kIdClienteNombres = @"nombres";


@interface Cliente ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Cliente

@synthesize documento = _documento;
@synthesize idClienteIdentifier = _idClienteIdentifier;
@synthesize detalles = _detalles;
@synthesize nombres = _nombres;


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
            self.documento = [[self objectOrNilForKey:kIdClienteDocumento fromDictionary:dict] doubleValue];
            self.idClienteIdentifier = [[self objectOrNilForKey:kIdClienteId fromDictionary:dict] doubleValue];
            self.detalles = [self objectOrNilForKey:kIdClienteDetalles fromDictionary:dict];
            self.nombres = [self objectOrNilForKey:kIdClienteNombres fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.documento] forKey:kIdClienteDocumento];
    [mutableDict setValue:[NSNumber numberWithDouble:self.idClienteIdentifier] forKey:kIdClienteId];
    [mutableDict setValue:self.detalles forKey:kIdClienteDetalles];
    [mutableDict setValue:self.nombres forKey:kIdClienteNombres];

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

    self.documento = [aDecoder decodeDoubleForKey:kIdClienteDocumento];
    self.idClienteIdentifier = [aDecoder decodeDoubleForKey:kIdClienteId];
    self.detalles = [aDecoder decodeObjectForKey:kIdClienteDetalles];
    self.nombres = [aDecoder decodeObjectForKey:kIdClienteNombres];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_documento forKey:kIdClienteDocumento];
    [aCoder encodeDouble:_idClienteIdentifier forKey:kIdClienteId];
    [aCoder encodeObject:_detalles forKey:kIdClienteDetalles];
    [aCoder encodeObject:_nombres forKey:kIdClienteNombres];
}

- (id)copyWithZone:(NSZone *)zone
{
    Cliente *copy = [[Cliente alloc] init];
    
    if (copy) {

        copy.documento = self.documento;
        copy.idClienteIdentifier = self.idClienteIdentifier;
        copy.detalles = [self.detalles copyWithZone:zone];
        copy.nombres = [self.nombres copyWithZone:zone];
    }
    
    return copy;
}


@end
