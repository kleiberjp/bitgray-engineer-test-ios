//
//  InvoiceGenericViewController.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 29/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "ParentViewController.h"
#import "Compras.h"
#import <MDDatePickerDialog.h>

@interface InvoiceGenericViewController : ParentViewController <MDCalendarDatePickerDialogDelegate>

@property (nonatomic, strong) Compras *invoiceItem;
@property (weak, nonatomic) IBOutlet UITextField *tfCustomer;
@property (weak, nonatomic) IBOutlet UITextField *tfProducto;
@property (weak, nonatomic) IBOutlet UITextField *tfSede;
@property (weak, nonatomic) IBOutlet UITextField *tfPrecio;
@property (weak, nonatomic) IBOutlet UITextField *tfDescripcion;
@property (weak, nonatomic) IBOutlet UITextField *tfDate;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end
