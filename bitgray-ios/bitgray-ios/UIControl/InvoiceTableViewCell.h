//
//  InvoiceTableViewCell.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblStore;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;

@end
