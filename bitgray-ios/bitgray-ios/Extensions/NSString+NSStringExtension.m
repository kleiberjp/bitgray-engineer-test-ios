//
//  NSString+NSStringExtension.m
//  bitgray-ios
//
//  Created by Kleiber J Perez on 27/12/15.
//  Copyright © 2015 Kleiber J Perez. All rights reserved.
//

#import "NSString+NSStringExtension.h"

@implementation NSString (NSStringExtension)

+(BOOL) isEmpty:(NSString *)string
{
    BOOL empty = ( string == nil ||
                  [string isKindOfClass:[NSNull class]] ||
                  ([string respondsToSelector:@selector(length)] && [(NSData *)string length] == 0) ||
                  ([string respondsToSelector:@selector(count)] && [(NSArray *)string count] == 0));
    return empty;
}

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

-(NSDate *)parseToDateFromString{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate* output = [dateFormat dateFromString:self];
    return output;
}

+(NSString *) parseToStringFromDate: (NSDate *) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

-(NSString *) parseToStringDateParam{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDateFormatter *stringFormat = [[NSDateFormatter alloc] init];
    [stringFormat setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [stringFormat dateFromString:self];
    NSString* output = [dateFormat stringFromDate:date];
    return output;
}


@end
