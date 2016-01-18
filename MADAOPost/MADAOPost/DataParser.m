//
//  DataParser.m
//  Shire
//
//  Created by ZhSnow on 11/16/15.
//  Copyright © 2015 LLJZ. All rights reserved.
//

#import "DataParser.h"

@implementation DataParser

+ (NSDictionary *) dictionaryInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id d = [dictionary objectForKey:key];
    if (![d isKindOfClass:[NSDictionary class]]) {
        if ([d isKindOfClass:[NSString class]] && ((NSString *)d).length == 0)
            return [NSDictionary dictionary];
        else
            return nil;
    }
    return d;
}

+ (NSString *) stringInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id s = [dictionary objectForKey:key];
    if (![s isKindOfClass:[NSString class]])
        return nil;
    return s;
}

+ (NSNumber *) numberInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id s = [dictionary objectForKey:key];
    if (![s isKindOfClass:[NSString class]])
        return nil;
    return [NSNumber numberWithInteger:((NSString *)s).integerValue];
}

+ (NSNumber *) numberCanbeNilInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id s = [dictionary objectForKey:key];
    if ([s isEqualToString:@""]) {
        return nil;
    }
    return [NSNumber numberWithInteger:((NSString *)s).integerValue];
}

+ (NSNumber *) floatNumberInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id s = [dictionary objectForKey:key];
    if (![s isKindOfClass:[NSString class]])
        return nil;
    return [NSNumber numberWithFloat:((NSString *)s).floatValue];
}

+ (NSNumber *) doubleNumberInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id s = [dictionary objectForKey:key];
    if ([s isKindOfClass:[NSString class]]){
        return [NSNumber numberWithDouble:((NSString *)s).doubleValue];
    }else if ([s isKindOfClass:[NSNumber class]]) {
        return s;
    }
    return nil;
}

+ (NSNumber *) booleanInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id s = [dictionary objectForKey:key];
    if(s == nil)
    {
        return nil;
    }
    if ([s isKindOfClass:[NSNumber class]]) {
        return s;
    }
    return [NSNumber numberWithBool:NO];
}

+ (NSDate *) dateInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id s = [dictionary objectForKey:key];
    if (![s isKindOfClass:[NSString class]])
        return nil;
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    df.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df dateFromString:s];

//    return [NSDate dateFromDateTimeStringInUTC_8:s];
}

+ (NSNumber *) idInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    id idString = [dictionary objectForKey:key];
    if (![idString isKindOfClass:[NSString class]])
        return nil;
    NSInteger i = ((NSString *)idString).integerValue;
    if (i == 0)
        return nil;
    return [NSNumber numberWithInteger:i];
}

+ (NSArray *) arrayInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key
{
    return [self getArray:[dictionary objectForKey:key]];
}

+ (NSArray *) getArray:(id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    }
    else if (object == nil) {
        return [NSArray array];
    }
    else {
        return [NSArray arrayWithObject:object];
    }
}


@end
