#import "AnyBackdropView.h"

@implementation AnyBackdropView
+ (Class)layerClass {
    return [NSClassFromString(@"CABackdropLayer") class];
}
@end