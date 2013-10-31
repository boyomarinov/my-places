//
//  AddPlaceViewController.h
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPlaceViewController : UIViewController{
     IBOutlet UITextField *titleText;
}

-(IBAction)addPlaceInfo:(id)sender;

@property(nonatomic, retain)IBOutlet UITextField *titleText;

@end
