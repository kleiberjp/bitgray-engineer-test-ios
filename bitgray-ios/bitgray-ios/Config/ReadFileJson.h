//
//  ReadFileJson.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadFileJson : NSObject{
    NSString *_urlServices;
}

#pragma general urls

-(NSString *) getUrlServices;
-(NSString *) getAddressLogin;


#pragma urls cliente

-(NSString *) getAddressListaClientes;
-(NSString *) getAddressDetalleCliente;
-(NSString *) getAddressComprasCliente;
-(NSString *) getAddressDownloadInvoice;

#pragma urls compras

-(NSString *) getAddressListaCompras;
-(NSString *) getAddressDetalleCompras;


#pragma urls producto
-(NSString *) getAddressListaProductos;
-(NSString *) getAddressDetalleProducto;

#pragma sedes

-(NSString *) getAddressListaSedes;
-(NSString *) getAddressDEtalleSede;



@end
