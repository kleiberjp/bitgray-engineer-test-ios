//
//  CustomerInvoicesViewController.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 30/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "ParentViewController.h"

@interface CustomerInvoicesViewController : ParentViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *tfClientSearch;
@property (nonatomic, strong) UIView *searchIcon;

@end
