//
//  RestServices.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "RestServices.h"
#import "AFNetworking.h"
#import "Compras.h"
#import "Cliente.h"
#import "Producto.h"
#import "Sede.h"
#import <MDSnackbar.h>
#import "NSString+NSStringExtension.h"
#import "UIViewController+ViewControllerExtension.h"
#import "ParentViewController.h"
#import "ResultBase.h"
#import "ReadFileJson.h"


@implementation RestServices
@synthesize superView = _superView;
@synthesize userDefaults = _userDefaults;
@synthesize services = _services;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.services = [[ReadFileJson alloc] init];
        self.userDefaults = [[UserDefaults alloc] init];
    }
    return self;
}

-(instancetype) initWithSuperView:(UIViewController *) view{
    self = [super init];
    if (self) {
        self.services = [[ReadFileJson alloc] init];
        self.superView = view;
        self.userDefaults = [[UserDefaults alloc] init];

    }
    return self;
}



-(ResultBase *) doLoginUser:(NSString *)username withPassword:(NSString *)password{
    dispatch_group_t group = dispatch_group_create();
    ResultBase *result = [[ResultBase alloc] init];
    
    NSString *URLString = [self.services getAddressLogin];
    NSDictionary *parameters = @{@"username": username, @"password": password};
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView showLoadingView];
    });
    
    dispatch_group_enter(group);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSDictionary *data = (NSDictionary *)responseObject;
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Error" withMessage:[NSString getMessageText:[data allKeys][0]]];
            });
        } else {
            result.success = TRUE;
            [self.userDefaults setPasswordUserIncome:password];
            [self.userDefaults setLastUserIncome:username];
            [self.userDefaults setAlreadyLoged:YES];
            /*dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Success" withMessage:[NSString stringWithFormat:@"%@", data]];
            });*/
        }
        dispatch_group_leave(group);
    }];
    
    [dataTask resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
    
    return result;
}

-(NSMutableArray *) getInvoices{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *listInvoices = [[NSMutableArray alloc] init];
    
    NSString *URLString = [self.services getAddressListaCompras];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView showLoadingView];
    });
    
    dispatch_group_enter(group);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *data = (NSDictionary *)responseObject;
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
            });
        }else{
            for (NSDictionary *item in data) {
                Compras *invoice = [[Compras alloc] initWithDictionary:item];
                [listInvoices addObject:invoice];
            }
        }
        dispatch_group_leave(group);
    }];
    
    [task resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
    
    return listInvoices;
}

-(void)updateInvoice:(NSString *)idInvoice withParams:(NSDictionary *)params{
    dispatch_group_t group = dispatch_group_create();
    
    NSString *URLString = [NSString stringWithFormat:[self.services getAddressDetalleCompras], idInvoice];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:params error:nil];
    
    dispatch_group_enter(group);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
            });
        }else{
            MDSnackbar *snackbar = [[MDSnackbar alloc] initWithText:[NSString getMessageText:@"invoice-updated"] actionTitle:@"OK"];
            snackbar.actionTitleColor = [UIColor colorWithRed:0.298 green:0.686 blue:0.314 alpha:1];
            snackbar.duration = 3;
            snackbar.multiline = YES;
            [snackbar show];
        }
        dispatch_group_leave(group);
    }];
    
    [task resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
}

-(NSString *) createInvoice:(NSDictionary *)invoice{
    dispatch_group_t group = dispatch_group_create();
    __block NSString *idInvoiceCreated;
    NSString *URLString = [self.services getAddressListaCompras];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:invoice error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView showLoadingView];
    });
    
    dispatch_group_enter(group);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *data = (NSDictionary *)responseObject;
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
            });
        }else{
            idInvoiceCreated = [data objectForKey:@"id"];
            MDSnackbar *snackbar = [[MDSnackbar alloc] initWithText: [NSString getMessageText:@"invoice-created"] actionTitle:@"OK"];
            snackbar.actionTitleColor = [UIColor colorWithRed:0.298 green:0.686 blue:0.314 alpha:1];
            snackbar.duration = 3;
            snackbar.multiline = YES;
            [snackbar show];
        }
        dispatch_group_leave(group);
    }];
    
    [task resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
    
    return idInvoiceCreated;
}

-(NSMutableArray *)getClients{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *listClients = [[NSMutableArray alloc] init];
    
    NSString *URLString = [self.services getAddressListaClientes];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView showLoadingView];
    });
    
    dispatch_group_enter(group);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *data = (NSDictionary *)responseObject;
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
            });
        }else{
            for (NSDictionary *item in data) {
                Cliente *client = [[Cliente alloc] initWithDictionary:item];
                [listClients addObject:client];
            }
            NSData *listObject = [NSKeyedArchiver archivedDataWithRootObject:listClients];
            [self.userDefaults setListClients:listObject];
        }
        dispatch_group_leave(group);
    }];
    
    [task resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
    return listClients;
}

-(NSMutableArray *)getProducts{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *listProducts = [[NSMutableArray alloc] init];

    NSString *URLString = [self.services getAddressListaProductos];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView showLoadingView];
    });
    
    dispatch_group_enter(group);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *data = (NSDictionary *)responseObject;
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
            });
        }else{
            for (NSDictionary *item in data) {
                Producto *client = [[Producto alloc] initWithDictionary:item];
                [listProducts addObject:client];
            }
            NSData *listObject = [NSKeyedArchiver archivedDataWithRootObject:listProducts];
            [self.userDefaults setListProducts:listObject];
        }
        dispatch_group_leave(group);
    }];
    
    [task resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
    
    return listProducts;
}

-(NSMutableArray *)getStores{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *listStores = [[NSMutableArray alloc] init];

    NSString *URLString = [self.services getAddressListaSedes];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView showLoadingView];
    });
    
    dispatch_group_enter(group);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *data = (NSDictionary *)responseObject;
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
            });
        }else{
            for (NSDictionary *item in data) {
                Sede *client = [[Sede alloc] initWithDictionary:item];
                [listStores addObject:client];
            }
            NSData *listObject = [NSKeyedArchiver archivedDataWithRootObject:listStores];
            [self.userDefaults setListStores:listObject];
        }
        dispatch_group_leave(group);
    }];
    
    [task resume];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
    return listStores;
}

@end
