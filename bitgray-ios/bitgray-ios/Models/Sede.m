//
//  IdSede.m
//
//  Created by Kleiber Perez on 27/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Sede.h"


NSString *const kIdSedeId = @"id";
NSString *const kIdSedeSede = @"sede";
NSString *const kIdSedeDireccion = @"direccion";


@interface Sede ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Sede

@synthesize idSedeIdentifier = _idSedeIdentifier;
@synthesize sede = _sede;
@synthesize direccion = _direccion;


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
            self.idSedeIdentifier = [[self objectOrNilForKey:kIdSedeId fromDictionary:dict] doubleValue];
            self.sede = [self objectOrNilForKey:kIdSedeSede fromDictionary:dict];
            self.direccion = [self objectOrNilForKey:kIdSedeDireccion fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.idSedeIdentifier] forKey:kIdSedeId];
    [mutableDict setValue:self.sede forKey:kIdSedeSede];
    [mutableDict setValue:self.direccion forKey:kIdSedeDireccion];

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

    self.idSedeIdentifier = [aDecoder decodeDoubleForKey:kIdSedeId];
    self.sede = [aDecoder decodeObjectForKey:kIdSedeSede];
    self.direccion = [aDecoder decodeObjectForKey:kIdSedeDireccion];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_idSedeIdentifier forKey:kIdSedeId];
    [aCoder encodeObject:_sede forKey:kIdSedeSede];
    [aCoder encodeObject:_direccion forKey:kIdSedeDireccion];
}

- (id)copyWithZone:(NSZone *)zone
{
    Sede *copy = [[Sede alloc] init];
    
    if (copy) {

        copy.idSedeIdentifier = self.idSedeIdentifier;
        copy.sede = [self.sede copyWithZone:zone];
        copy.direccion = [self.direccion copyWithZone:zone];
    }
    
    return copy;
}


@end
