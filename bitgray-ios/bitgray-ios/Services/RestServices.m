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
#import "ClienteCompras.h"
#import "Cliente.h"
#import "Producto.h"
#import "Sede.h"
#import <MDSnackbar.h>
#import "NSString+NSStringExtension.h"
#import "UIViewController+ViewControllerExtension.h"
#import "ParentViewController.h"
#import "ResultBase.h"
#import "ReadFileJson.h"
#import <MDProgress.h>

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
            idInvoiceCreated = (NSString *)[data objectForKey:@"id"];
            MDSnackbar *snackbar = [[MDSnackbar alloc] initWithText: [NSString getMessageText:@"invoice-created"] actionTitle:@"OK"];
            snackbar.actionTitleColor = [UIColor colorWithRed:0.298 green:0.686 blue:0.314 alpha:1];
            snackbar.duration = 5;
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

-(ClienteCompras *)getInvoicesClient:(NSString *)document{
    dispatch_group_t group = dispatch_group_create();
    
    __block ClienteCompras *comprasClient = [[ClienteCompras alloc] init];
    
    NSString *URLString = [NSString stringWithFormat:[self.services getAddressComprasCliente], document];
    
    /*NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    //NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];*/
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView showLoadingView];
    });
    
    dispatch_group_enter(group);
    [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *data = (NSArray *)responseObject;
        if (data.count != 0) {
            NSDictionary *item = (NSDictionary *)[data objectAtIndex:0];
            comprasClient = [[ClienteCompras alloc] initWithDictionary:item];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Info" withMessage:[NSString stringWithFormat:[NSString getMessageText:@"message-no-client-invoice"], document]];
            });
        }
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.superView showAlert:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
        });
        dispatch_group_leave(group);
    }];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.superView hideLoadingView];
    });
    
    return comprasClient;
    
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

-(void) downloadInvoiceForClient:(ClienteCompras *)client withProgress:(void (^)(float progress))progressBlock completion:(void (^)(NSURL *filePath))completionBlock onError:(void (^)(NSError *error))errorBlock
{
    NSString *URLString = [NSString stringWithFormat:[self.services getAddressDownloadInvoice], [NSString stringWithFormat:@"%.0f", client.documento]];
    
    MDProgress *determinateProgress = [[MDProgress alloc] init];
    [determinateProgress setStyle:Linear];
    [determinateProgress setType:Determinate];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //Most URLs I come across are in string format so to convert them into an NSURL and then instantiate the actual request
    NSURL *formattedURL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:formattedURL];
    
    //Watch the manager to see how much of the file it's downloaded

    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        //Convert totalBytesWritten and totalBytesExpectedToWrite into floats so that percentageCompleted doesn't get rounded to the nearest integer
        float written = (float)totalBytesWritten;
        float total = (float)totalBytesExpectedToWrite;
        float percentageCompleted = fabsf(written/total);
        //Return the completed progress so we can display it somewhere else in app
        progressBlock(percentageCompleted);
    }];
    
    //Start the download
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //Getting the path of the document directory
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *fullURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:[NSString getMessageText:@"name-document"], client.nombres]];
        
        //If we already have a video file saved, remove it from the phone
        [self removeVideoAtPath:fullURL];
        return fullURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            //If there's no error, return the completion block
            completionBlock(filePath);
        } else {
            //Otherwise return the error block
            errorBlock(error);
        }
        
    }];
    
    [downloadTask resume];
}

-(void)removeVideoAtPath:(NSURL *)filePath
{
    NSString *stringPath = filePath.path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:stringPath]) {
        [fileManager removeItemAtPath:stringPath error:NULL];
    }
}

@end
