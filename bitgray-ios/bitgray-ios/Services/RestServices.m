//
//  RestServices.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 28/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "RestServices.h"
#import "AFNetworking.h"
#import "NSString+NSStringExtension.h"
#import "ParentViewController.h"
#import "ResultBase.h"
#import "ReadFileJson.h"


@implementation RestServices
@synthesize superView = _superView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _services = [[ReadFileJson alloc] init];
    }
    return self;
}

-(instancetype) initWithSuperView:(ParentViewController *) view{
    self = [super init];
    if (self) {
        _services = [[ReadFileJson alloc] init];
        self.superView = view;
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.superView showAlert:@"Success" withMessage:[NSString stringWithFormat:@"%@", data]];
            });
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

@end
