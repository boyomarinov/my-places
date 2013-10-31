//
//  AddressAnnotation.h
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSString *photo;
    NSString *comment;
}

@property(nonatomic, assign)CLLocationCoordinate2D coordinate;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subtitle;
@property(nonatomic, retain)NSString *photo;
@property(nonatomic, retain)NSString *comment;

@end
