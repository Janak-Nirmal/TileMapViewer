//
//  TileMapViewViewController.h
//  TileMapView
//
//  Created by Ryan Linn on 6/17/13.
//  Copyright (c) 2013 Guthook Hikes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TileOverlayView.h"
#import "AppleTileOverlay.h"

#import "OSMTileOverlay.h"
#import "CustomOverlayView.h"

@interface TileMapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *mapTypeLabel;
@property int mapType;

-(IBAction)toggleMapButtonPressed:(id)sender;

@end
