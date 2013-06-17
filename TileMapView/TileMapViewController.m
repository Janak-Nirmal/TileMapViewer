//
//  TileMapViewViewController.m
//  TileMapView
//
//  Created by Ryan Linn on 6/17/13.
//  Copyright (c) 2013 Guthook Hikes. All rights reserved.
//

#import "TileMapViewController.h"

@interface TileMapViewController ()

@end

@implementation TileMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self toggleMapType];
     
    //setting map region to Mt Megunticook, Camden, ME
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(44.25056, -69.08278);
    [self.mapView setRegion:MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.15, 0.15))];
}

-(void)toggleMapType {
    NSArray *overlays = [self.mapView overlays];
    
    if (overlays.count == 0) {
        AppleTileOverlay *appleTilesOverlay = [[AppleTileOverlay alloc] initOverlay];
        [self.mapView addOverlay:appleTilesOverlay];
        self.mapTypeLabel.text = @"Apple Tiles Overlay";
        
    } else {
        //remove current overlay, add the other kind.
        [self.mapView removeOverlays:self.mapView.overlays];

        if ([overlays.lastObject isKindOfClass:[AppleTileOverlay class]]) {
            OSMTileOverlay *osmOverlay = [[OSMTileOverlay alloc] init];
            [self.mapView addOverlay:osmOverlay];
            self.mapTypeLabel.text = @"MTigas Overlay";

        } else if ([overlays.lastObject isKindOfClass:[OSMTileOverlay class]]) {
            self.mapTypeLabel.text = @"No Overlay";

        }
    }
}

-(void)toggleMapButtonPressed:(id)sender {
    [self toggleMapType];
}

#pragma mark - Map View Delegate Methods
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[AppleTileOverlay class]]) {
        TileOverlayView *overlayView = [[TileOverlayView alloc] initWithOverlay:overlay];
        overlayView.alpha = 1.0;
        NSLog(@"Apple overlay");
        return overlayView;
    } else if ([overlay isKindOfClass:[OSMTileOverlay class]]) {
        CustomOverlayView *overlayView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        NSLog(@"MTigas Overlay");
        return overlayView;
    }
    
    return nil;
}

@end
