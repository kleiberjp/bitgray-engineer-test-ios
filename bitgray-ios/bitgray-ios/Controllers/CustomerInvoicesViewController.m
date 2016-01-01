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
#import <MDProgress.h>
#import "ProgressView.h"
#import "UIViewController+ViewControllerExtension.h"
#import <UIProgressView+AFNetworking.h>

@implementation CustomerInvoicesViewController
@synthesize searchIcon = _searchIcon;
InvoiceClientView *invoice;
ClienteCompras *clientConsulted;
ProgressView *progressView;
UIView *viewInvoiceFile;
NSURL *fileToOpen;

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
        }else if (![self validateNumberField:self.tfClientSearch]){
            [self.tfClientSearch setError:[NSString getMessageText:@"field-number-invalid"]];
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ClienteCompras *comprasClient = [self.services getInvoicesClient:self.tfClientSearch.text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![NSString isEmpty:comprasClient.nombres]){
                        clientConsulted = comprasClient;
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
    
    [invoice.btnDownload removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [invoice.btnDownload setTitle:[NSString getMessageText:@"download-button"] forState:UIControlStateNormal];
    [invoice.btnDownload addTarget:self action:@selector(downloadFileInvoice) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void) downloadFileInvoice{
    progressView = [[ProgressView alloc] initWithView:invoice.localView andBackground:[self.view getBackGroundImage]];
    
    [UIView animateWithDuration:0.45
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = invoice.containerView.frame;
                         frame.origin.y = self.view.frame.size.height;
                         [invoice.containerView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         invoice.btnClose.hidden = YES;
                         [progressView showProgress];
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                             [self.services downloadInvoiceForClient:clientConsulted
                                                        withProgress:^(CGFloat progress) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [progressView setProgressComplete:progress];
                                                            });
                                                        }
                                                          completion:^(NSURL *filePath) {
                                                              fileToOpen = filePath;
                                                              [invoice.btnDownload setTitle:[NSString getMessageText:@"open-file-downloaded-button"]
                                                                                   forState:UIControlStateNormal];
                                                              [invoice.btnDownload removeTarget:nil
                                                                                 action:NULL
                                                                       forControlEvents:UIControlEventAllEvents];
                                                              [invoice.btnDownload addTarget:self
                                                                                      action:@selector(openFileViewOpened)
                                                                            forControlEvents:UIControlEventTouchUpInside];
                                                              [progressView removeProgressView];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [self showAlertSuccess:[filePath.path lastPathComponent]];
                                                              });
                                 
                                                            }
                                                             onError:^(NSError *error) {
                                                                 [progressView removeProgressView];
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self showAlertError:@"Error" withMessage:[NSString stringWithFormat:@"%@", error]];
                                                                 });
                                                             }];
                            });
                         
                     }
     ];
}

-(void) showAlertError:(NSString *) title withMessage:(NSString *) message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alert = [UIAlertAction actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [alertController dismissViewControllerAnimated:YES
                                                                                          completion:nil];
                                                      [UIView animateWithDuration:0.35
                                                                            delay:0.1
                                                                          options:UIViewAnimationOptionCurveEaseIn
                                                                       animations:^{
                                                                           CGRect frame = invoice.containerView.frame;
                                                                           frame.origin.y = 0;
                                                                           [invoice.containerView setFrame:frame];
                                                                       }
                                                                       completion:^(BOOL finished) {
                                                                           invoice.btnClose.hidden = NO;
                                                                       }
                                                       ];
                                                  }];
    
    [alertController addAction:alert];
    [self presentViewController:alertController animated:YES completion:nil];
}
    


-(void)showAlertSuccess:(NSString *)namefile{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString getMessageText:@"title-alert-success"]
                                                                             message:[NSString stringWithFormat:[NSString getMessageText:@"message-alert-success"], namefile]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *_continue = [UIAlertAction actionWithTitle:[NSString getMessageText:@"open-file-button"]
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self openFile];
                                                      }];
    
    UIAlertAction *_cancel = [UIAlertAction actionWithTitle:[NSString getMessageText:@"cancel-button"]
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [alertController dismissViewControllerAnimated:YES
                                                                                            completion:nil];
                                                        [UIView animateWithDuration:0.35
                                                                              delay:0.1
                                                                            options:UIViewAnimationOptionCurveEaseIn
                                                                         animations:^{
                                                                             CGRect frame = invoice.containerView.frame;
                                                                             frame.origin.y = 0;
                                                                             [invoice.containerView setFrame:frame];
                                                                         }
                                                                         completion:^(BOOL finished) {
                                                                             invoice.btnClose.hidden = NO;

                                                                         }
                                                         ];
                                                    }];
    
    
    [alertController addAction:_continue];
    [alertController addAction:_cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void) openFile{
    //CGRect fullScreenRect=[[UIScreen mainScreen]applicationFrame];
    viewInvoiceFile = [[UIView alloc] initWithFrame:invoice.localView.frame];
    viewInvoiceFile.backgroundColor = [UIColor clearColor];
    
    UIButton *btnClose = [[UIButton alloc] init];
    [btnClose setFrame:CGRectMake(invoice.localView.bounds.size.width - 58, 20, 48, 48)];
    [btnClose setBackgroundColor:[UIColor clearColor]];
    [btnClose setImage:[UIImage imageNamed:@"CloseIcon"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [viewInvoiceFile addSubview:btnClose];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, btnClose.frame.origin.y + btnClose.frame.size.height + 10, invoice.localView.frame.size.width -20, invoice.localView.frame.size.height - ((btnClose.frame.origin.y + btnClose.frame.size.height + 10)* 2))];
    
    NSString *path = fileToOpen.path;
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    [viewInvoiceFile addSubview:webView];
    
    [invoice.localView addSubview:viewInvoiceFile];
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[invoice.localView layer] addAnimation:animation forKey:@"layerAnimation"];
}


-(void) openFileViewOpened{
    viewInvoiceFile = [[UIView alloc] initWithFrame:invoice.localView.frame];
    viewInvoiceFile.backgroundColor = [UIColor clearColor];
    
    UIButton *btnClose = [[UIButton alloc] init];
    [btnClose setFrame:CGRectMake(invoice.localView.bounds.size.width - 58, 20, 48, 48)];
    [btnClose setBackgroundColor:[UIColor clearColor]];
    [btnClose setImage:[UIImage imageNamed:@"CloseIcon"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [viewInvoiceFile addSubview:btnClose];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, btnClose.frame.origin.y + btnClose.frame.size.height + 10, invoice.localView.frame.size.width -20, invoice.localView.frame.size.height - ((btnClose.frame.origin.y + btnClose.frame.size.height + 10)* 2))];
    
    NSString *path = fileToOpen.path;
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    [viewInvoiceFile addSubview:webView];
    
    [UIView animateWithDuration:0.45
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = invoice.containerView.frame;
                         frame.origin.y = self.view.frame.size.height;
                         [invoice.containerView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         invoice.btnClose.hidden = YES;
                         [invoice.localView addSubview:viewInvoiceFile];
                         CATransition *animation = [CATransition animation];
                         [animation setType:kCATransitionFade];
                         [[invoice.localView layer] addAnimation:animation forKey:@"layerAnimation"];
                     }
     ];
    
}


-(void)closeWebView{
    [UIView animateWithDuration:0.35
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = viewInvoiceFile.frame;
                         frame.origin.y = invoice.localView.frame.size.height;
                         [viewInvoiceFile setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.35
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect frame = invoice.containerView.frame;
                                              frame.origin.y = 0;
                                              [invoice.containerView setFrame:frame];
                                          }
                                          completion:^(BOOL finished) {
                                              invoice.btnClose.hidden = NO;
                                              
                                          }
                          ];
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
