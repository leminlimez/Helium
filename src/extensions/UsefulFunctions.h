//
//  UsefulFunctions.h
//  
//
//  Created by lemin on 12/8/23.
//

BOOL getBoolFromDictKey(NSDictionary *dict, NSString *key, BOOL defaultValue);
BOOL getBoolFromDictKey(NSDictionary *dict, NSString *key);

NSInteger getIntFromDictKey(NSDictionary *dict, NSString *key, NSInteger defaultValue);
NSInteger getIntFromDictKey(NSDictionary *dict, NSString *key);

double getDoubleFromDictKey(NSDictionary *dict, NSString *key, double defaultValue);
double getDoubleFromDictKey(NSDictionary *dict, NSString *key);