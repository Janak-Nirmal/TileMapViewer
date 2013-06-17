#import <MapKit/MapKit.h>
#import "MTigasTileOverlay.h"

/**
 * Tile layer that uses tiles from the OpenStreetMap project.
 */
@interface OSMTileOverlay : NSObject <MTigasTileOverlay> {
    CGFloat defaultAlpha;
}
@end
