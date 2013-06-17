#import <MapKit/MapKit.h>

@interface ImageTile : NSObject {
    NSString *imagePath;
    MKMapRect frame;
}

@property (nonatomic, readonly) MKMapRect frame;
@property (nonatomic, readonly) NSString *imagePath;

@end

@interface AppleTileOverlay : NSObject <MKOverlay> {
    MKMapRect boundingMapRect;
    NSSet *tilePaths;
}

- (id)initOverlay;

// Return an array of ImageTile objects for the given MKMapRect and MKZoomScale
- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale;

@end