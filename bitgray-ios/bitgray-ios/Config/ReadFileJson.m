//
//  ReadFileJson.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "ReadFileJson.h"

@implementation ReadFileJson

-(id)init{
    self = [super init];
    if (self) {
        _urlServices = [self getUrlServices];
    }
    return self;
}


#pragma funciones urls generales

-(NSString *) getUrlServices{
    return [self getValueFor:@"urlservices"];
}

-(NSString *) getAddressLogin{
    return [_urlServices stringByAppendingString:[self getValueFor:@"login" inSection:@"services"]];
}


#pragma funciones urls clientes

-(NSString *) getAddressListaClientes{
    return [_urlServices stringByAppendingString:[self getValueFor:@"list-clientes" inSection:@"services"]];
}

-(NSString *) getAddressDetalleCliente{
    return [_urlServices stringByAppendingString:[self getValueFor:@"detalle-cliente" inSection:@"services"]];
}

-(NSString *) getAddressComprasCliente{
    return [_urlServices stringByAppendingString:[self getValueFor:@"compras-cliente" inSection:@"services"]];
}

-(NSString *) getAddressDownloadInvoice{
    return [_urlServices stringByAppendingString:[self getValueFor:@"download-compras" inSection:@"services"]];
}

#pragma funciones urls compras

-(NSString *) getAddressListaCompras{
    return [_urlServices stringByAppendingString:[self getValueFor:@"list-compras" inSection:@"services"]];
}

-(NSString *) getAddressDetalleCompras{
    return [_urlServices stringByAppendingString:[self getValueFor:@"detalle-compra" inSection:@"services"]];
}


#pragma funciones urls productos

-(NSString *) getAddressListaProductos{
    return [_urlServices stringByAppendingString:[self getValueFor:@"list-productos" inSection:@"services"]];
}

-(NSString *) getAddressDetalleProducto{
    return [_urlServices stringByAppendingString:[self getValueFor:@"detalle-producto" inSection:@"services"]];
}


#pragma funciones urls sedes

-(NSString *) getAddressListaSedes{
    return [_urlServices stringByAppendingString:[self getValueFor:@"list-sedes" inSection:@"services"]];
}

-(NSString *) getAddressDEtalleSede{
    return [_urlServices stringByAppendingString:[self getValueFor:@"detalle-sede" inSection:@"services"]];
}


#pragma funciones Generales

-(NSString *) getValueFor:(NSString *)key{
    NSDictionary *data = [self leerArchivo];
    if (data) return [data valueForKey:key];
    return @"";
}

-(NSString *) getValueFor:(NSString *)key inSection:(NSString *)section{
    NSDictionary *data = [self leerArchivo];
    
    if(data) return [[data objectForKey:section] valueForKey:key];
    return @"";
}

-(NSDictionary *) leerArchivo{
    NSError *jsonError;
    NSString *archivo = @"urls";
    
    NSString *rutaArchivo = [[NSString alloc] initWithString:archivo];
    NSString *ruta  = [[NSBundle mainBundle] pathForResource:rutaArchivo ofType:@"json"];
    NSString *dataArchivo = [[NSString alloc] initWithContentsOfFile:ruta encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [dataArchivo dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    return resultado;
}

@end
