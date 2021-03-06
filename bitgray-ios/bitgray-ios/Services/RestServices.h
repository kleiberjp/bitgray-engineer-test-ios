//
//  RestServices.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ResultBase.h"
#import "UserDefaults.h"

@class ReadFileJson, ClienteCompras;

@interface RestServices : NSObject

@property (nonatomic, strong) ReadFileJson *services;
@property (nonatomic, retain) UIViewController *superView;
@property(retain, nonatomic) UserDefaults  *userDefaults;


-(ResultBase *)doLoginUser:(NSString *)username withPassword:(NSString *)password;

-(NSMutableArray *) getInvoices;

-(NSMutableArray *) getClients;

-(NSMutableArray *) getProducts;

-(NSMutableArray *) getStores;

-(void)updateInvoice:(NSString *)idInvoice withParams:(NSDictionary *)params;

-(NSString *) createInvoice: (NSDictionary *) invoice;

-(ClienteCompras *) getInvoicesClient:(NSString *)document;

-(void) downloadInvoiceForClient:(ClienteCompras *)client withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSURL *filePath))completionBlock onError:(void (^)(NSError *error))errorBlock;


-(instancetype) initWithSuperView:(UIViewController *) view;
@end
