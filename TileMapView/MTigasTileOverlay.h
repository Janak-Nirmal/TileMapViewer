#import <MapKit/MapKit.h>


@protocol MTigasTileOverlay <MKOverlay>

@property (nonatomic) CGFloat defaultAlpha;
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale;

@end
