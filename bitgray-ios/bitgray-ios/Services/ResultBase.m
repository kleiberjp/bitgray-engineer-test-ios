//
//  ResultBase.m
//
//  Created by Kleiber Perez on 28/12/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "ResultBase.h"


NSString *const kResultBaseSuccess = @"success";
NSString *const kResultBaseHasErrors = @"hasErrors";
NSString *const kResultBaseUrl = @"url";
NSString *const kResultBaseHasMessage = @"hasMessage";
NSString *const kResultBaseUser = @"user";


@interface ResultBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ResultBase

@synthesize success = _success;
@synthesize hasErrors = _hasErrors;
@synthesize url = _url;
@synthesize hasMessage = _hasMessage;
@synthesize user = _user;


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
            self.success = [[self objectOrNilForKey:kResultBaseSuccess fromDictionary:dict] boolValue];
            self.hasErrors = [[self objectOrNilForKey:kResultBaseHasErrors fromDictionary:dict] boolValue];
            self.url = [self objectOrNilForKey:kResultBaseUrl fromDictionary:dict];
            self.hasMessage = [[self objectOrNilForKey:kResultBaseHasMessage fromDictionary:dict] boolValue];
            self.user = [self objectOrNilForKey:kResultBaseUser fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.success] forKey:kResultBaseSuccess];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasErrors] forKey:kResultBaseHasErrors];
    [mutableDict setValue:self.url forKey:kResultBaseUrl];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasMessage] forKey:kResultBaseHasMessage];
    [mutableDict setValue:self.user forKey:kResultBaseUser];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

- (BOOL) isOk{
    return self.success;
}


-(BOOL) isThereAMessage{
    return self.hasMessage;
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

    self.success = [aDecoder decodeBoolForKey:kResultBaseSuccess];
    self.hasErrors = [aDecoder decodeBoolForKey:kResultBaseHasErrors];
    self.url = [aDecoder decodeObjectForKey:kResultBaseUrl];
    self.hasMessage = [aDecoder decodeBoolForKey:kResultBaseHasMessage];
    self.user = [aDecoder decodeObjectForKey:kResultBaseUser];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_success forKey:kResultBaseSuccess];
    [aCoder encodeBool:_hasErrors forKey:kResultBaseHasErrors];
    [aCoder encodeObject:_url forKey:kResultBaseUrl];
    [aCoder encodeBool:_hasMessage forKey:kResultBaseHasMessage];
    [aCoder encodeObject:_user forKey:kResultBaseUser];
}

- (id)copyWithZone:(NSZone *)zone
{
    ResultBase *copy = [[ResultBase alloc] init];
    
    if (copy) {

        copy.success = self.success;
        copy.hasErrors = self.hasErrors;
        copy.url = [self.url copyWithZone:zone];
        copy.hasMessage = self.hasMessage;
        copy.user = [self.user copyWithZone:zone];
    }
    
    return copy;
}


@end
