//
//  FirstViewController.h
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

#import "AddPlaceViewController.h"

@interface FirstViewController : UIViewController<MKMapViewDelegate>{
    NSMutableArray *annotationsOnMap;
    IBOutlet MKMapView *mapView;
    AddPlaceViewController *details;
    CLLocationCoordinate2D newPinCoordinates;
}

-(void)zoomToFitMapAnnotations:(MKMapView *)_mapView;
-(void)addAnnotationToMap:(NSNotification *)notification;
-(void)handleLongPressMap:(UILongPressGestureRecognizer* )sender;

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, assign) CLLocationCoordinate2D newPinCoordinates;

@end
