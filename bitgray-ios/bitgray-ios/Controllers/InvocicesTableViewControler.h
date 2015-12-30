//
//  InvocicesTableViewControler.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestServices.h"
#import "MDButton.h"


@interface InvocicesTableViewControler : UITableViewController

@property (nonatomic, strong) RestServices *services;
@property (nonatomic, retain) NSMutableArray *invoicesData;
@property (nonatomic, retain) MDButton *buttonAdd;


@end
