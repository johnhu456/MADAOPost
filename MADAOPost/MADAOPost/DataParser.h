//
//  DataParser.h
//  Shire
//
//  Created by ZhSnow on 11/16/15.
//  Copyright © 2015 LLJZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

+ (NSDictionary *)dictionaryInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSString *)stringInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSNumber *)numberInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSNumber *)numberCanbeNilInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSNumber *)floatNumberInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSNumber *)doubleNumberInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSNumber *)booleanInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

//+ (NSDate *)dateInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSNumber *)idInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSArray *)arrayInDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (NSArray *)getArray:(id)object;

@end
