#import "AnyBackdropView.h"
#import "../helpers/private_headers/CAFilter.h"

@implementation AnyBackdropView

+ (Class)layerClass {
    return [NSClassFromString(@"CABackdropLayer") class];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self _updateFilters];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self _updateFilters];
    return self;
}

- (void)_updateFilters {
    // code from Lessica/TrollSpeed
    CAFilter *blurFilter = [CAFilter filterWithName:kCAFilterGaussianBlur];
    [blurFilter setValue:@(50.0) forKey:@"inputRadius"];  // radius 50pt
    [blurFilter setValue:@YES forKey:@"inputNormalizeEdges"];  // do not use inputHardEdges

    CAFilter *brightnessFilter = [CAFilter filterWithName:kCAFilterColorBrightness];
    [brightnessFilter setValue:@(-0.285) forKey:@"inputAmount"];  // -28.5%

    CAFilter *contrastFilter = [CAFilter filterWithName:kCAFilterColorContrast];
    [contrastFilter setValue:@(1000.0) forKey:@"inputAmount"];   // 1000x

    CAFilter *saturateFilter = [CAFilter filterWithName:kCAFilterColorSaturate];
    [saturateFilter setValue:@(0.0) forKey:@"inputAmount"];

    CAFilter *colorInvertFilter = [CAFilter filterWithName:kCAFilterColorInvert];

    [self.layer setFilters:@[
        blurFilter, brightnessFilter, contrastFilter,
        saturateFilter, colorInvertFilter,
    ]];
}

@end