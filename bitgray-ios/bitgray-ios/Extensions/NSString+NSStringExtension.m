//
//  NSString+NSStringExtension.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "NSString+NSStringExtension.h"

@implementation NSString (NSStringExtension)

- (BOOL)stringIsValidEmailAddress {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(NSString *) getMessage {
    
    return NSLocalizedString(self, self);
}

+(NSString *) getMessageText: (NSString *) findMessage {
    return NSLocalizedString(findMessage, findMessage);
}

+(NSString *) getMessageTextError:(NSString *)findMessage{
    return [[NSString alloc] initWithFormat:@"* %@", NSLocalizedString(findMessage, findMessage)];
}


@end
