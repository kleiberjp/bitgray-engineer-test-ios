//
//  NSString+NSStringExtension.h
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringExtension)

-(BOOL)stringIsValidEmailAddress;

-(NSString *) getMessage;

+(NSString *) getMessageText: (NSString *) findMessage;

+(NSString *) getMessageTextError:(NSString *)findMessage;

@end
