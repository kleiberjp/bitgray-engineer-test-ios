//
//  InvoiceClientView.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 30/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceClientView : UIView

@property UIButton *btnDownload;
@property UIButton *btnClose;
@property UIView *localView, *containerView, *invoiceView, *contentTotal, *contentTitle;
@property UITableView *contentTableView;
@property NSArray *products;
@property NSString *client, *document, *total;
@property UIVisualEffectView *blurEffectView;
@property UILabel *lblTitle, *lblDocument, *lblClient, *lblTotal, *lblAmountTotal;

-(id) initWithView:(UIView *)view andItems:(NSArray *) items;

-(void)showWithTittle:(NSString *)title andBackgroundImage:(UIImage *) image;

@end
