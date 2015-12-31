//
//  InvoiceClientCell.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 30/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceClientCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblStore;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@end
