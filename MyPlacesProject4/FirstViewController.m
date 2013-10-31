//
//  FirstViewController.m
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "AddressAnnotation.h"
#import "AddPlaceViewController.h"
#import "MyTableViewController.h"

@implementation FirstViewController

@synthesize mapView, newPinCoordinates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Map", @"Map");
        self.tabBarItem.image = [UIImage imageNamed:@"compass"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //notification center, which caches the notification from AddPlaceViewController
    //in order to init the specific newPin with its name
    annotationsOnMap = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(addAnnotationToMap:) 
                                                 name:@"didFinishAnnotationInput" 
                                               object:nil];
    
    //GestureRecognizer for adding new place to the map
    UILongPressGestureRecognizer *pressedMap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressMap:)];
    [self.mapView addGestureRecognizer: pressedMap];
    [pressedMap release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [annotationsOnMap release];
    annotationsOnMap = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [annotationsOnMap addObjectsFromArray:[[self.tabBarController.viewControllers objectAtIndex:1] getArray]];
    [self.mapView addAnnotations:annotationsOnMap];
    [self zoomToFitMapAnnotations:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    [self.mapView removeAnnotations:annotationsOnMap];
    [annotationsOnMap removeAllObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//tuk pravim customizacia na izgleda na otdelno mqsto vyrhu kartata
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString* annotationID = @"AnnotationIdentifier";
    MKPinAnnotationView* pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationID] autorelease];
    pinView.animatesDrop = TRUE;
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorGreen;
    
    //UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[rightButton setTitle:annotation.title forState:UIControlStateNormal];
    //[rightButton addTarget:self 
    //                action:@selector(showDetails:)
    //      forControlEvents:UIControlEventTouchUpInside];
    //pinView.rightCalloutAccessoryView = rightButton;
    
    UIImageView *left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    pinView.leftCalloutAccessoryView = left;
    [left release];
    
    return pinView;
}

//tries to set the proper zoom level for the map in order
//to display all added places
- (void)zoomToFitMapAnnotations:(MKMapView *)_mapView {  
    if (([_mapView.annotations count] == 0) ||
        ([_mapView.annotations count] == 1) ||
        ([_mapView.annotations count] == 2)){
        return;
    }
    CLLocationCoordinate2D topLeftCoord;  
    topLeftCoord.latitude = -90;  
    topLeftCoord.longitude = 180;  
    
    CLLocationCoordinate2D bottomRightCoord;  
    bottomRightCoord.latitude = 90;  
    bottomRightCoord.longitude = -180;  
    
    for(AddressAnnotation *an in _mapView.annotations) {  
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, an.coordinate.longitude);  
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, an.coordinate.latitude);  
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, an.coordinate.longitude);  
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, an.coordinate.latitude);  
    }  
    
    MKCoordinateRegion region;  
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;  
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    // Add a little extra space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;  
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;  
    
    region = [_mapView regionThatFits:region];  
    [_mapView setRegion:region animated:YES];  
} 

//handler for the notification sent from AddPlaceViewController
-(void)addAnnotationToMap:(NSNotification *)notification{
    
    AddPlaceViewController *temp = [notification object];
    //NSLog(@"addAnnotationToMap: %@", temp.titleText.text);
    AddressAnnotation *newPin = [[AddressAnnotation alloc] init];
    newPin.coordinate = newPinCoordinates;
    
    NSDate *tempDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    newPin.subtitle = [dateFormat stringFromDate:tempDate];
    [dateFormat release];
    
    newPin.title = temp.titleText.text;
    [((MyTableViewController *)[self.tabBarController.viewControllers objectAtIndex:1]).annotations addObject:newPin];
    [annotationsOnMap addObject:newPin];
    [self.mapView addAnnotation:newPin];
    [self zoomToFitMapAnnotations:self.mapView];
    [newPin release];
}

-(void)handleLongPressMap:(UILongPressGestureRecognizer* )sender{
    //in order to prevent unwanter pins on the map if user moves his finger
    if(sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateChanged){
        //[self.mapView removeGestureRecognizer:sender];
    }else{
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D pointCoordinates = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];	
        newPinCoordinates = pointCoordinates;
        
        //display the view for new place addition
        AddPlaceViewController *popup = [[AddPlaceViewController alloc] init];
        [popup setModalTransitionStyle:UIModalTransitionStylePartialCurl]; 
        [self presentModalViewController:popup animated:YES];
        [popup release];
    }
}


@end
