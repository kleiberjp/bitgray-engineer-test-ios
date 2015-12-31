//
//  CustomerInvoicesViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 30/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//
#import "ColorPalette.h"
#import "CustomerInvoicesViewController.h"
#import "ClienteCompras.h"
#import "InvoiceClientView.h"
#import "InvoiceClientCell.h"
#import "ItemClienteCompras.h"
#import "NSString+NSStringExtension.h"
#import "UIView+ViewExtension.h"

@implementation CustomerInvoicesViewController
@synthesize searchIcon = _searchIcon;
InvoiceClientView *invoice;

CGRect initialFrame, finalFrame;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString getMessageText:@"title-client"]];
    self.searchIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SearchIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    finalFrame = CGRectMake(5, (self.tfClientSearch.bounds.size.height - self.tfClientSearch.bounds.size.height/2)/2 , self.tfClientSearch.bounds.size.height/2, self.tfClientSearch.bounds.size.height/2);
    initialFrame = CGRectMake(self.tfClientSearch.bounds.size.width/2, (self.tfClientSearch.bounds.size.height - self.tfClientSearch.bounds.size.height/2)/2, self.tfClientSearch.bounds.size.height/2, self.tfClientSearch.bounds.size.height/2);
    self.searchIcon.tintColor = primaryColor;
    [self.searchIcon setFrame:initialFrame];
    [self.tfClientSearch addSubview:self.searchIcon];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

}


- (void)keyboardWillShow:(NSNotification*)aNotification {
    self.tfClientSearch.leftViewMode = UITextFieldViewModeAlways;
    self.tfClientSearch.leftView = self.searchIcon;
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ // tweak here to adjust the moving position
                         [self.searchIcon setFrame:finalFrame];
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if ([NSString isEmpty:self.tfClientSearch.text]) {
        self.tfClientSearch.leftView = nil;
        [self.tfClientSearch addSubview:self.searchIcon];
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.searchIcon setFrame:initialFrame];
                         }
                         completion:^(BOOL finished) {
                             nil;
                         }
         ];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.returnKeyType==UIReturnKeySearch) {
        if (![self validateEmptyField: self.tfClientSearch]) {
            [self.tfClientSearch setError:[NSString getMessageText:@"field-required"]];
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ClienteCompras *comprasClient = [self.services getInvoicesClient:self.tfClientSearch.text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![NSString isEmpty:comprasClient.nombres]){
                        [self showModalInvoice:comprasClient];
                    }
                });
            });
        }
    }
}

-(void) showModalInvoice: (ClienteCompras *) item{
    
    NSMutableArray *purchases = [[NSMutableArray alloc] init];
    
    for (ItemClienteCompras *element in item.itemClienteCompras) {
        if (element.idProductoProducto != nil) {
            [purchases addObject:element];
        }
    }
    
    invoice = [[InvoiceClientView alloc] initWithView:self.view.superview.window andItems:purchases];
    
    invoice.client = item.nombres;
    invoice.total = [NSString stringWithFormat:@"%.0f", item.totalSpent];
    invoice.document = [NSString stringWithFormat:@"%.0f", item.documento];
    
    [invoice.btnClose addTarget:self action:@selector(dismissInvoice) forControlEvents:UIControlEventTouchUpInside];
    
    invoice.contentTableView.delegate = self;
    invoice.contentTableView.dataSource = self;
    [invoice.contentTableView reloadData];
    
    [invoice showWithTittle:[NSString stringWithFormat:[NSString getMessageText:@"title-client-purchases"], item.nombres] andBackgroundImage:[self.view getBackGroundImage]];
}

-(void)dismissInvoice{
    [UIView animateWithDuration:0.45
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = invoice.containerView.frame;
                         frame.origin.y = self.view.frame.size.height;
                         [invoice.containerView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         [invoice.blurEffectView removeFromSuperview];
                    
                     }
     ];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [invoice.products count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InvoiceClientCell";
    
    InvoiceClientCell *cell = (InvoiceClientCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    cell.contentView.layer.masksToBounds = true;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 1.0;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowColor = ([UIColor lightGrayColor]).CGColor;
    cell.layer.shadowRadius = 0;
    cell.backgroundColor = [UIColor clearColor];
    
    ItemClienteCompras *item = [invoice.products objectAtIndex:indexPath.row];
    cell.lblProduct.text = (item.idProductoProducto != nil) ? item.idProductoProducto: @" -- ";
    cell.lblStore.text = (item.idSedeSede) ? item.idSedeSede : @" -- ";
    cell.lblPrice.text = (item.precio != 0) ? [NSString stringWithFormat:@"%.0f",item.precio] : [NSString stringWithFormat:@"%.0f", item.idProductoPrecio];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


@end
