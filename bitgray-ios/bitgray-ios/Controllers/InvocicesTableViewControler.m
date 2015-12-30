//
//  InvocicesTableViewControler.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "InvocicesTableViewControler.h"
#import "InvoiceTableViewCell.h"
#import "InvoiceGenericViewController.h"
#import "NSString+NSStringExtension.h"
#import "Cliente.h"
#import "ColorPalette.h"
#import "Compras.h"
#import "Producto.h"
#import "Sede.h"

@interface InvocicesTableViewControler ()

@end

@implementation InvocicesTableViewControler

static bool addItem;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.services = [[RestServices alloc] initWithSuperView:self];
    self.invoicesData = [[NSMutableArray alloc] init];
    self.tableView.layer.masksToBounds = NO;
    self.tableView.clipsToBounds = NO;
    addItem = NO;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addButton];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.invoicesData = [self.services getInvoices];
        if ([self.services.userDefaults getListClients] == nil) {
            [self.services getClients];
        }
        if ([self.services.userDefaults getListProduct] == nil) {
            [self.services getProducts];
        }
        if ([self.services.userDefaults getListStores] == nil) {
            [self.services getStores];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString getMessageText:@"title-list-invoice"]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.buttonAdd removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.invoicesData count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"invoiceItem";
    
    InvoiceTableViewCell *cell = (InvoiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.contentView.layer.cornerRadius = 3;
    cell.contentView.layer.masksToBounds = true;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOpacity = 1.0;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowColor = primaryColor.CGColor;
    cell.layer.shadowRadius = 0;
    cell.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    Compras *invoice = [self.invoicesData objectAtIndex:indexPath.row];
    
    
    cell.lblDate.text = [NSString parseToStringFromDate:[invoice.fecha parseToDateFromString]];
    cell.lblCustomerName.text = (invoice.idCliente.nombres != nil) ? invoice.idCliente.nombres : @" -- ";
    cell.lblProductName.text = (invoice.idProducto.producto != nil) ? invoice.idProducto.producto : @" -- ";
    cell.lblStore.text = (invoice.idSede.sede != nil) ? invoice.idSede.sede : @" -- ";
    cell.lblProductPrice.text = (invoice.precio == 0) ? [NSString stringWithFormat:@"%.0f",invoice.idProducto.precio ] : [NSString stringWithFormat:@"%.0f",invoice.precio ];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.buttonAdd.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - 80;
    self.buttonAdd.frame = frame;
    
    [self.view bringSubviewToFront:self.buttonAdd];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)goToDetail:(id) sender{
    addItem = YES;
    [self performSegueWithIdentifier:@"detailInvoice" sender:self];
}

-(void) addButton{
    self.buttonAdd = [[MDButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 80, 56, 56) type:FloatingAction rippleColor:ripple];
    self.buttonAdd.backgroundColor = primaryColor;
    [self.buttonAdd setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [self.buttonAdd addTarget:self action:@selector(goToDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonAdd];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailInvoice"] && !addItem){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Compras *item = [self.invoicesData objectAtIndex:indexPath.row];
        InvoiceGenericViewController *detailItem = segue.destinationViewController;
        detailItem.invoiceItem = item;
    }
}


@end
