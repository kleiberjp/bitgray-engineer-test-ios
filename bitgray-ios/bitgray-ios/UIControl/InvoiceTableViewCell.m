//
//  InvoiceTableViewCell.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "InvoiceTableViewCell.h"

@implementation InvoiceTableViewCell
@synthesize lblDate = _lblDate,
            lblCustomerName = _lblCustomerName,
            lblProductName = _lblProductName,
            lblStore = _lblStore,
            lblProductPrice = _lblProductPrice;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
