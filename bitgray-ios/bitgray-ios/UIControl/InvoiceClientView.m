//
//  InvoiceClientView.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 30/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//
#import "ColorPalette.h"
#import "InvoiceClientView.h"
#import "InvoiceClientCell.h"
#import "ItemClienteCompras.h"
#import "NSString+NSStringExtension.h"
#import "UIImage+ImageExtension.h"
#import "UIView+ViewExtension.h"

@implementation InvoiceClientView

-(id)initWithView:(UIView *)view andItems:(NSArray *) items{
    self = [super init];
    [self setLocalView:view];
    [self setBtnClose:[[UIButton alloc] init]];
    [self setBtnDownload:[[UIButton alloc] init]];
    [self setContainerView:[[UIView alloc] init]];
    [self setInvoiceView:[[UIView alloc] init]];
    [self setProducts:items];
    
    self.containerView.frame = self.localView.bounds;
    
    [self.btnClose setFrame:CGRectMake(self.localView.bounds.size.width - 58, 20, 48, 48)];
    [self.btnClose setBackgroundColor:[UIColor clearColor]];
    [self.btnClose setImage:[UIImage imageNamed:@"CloseIcon"] forState:UIControlStateNormal];
    
    [self.btnDownload setFrame:CGRectMake(22.5, self.localView.bounds.size.height - 54, self.localView.bounds.size.width - 45, 44)];
    [self.btnDownload setBackgroundColor:primaryColor];
    [self.btnDownload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDownload setTitle:[NSString getMessageText:@"download-button"] forState:UIControlStateNormal];
    [self.btnDownload showsTouchWhenHighlighted];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, self.btnClose.frame.origin.y + self.btnClose.frame.size.height + 5, [[UIScreen mainScreen] bounds].size.width - 20, 44)];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.lblTitle setBackgroundColor:[UIColor clearColor]];
    self.lblTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    CGFloat originContainer = self.lblTitle.frame.size.height + self.lblTitle.frame.origin.y + 10;
    [self.invoiceView setFrame:CGRectMake(10, originContainer, self.localView.frame.size.width - 20, self.localView.frame.size.height - self.lblTitle.frame.origin.y -self.lblTitle.frame.size.height)];
    
    
    self.contentTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.invoiceView.frame.size.width, 55)];
    
    self.lblClient = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.invoiceView.frame.size.width/2 - 20, 35)];
    self.lblClient.textColor = primaryColor;
    self.lblClient.backgroundColor = [UIColor clearColor];
    self.lblClient.textAlignment = NSTextAlignmentLeft;
    self.lblClient.font = [self.lblClient.font fontWithSize:12];
    
    
    self.lblDocument = [[UILabel alloc] initWithFrame:CGRectMake(self.lblClient.frame.size.width + self.lblClient.frame.origin.x, 10, self.invoiceView.frame.size.width/2 - 20, 35)];
    self.lblDocument.textColor = [UIColor lightGrayColor];
    self.lblDocument.backgroundColor = [UIColor clearColor];
    self.lblDocument.textAlignment = NSTextAlignmentRight;
    self.lblDocument.font = [self.lblDocument.font fontWithSize:12];
    
    [self.contentTitle addSubview:self.lblClient];
    [self.contentTitle addSubview:self.lblDocument];
    
    CGRect frameTableView = CGRectMake(0, self.contentTitle.frame.origin.y + self.contentTitle.frame.size.height, self.invoiceView.frame.size.width, self.invoiceView.frame.size.width - self.lblClient.frame.size.height);
    self.contentTableView = [[UITableView alloc] initWithFrame:frameTableView style:UITableViewStylePlain];
    self.contentTableView.rowHeight = 100;
    self.contentTableView.backgroundColor = [UIColor clearColor];
    
    self.contentTotal = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentTableView.frame.origin.y + self.contentTableView.frame.size.height, self.invoiceView.frame.size.width, 48)];
    
    self.lblTotal = [[UILabel alloc] initWithFrame:self.lblClient.frame];
    self.lblTotal.textAlignment = NSTextAlignmentLeft;
    self.lblTotal.font = [self.lblClient.font fontWithSize:14];
    self.lblTotal.textColor = [UIColor darkGrayColor];
    self.lblTotal.text = [NSString getMessageText:@"title-total"];
    
    self.lblAmountTotal = [[UILabel alloc] initWithFrame:self.lblDocument.frame];
    self.lblAmountTotal.textAlignment = NSTextAlignmentRight;
    self.lblAmountTotal.font = [self.lblClient.font fontWithSize:15];
    self.lblAmountTotal.textColor = primaryColor;
    
    [self.contentTotal addSubview:self.lblTotal];
    [self.contentTotal addSubview:self.lblAmountTotal];
    
    [self.invoiceView addSubview:self.contentTitle];
    [self.invoiceView addSubview:self.contentTableView];
    [self.invoiceView addSubview:self.contentTotal];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.localView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.blurEffectView.frame = self.localView.bounds;
        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.localView addSubview:self.blurEffectView];
    }
    else {
        self.localView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    
    [self.containerView addSubview:self.btnClose];
    [self.containerView addSubview:self.lblTitle];
    [self.containerView addSubview:self.invoiceView];
    [self.containerView addSubview:self.btnDownload];
    return self;
}


-(void)showWithTittle:(NSString *)title andBackgroundImage:(UIImage *) image{
    [self.lblTitle setText:title];
    self.lblDocument.text = self.document;
    self.lblClient.text = self.client;
    self.lblAmountTotal.text = self.total;
    
    self.contentTableView.backgroundColor = [UIColor colorWithPatternImage:[[image cropImage:self.invoiceView.bounds] applyLightEffect]];

    self.contentTotal.backgroundColor = [UIColor colorWithPatternImage:[[image cropImage:self.invoiceView.bounds] applyLightEffect]];
    
    self.contentTitle.backgroundColor = [UIColor colorWithPatternImage:[[image cropImage:self.invoiceView.bounds] applyLightEffect]];
    
    CGRect initialframe = CGRectMake(0, self.localView.bounds.size.height, self.localView.bounds.size.width, self.localView.bounds.size.height);
    CGRect endFrame = CGRectMake(0, 0, self.localView.bounds.size.width, self.localView.bounds.size.height);
    [self.containerView setFrame:initialframe];
    [UIView animateWithDuration:0.45
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.containerView setFrame:endFrame];
                     }
                     completion:^(BOOL finished) {
                         //[self.contentTableView reloadData];
                     }
     ];
    [self.localView addSubview:self.containerView];
}
@end
