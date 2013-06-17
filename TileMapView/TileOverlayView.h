#import <MapKit/MapKit.h>
#import "AppleTileOverlay.h"


@interface TileOverlayView : MKOverlayView {
    CGFloat tileAlpha;
}

@property (nonatomic, assign) CGFloat tileAlpha;
@end