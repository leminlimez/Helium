//
//  UsefulFunctions.mm
//  
//
//  Created by lemin on 12/8/23.
//

#import <Foundation/Foundation.h>
#import "UsefulFunctions.h"

// MARK: Dictionary Value Functions
// Bools
BOOL getBoolFromDictKey(NSDictionary *dict, NSString *key, BOOL defaultValue)
{
    return [dict valueForKey:key] ? [[dict valueForKey:key] boolValue] : defaultValue;
}
BOOL getBoolFromDictKey(NSDictionary *dict, NSString *key)
{
    return getBoolFromDictKey(dict, key, NO);
}

// Ints
NSInteger getIntFromDictKey(NSDictionary *dict, NSString *key, NSInteger defaultValue)
{
    return [dict valueForKey:key] ? [[dict valueForKey:key] integerValue] : defaultValue;
}

NSInteger getIntFromDictKey(NSDictionary *dict, NSString *key)
{
    return getIntFromDictKey(dict, key, 0);
}

// Doubles
double getDoubleFromDictKey(NSDictionary *dict, NSString *key, double defaultValue)
{
    return [dict valueForKey:key] ? [[dict valueForKey:key] doubleValue] : defaultValue;
}

double getDoubleFromDictKey(NSDictionary *dict, NSString *key)
{
    return getDoubleFromDictKey(dict, key, 0.0);
}