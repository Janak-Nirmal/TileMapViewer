#import "TileOverlayView.h"
#import "AppleTileOverlay.h"

#define TILE_SIZE 256.0

@implementation TileOverlayView

@synthesize tileAlpha;

static NSInteger zoomScaleToZoomLevel(MKZoomScale scale) {
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0); // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}


- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    if (self = [super initWithOverlay:overlay]) {
        tileAlpha = 1.0; // 0.75 // base map alpha
    }
    return self;
}



- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale
{
    // Return YES only if there are some tiles in this mapRect and at this zoomScale.
    
    AppleTileOverlay *tileOverlay = (AppleTileOverlay *)self.overlay;
    NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];
    
    return [tilesInRect count] > 0;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context {
    
    //overzoom mode
    NSInteger z = zoomScaleToZoomLevel(zoomScale);
    NSInteger overZoom = 1;
    NSInteger zoomCap = 15;
    
    if (z > zoomCap) {
        overZoom = pow(2, (z-zoomCap));
    }
    
    AppleTileOverlay *tileOverlay = (AppleTileOverlay *)self.overlay;
    
    // Get the list of tile images from the model object for this mapRect. The
    // list may be 1 or more images (but not 0 because canDrawMapRect would have
    // returned NO in that case).
    NSArray *tilesInRect = [tileOverlay tilesInMapRect:mapRect zoomScale:zoomScale];
    
    CGContextSetAlpha(context, tileAlpha);
    
    for (ImageTile *tile in tilesInRect) {
        // For each image tile, draw it in its corresponding MKMapRect frame
        CGRect rect = [self rectForMapRect:tile.frame];
        
        NSString *path = tile.imagePath;
        if (path) {
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
            
            float scale = (overZoom/zoomScale);
            
            CGContextScaleCTM(context, scale, scale);
            CGContextTranslateCTM(context, 0, image.size.height);
            CGContextScaleCTM(context, 1, -1);
            CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
            CGContextRestoreGState(context);

        }
    }
}

@end