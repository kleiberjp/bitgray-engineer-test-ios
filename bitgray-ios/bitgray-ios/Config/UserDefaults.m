//
//  UserDefaults.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "UserDefaults.h"
#import "NSString+NSStringExtension.h"
#import "Cliente.h"
#import "Producto.h"
#import "Sede.h"

@implementation UserDefaults

static NSString *LAST_USER_INGRESED = @"UD_LAST_USER_INGRESED";
static NSString *REMEMBER_USER = @"UD_ALREADY_LOGED";
static NSString *PASSWORD_USER = @"UD_PASSWORD_USER";
static NSString *APP_VERSION = @"UD_APP_VERSION";
static NSString *LIST_CLIENTS = @"UD_LIST_CLIENTS";
static NSString *LIST_PRODUCTS = @"UD_LIST_PRODUCTS";
static NSString *LIST_SEDES = @"UD_LIST_SEDES";


-(NSString *)getLastUserIncome{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    NSString *user = [user_defaults objectForKey:LAST_USER_INGRESED];
    if ([NSString isEmpty:user]) {
        return @"";
    }
    
    return user;
}

-(void)setLastUserIncome:(NSString *)user{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    [user_defaults setObject:user forKey:LAST_USER_INGRESED];
    [user_defaults synchronize];
}

-(NSString *)getPasswordUserIncome
{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    NSString *password = [user_defaults objectForKey:PASSWORD_USER];
    if ([NSString isEmpty:password]) {
        return @"";
    }
    
    return password;
}

-(void)setPasswordUserIncome:(NSString *)password
{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    [user_defaults setObject:password forKey:PASSWORD_USER];
    [user_defaults synchronize];
}

-(BOOL)isAlreadyLoged
{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    BOOL remember_user = [user_defaults boolForKey:REMEMBER_USER];
    return remember_user;
}

-(void)setAlreadyLoged:(BOOL)remember
{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    [user_defaults setBool:remember forKey:REMEMBER_USER];
    [user_defaults synchronize];
}

-(NSMutableArray *)getListClients{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    NSData *data = [user_defaults objectForKey:LIST_CLIENTS];
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *list_client = [NSMutableArray arrayWithArray:items];
    return list_client;
}


-(void)setListClients:(NSData *)clients{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    [user_defaults setObject:clients forKey:LIST_CLIENTS];
    [user_defaults synchronize];
}

-(NSMutableArray *)getListProduct{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    NSData *data = [user_defaults objectForKey:LIST_PRODUCTS];
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *list_products = [NSMutableArray arrayWithArray:items];
    return list_products;
}

-(void)setListProducts:(NSData *)products{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    [user_defaults setObject:products forKey:LIST_PRODUCTS];
    [user_defaults synchronize];
}

-(NSMutableArray *)getListStores{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    NSData *data = [user_defaults objectForKey:LIST_SEDES];
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *list_sedes = [NSMutableArray arrayWithArray:items];
    return list_sedes;
}

-(void)setListStores:(NSData *)sedes{
    NSUserDefaults *user_defaults = [self getUserDefaults];
    [user_defaults setObject:sedes forKey:LIST_SEDES];
    [user_defaults synchronize];
}

-(NSUserDefaults *)getUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return userDefaults;
}

-(double)getAppVersion{
    double appversion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] doubleValue];
    return appversion;
}

@end
