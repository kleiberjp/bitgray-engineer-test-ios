//
//  InvoiceGenericViewController.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "InvoiceGenericViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "Cliente.h"
#import "Compras.h"
#import "ItemCompra.h"
#import <MDSnackbar.h>
#import "NSString+NSStringExtension.h"
#import "Producto.h"
#import "PickerViewController.h"
#import "Sede.h"

@interface InvoiceGenericViewController ()

@end

@implementation InvoiceGenericViewController
@synthesize invoiceItem;
PickerViewController *modalCostumer, * modalStore, *modalProduct;
NSMutableArray *listClient, *listProduct, *listStore;
NSInteger indexClient, indexProduct, indexStore;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    listClient = [self.services.userDefaults getListClients];
    listProduct = [self.services.userDefaults getListProduct];
    listStore = [self.services.userDefaults getListStores];
    [[self tfCustomer] addTarget:self action:@selector(showCostumerClients) forControlEvents:UIControlEventEditingDidBegin];
    [[self tfProducto] addTarget:self action:@selector(showProducts) forControlEvents:UIControlEventEditingDidBegin];
    [[self tfSede] addTarget:self action:@selector(showStores) forControlEvents:UIControlEventEditingDidBegin];
    [[self tfDate] addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableSlidePanGestureForLeftMenu];
    // Do any additional setup after loading the view.
    [self loadData];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backToMain:)];
    NSString *title = (invoiceItem != nil) ? [NSString stringWithFormat:[NSString getMessageText:@"title-invoice"], invoiceItem.internalBaseClassIdentifier] : [NSString getMessageText:@"title-generate-invoice"];
    [self.navigationItem setTitle:title];
    [self.navigationItem setLeftBarButtonItem: backButton];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Generics Functions

- (IBAction)saveUpdate:(id)sender {
    if ([self validateFields]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (invoiceItem) {
                [self.services updateInvoice:[NSString stringWithFormat:@"%.0f",invoiceItem.internalBaseClassIdentifier] withParams:[self updateItem]];
            }else{
                NSString *idInvoice = [self.services createInvoice:[self createInvoice]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![NSString isEmpty:idInvoice]) {
                        [self.navigationItem setTitle:[NSString stringWithFormat:[NSString getMessageText:@"title-invoice"], idInvoice]];
                    }
                });
            }
        });
    }
    
}

-(void) showDatePicker{
    MDDatePickerDialog *datePicker = [[MDDatePickerDialog alloc] init];
    datePicker.delegate = self;
    [datePicker show];
}

-(void) showCostumerClients{
    NSMutableArray *clientsName = [[NSMutableArray alloc] init];
    modalCostumer = [[PickerViewController alloc] initPickerWithView:self.view];
    [[modalCostumer uiButtonCancel] addTarget:self action:@selector(cancelPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [[modalCostumer uiButtonDone] addTarget:self action:@selector(donePickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [[modalCostumer uiButtonCancel] setTag:0];
    [[modalCostumer uiButtonDone] setTag:0];
    
    if (listClient != nil) {
        for (Cliente *item in listClient){
            if (item.nombres != nil) [clientsName addObject:item.nombres];
        }
        [modalCostumer showPicker:[NSString getMessageText:@"select-costumer"] withData:clientsName];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            listClient = [self.services getClients];
            if (listClient != nil) {
                for (Cliente *item in listClient){
                    if (item.nombres != nil) [clientsName addObject:item.nombres];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [modalCostumer showPicker:[NSString getMessageText:@"select-costumer"] withData:clientsName];
                });
            }
        });
    }
    if (![NSString isEmpty:self.tfCustomer.text]) {
        [[modalCostumer regularPicker] selectRow:[clientsName indexOfObject:self.tfCustomer.text] inComponent:0 animated:YES];
    }
}

-(void) showProducts{
    NSMutableArray *productsName = [[NSMutableArray alloc] init];
    modalProduct = [[PickerViewController alloc] initPickerWithView:self.view];
    [[modalProduct uiButtonCancel] addTarget:self action:@selector(cancelPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [[modalProduct uiButtonDone] addTarget:self action:@selector(donePickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [[modalProduct uiButtonCancel] setTag:1];
    [[modalProduct uiButtonDone] setTag:1];
    
    if (listProduct != nil) {
        for (Producto *item in listProduct){
            if (item.producto != nil) [productsName addObject:item.producto];
        }
        [modalProduct showPicker:[NSString getMessageText:@"select-product"] withData:productsName];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            listProduct = [self.services getProducts];
            if (listProduct != nil) {
                for (Producto *item in listProduct){
                    if (item.producto != nil) [productsName addObject:item.producto];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [modalProduct showPicker:[NSString getMessageText:@"select-product"]withData:productsName];
                });
            }
        });
    }
    if (![NSString isEmpty:self.tfProducto.text]) {
        [[modalProduct regularPicker] selectRow:[productsName indexOfObject:self.tfProducto.text] inComponent:0 animated:YES];
    }
}

-(void) showStores{
    NSMutableArray *storesName = [[NSMutableArray alloc] init];
    modalStore = [[PickerViewController alloc] initPickerWithView:self.view];
    [[modalStore uiButtonCancel] addTarget:self action:@selector(cancelPickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [[modalStore uiButtonDone] addTarget:self action:@selector(donePickerButton:) forControlEvents:UIControlEventTouchUpInside];
    [[modalStore uiButtonCancel] setTag:2];
    [[modalStore uiButtonDone] setTag:2];
    
    if (listStore != nil) {
        for (Sede *item in listStore){
            if (item.sede != nil) [storesName addObject:item.sede];
        }
        [modalStore showPicker:[NSString getMessageText:@"select-store"] withData:storesName];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            listStore = [self.services getStores];
            if (listStore != nil) {
                for (Sede *item in listStore){
                    if (item.sede != nil) [storesName addObject:item.sede];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [modalStore showPicker:[NSString getMessageText:@"select-store"] withData:storesName];
                });
            }
        });
    }
    if (![NSString isEmpty:self.tfSede.text]) {
        [[modalStore regularPicker] selectRow:[storesName indexOfObject:self.tfSede.text] inComponent:0 animated:YES];
    }
}

- (void)donePickerButton:(id)button {
    NSString *result;
    
    switch ([button tag]) {
        case 0:
            [modalCostumer dismiss];
            result = [modalCostumer dataArray][(NSUInteger) [[modalCostumer regularPicker] selectedRowInComponent:0]];
            indexClient = [[modalCostumer regularPicker] selectedRowInComponent:0];
            [self.tfCustomer setText:result];
            if ([NSString isEmpty:self.tfProducto.text]) {
                [self.tfProducto becomeFirstResponder];
            }
            break;
        case 1:
            [modalProduct dismiss];
            result = [modalProduct dataArray][(NSUInteger) [[modalProduct regularPicker] selectedRowInComponent:0]];
            indexProduct = [[modalProduct regularPicker] selectedRowInComponent:0];
            [self.tfProducto setText:result];
            if ([NSString isEmpty:self.tfSede.text]) {
                [self.tfSede becomeFirstResponder];
            }
            break;
        case 2:
            [modalStore dismiss];
            result = [modalStore dataArray][(NSUInteger) [[modalStore regularPicker] selectedRowInComponent:0]];
            indexStore = [[modalStore regularPicker] selectedRowInComponent:0];
            [self.tfSede setText:result];
            if ([NSString isEmpty:self.tfPrecio.text]) {
                [self.tfPrecio becomeFirstResponder];
            }
            break;
        default:
            break;
    }
}

- (void)cancelPickerButton:(id)button {
    switch ([button tag]) {
        case 0:
            [modalCostumer dismiss];
            [self.tfCustomer becomeFirstResponder];
            break;
        case 1:
            [modalProduct dismiss];
            [self.tfProducto becomeFirstResponder];
            break;
        case 2:
            [modalStore dismiss];
            [self.tfSede becomeFirstResponder];
            break;
        default:
            break;
    }
}

-(void) loadData{
    if (invoiceItem != nil) {
        [self.btnSave setTitle:[NSString getMessageText:@"update"] forState:UIControlStateNormal];
        self.tfCustomer.text = (invoiceItem.idCliente.nombres != nil) ? invoiceItem.idCliente.nombres : @"";
        self.tfProducto.text = (invoiceItem.idProducto.producto != nil) ? invoiceItem.idProducto.producto : @"";
        self.tfSede.text = (invoiceItem.idSede.sede != nil) ? invoiceItem.idSede.sede : @"";
        self.tfPrecio.text = (invoiceItem.precio == 0) ? [NSString stringWithFormat:@"%.0f",invoiceItem.idProducto.precio ] : [NSString stringWithFormat:@"%.0f",invoiceItem.precio ];
        self.tfDescripcion.text = (invoiceItem.descripcion != nil) ? invoiceItem.descripcion : @"";
        self.tfDate.text = [NSString parseToStringFromDate:[invoiceItem.fecha parseToDateFromString]];
    }
}

-(BOOL) validateFields{
    BOOL areFieldsOK = YES, errors = NO;
    
    if (![self validateEmptyField:self.tfCustomer]) {
        [self.tfCustomer setError:[NSString getMessageTextError:@"field-select-required"]];
        errors = YES;
    }
    
    if (![self validateEmptyField:self.tfProducto]) {
        [self.tfCustomer setError:[NSString getMessageTextError:@"field-select-required"]];
        errors = YES;
    }
    
    if (errors) {
        areFieldsOK = NO;
    }
    
    return areFieldsOK;
}

-(NSDictionary *) updateItem{
    ItemCompra *item = [[ItemCompra alloc] init];
    
    if (![self.tfCustomer.text isEqualToString:invoiceItem.idCliente.nombres] ) {
        item.cliente = [[listClient objectAtIndex:indexClient] idClienteIdentifier];
    }else{
        item.cliente = invoiceItem.idCliente.idClienteIdentifier;
    }
    
    if (![self.tfProducto.text isEqualToString:invoiceItem.idProducto.producto] ) {
        item.producto = [[listProduct objectAtIndex:indexProduct] idProductoIdentifier];
    }else{
        item.producto = invoiceItem.idProducto.idProductoIdentifier;
    }
    
    if (![NSString isEmpty:self.tfSede.text] && ![self.tfSede.text isEqualToString:invoiceItem.idSede.sede] ) {
        item.sede = [[listStore objectAtIndex:indexStore] idSedeIdentifier];
    }else{
        item.sede = invoiceItem.idSede.idSedeIdentifier;
    }
    
    if (![NSString isEmpty:self.tfPrecio.text] && ![self.tfPrecio.text isEqualToString:(invoiceItem.precio == 0) ? [NSString stringWithFormat:@"%.0f",invoiceItem.idProducto.precio ] : [NSString stringWithFormat:@"%.0f",invoiceItem.precio ]] ) {
        item.precio = [self.tfPrecio.text doubleValue];
    }else{
        item.precio = invoiceItem.precio;
    }
    
    if(![NSString isEmpty:self.tfDescripcion.text] && ![self.tfDescripcion.text isEqualToString:invoiceItem.descripcion]){
        item.descripcion = self.tfDescripcion.text;
    }else{
        item.descripcion = invoiceItem.descripcion ;
    }
    
    if (![NSString isEmpty:self.tfDate.text] && ![[self.tfDate.text parseToStringDateParam] isEqualToString:invoiceItem.fecha]){
        item.fecha = [self.tfDate.text parseToStringDateParam];
    }else{
        item.fecha = invoiceItem.fecha;
    }
    
    return [item dictionaryRepresentation];
}

-(NSDictionary *) createInvoice{
    ItemCompra *item = [[ItemCompra alloc] init];
    item.cliente = [[listClient objectAtIndex:indexClient] idClienteIdentifier];
    item.producto = [[listProduct objectAtIndex:indexProduct] idProductoIdentifier];
    
    if(![NSString isEmpty:self.tfSede.text]){
       item.sede = [[listStore objectAtIndex:indexStore] idSedeIdentifier];
    }
    
    if(![NSString isEmpty:self.tfPrecio.text]){
        item.precio = [self.tfPrecio.text doubleValue];
    }
    
    if(![NSString isEmpty:self.tfDescripcion.text]){
        item.descripcion = self.tfDescripcion.text;
    }
    
    if(![NSString isEmpty:self.tfDate.text]){
        item.fecha = [self.tfDate.text parseToStringDateParam];
    }

    return [item dictionaryRepresentation];
}

#pragma mark - Navigation

-(void)backToMain:(id)sender{
    self.invoiceItem = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ((textField == _tfCustomer) || (textField == _tfProducto) || (textField == _tfSede)|| (textField == _tfDate) ) {
        [textField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField != _tfDescripcion) {
        [super textFieldShouldReturn:textField];
    }else{
        [textField resignFirstResponder];
        [_tfDate becomeFirstResponder];
        [_tfDate endEditing:YES];

    }
    return true;
}

- (void)datePickerDialogDidSelectDate:(NSDate *)date{
    self.tfDate.text = [NSString parseToStringFromDate:date];
    
}

@end
