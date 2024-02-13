#import <Foundation/Foundation.h>
#import <Foundation/NSBundle.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface FontUtils : NSObject

+ (void) loadFontsFromFolder:(NSString *)fontFolder;
+ (void) loadAllFonts;
+ (NSArray<NSString *> *) allFontNames;
+ (UIFont*) loadFontWithName:(NSString*)fontName size:(float)size bold:(BOOL) bold italic:(BOOL) italic;
@end