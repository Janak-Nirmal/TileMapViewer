#import "AppleTileOverlay.h"

#define TILE_SIZE 256.0

@interface ImageTile (FileInternal)
- (id)initWithFrame:(MKMapRect)f path:(NSString *)p;
@end

@implementation ImageTile

@synthesize frame, imagePath;

- (id)initWithFrame:(MKMapRect)f path:(NSString *)p
{
    if (self = [super init]) {
        imagePath = p;
        frame = f;
    }
    return self;
}


@end

// Convert an MKZoomScale to a zoom level where level 0 contains 4 256px square tiles,
// which is the convention used by gdal2tiles.py.
static NSInteger zoomScaleToZoomLevel(MKZoomScale scale) {
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0); // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

@implementation AppleTileOverlay

-(NSString *)pathForTileAtX: (int)x andY:(int)y andZ:(int) z {
    NSString *tileKey = [[NSString alloc] initWithFormat:@"%d%d%d", x, y, z];
    NSString *tilePath = [[NSBundle mainBundle] pathForResource:tileKey ofType:nil inDirectory:@"CamdenHillsTiles"];
    return tilePath;
}

- (id)initOverlay
{
    if (self = [super init]) {
        boundingMapRect = MKMapRectMake(-180, -90, MKMapSizeWorld.width, MKMapSizeWorld.height);
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(boundingMapRect),
                                                  MKMapRectGetMidY(boundingMapRect)));
}

- (MKMapRect)boundingMapRect
{
    return boundingMapRect;
}


- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale
{
    NSInteger z = zoomScaleToZoomLevel(scale);
    
    //////////////////
    //Overzoom Code///
    //////////////////
    NSInteger overzoom = 1;
    NSInteger zoomCap = 15;
    
    if (z > zoomCap) {
        //overZoom progression: 1, 2, 4, 8, etc.
        overzoom = pow(2, (z-zoomCap));
        z = zoomCap;
    }
    
    //When zoomed beyond tile set, use the tiles from maximum z-depth, but render them larger
    NSInteger adjustedTileSize = overzoom * TILE_SIZE;
    
    
    NSInteger minX = floor((MKMapRectGetMinX(rect) * scale) / adjustedTileSize);
    NSInteger maxX = floor((MKMapRectGetMaxX(rect) * scale) / adjustedTileSize);
    NSInteger minY = floor((MKMapRectGetMinY(rect) * scale) / adjustedTileSize);
    NSInteger maxY = floor((MKMapRectGetMaxY(rect) * scale) / adjustedTileSize);
    NSMutableArray *tiles = nil;
    
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            
            
            NSString *tilePath = [self pathForTileAtX:x andY:y andZ:z];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:tilePath]) {
                if (!tiles) {
                    tiles = [NSMutableArray array];
                }
                
                MKMapRect frame = MKMapRectMake((double)(x * adjustedTileSize) / scale,
                                                (double)(y * adjustedTileSize) / scale,
                                                adjustedTileSize / scale,
                                                adjustedTileSize / scale);
                
                if (MKMapRectIntersectsRect(rect, frame)) {
                    ImageTile *tile = [[ImageTile alloc] initWithFrame:frame path:tilePath];
                    [tiles addObject:tile];
                }

            }
        }
    }
    return tiles;
}

@end