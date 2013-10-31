//
//  AddressAnnotation.m
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 27/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize photo, comment;

-(id)initWithCoordinate:(CLLocationCoordinate2D ) c{
    if(self = [super init]){
        coordinate = c;
    }
    return self;
}


@end
