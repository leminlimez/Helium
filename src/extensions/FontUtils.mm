#import "FontUtils.h"

static NSMutableArray *_allFontNames = [NSMutableArray array];

@implementation FontUtils

+ (void)loadFontsFromFolder:(NSString *)fontFolder {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:fontFolder error:NULL];
    
    for (NSString *filename in contents) {
        if ([filename.pathExtension isEqualToString:@"ttf"] || [filename.pathExtension isEqualToString:@"otf"]) {
            NSString *fontPath = [fontFolder stringByAppendingPathComponent:filename];
            
            NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
            CFErrorRef error;
            CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)fontData);
            CGFontRef font = CGFontCreateWithDataProvider(provider);
            
            if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                CFStringRef errorDescription = CFErrorCopyDescription(error);
                NSLog(@"Failed to load font: %@", errorDescription);
                CFRelease(errorDescription);
            }
            // CFStringRef fontNameRef = CGFontCopyPostScriptName(font);
            // NSString *fontName = (__bridge NSString*)fontNameRef;
            // CFRelease(fontNameRef);
            // [_allFontNames addObject:fontName];
            // NSLog(@"fontName: %@",fontName);
        
            CFRelease(font);
            CFRelease(provider);
        }
    }
}

+ (void) loadAllFonts {    
    NSArray *familyNames = [UIFont familyNames];
    // for (NSString *familyName in familyNames) {
    //     NSArray *names = [UIFont fontNamesForFamilyName:familyName];
    //     [_allFontNames addObjectsFromArray:names];
    // }
    [_allFontNames addObjectsFromArray:familyNames];
    // CFArrayRef allFonts = CTFontManagerCopyAvailableFontFamilyNames();
    // for (NSInteger i = 0; i < CFArrayGetCount(allFonts); i++) {
    //     NSString *fontName = (__bridge NSString *)CFArrayGetValueAtIndex(allFonts, i);
    //     [_allFontNames addObject:fontName];
    // }
    // CFRelease(allFonts);
}

+ (NSArray<NSString *> *)allFontNames {
    NSMutableArray *copyArray = [[NSMutableArray alloc] init];
    copyArray = [_allFontNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)].mutableCopy;
    [copyArray insertObject:@"System Font" atIndex:0];
    return copyArray;
}

+ (UIFont*)loadFontWithName:(NSString*)fontName size:(float)size bold:(BOOL) bold italic:(BOOL) italic{
    UIFont *font = [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:fontName size:size] size:size];
    if ([fontName isEqualToString:@"System Font"]) {
        font = [UIFont systemFontOfSize: size];
    }
    UIFontDescriptorSymbolicTraits symbolicTraits = 0;
    if (bold) {
        symbolicTraits |= UIFontDescriptorTraitBold;
    }
    if (italic) {
        symbolicTraits |= UIFontDescriptorTraitItalic;
    }
    UIFont *specialFont = [UIFont fontWithDescriptor:[[font fontDescriptor] fontDescriptorWithSymbolicTraits:symbolicTraits] size:size];
    return specialFont;
}
@end