//
//  UserDefaults.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject


-(NSString *)getLastUserIncome;
-(void)setLastUserIncome:(NSString *)user;

-(NSString *)getPasswordUserIncome;
-(void)setPasswordUserIncome:(NSString *)password;

-(NSMutableArray *)getListClients;
-(void)setListClients:(NSData *)clients;

-(NSMutableArray *)getListProduct;
-(void)setListProducts:(NSData *)products;

-(NSMutableArray *)getListStores;
-(void)setListStores:(NSData *)sedes;

-(BOOL)isAlreadyLoged;
-(void)setAlreadyLoged:(BOOL)remember;

@end
