//
//  DetailPlaceViewController.h
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressAnnotation.h"

@interface DetailPlaceViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
    
    UIImagePickerController *picpicker;
    IBOutlet UISegmentedControl *photoSource;
    IBOutlet UIImageView *photoView;
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *longitudeLabel;
    IBOutlet UITextView *commentsField;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *saveComment;
    IBOutlet UIButton *deleteButton;
    
}

-(IBAction)addPhoto:(id)sender;
-(IBAction)closeAnnotationDetails:(id)sender;
-(IBAction)saveCommentforPlace:(id)sender;
-(IBAction)removePlaceFromAnnotations:(id)sender;

@property(nonatomic, retain)AddressAnnotation *ann;

@property(nonatomic, retain)IBOutlet UISegmentedControl *photoSource;
@property(nonatomic, retain)IBOutlet UIImageView *photoView;
@property(nonatomic, retain)IBOutlet UILabel *nameLabel;
@property(nonatomic, retain)IBOutlet UILabel *subtitleLabel;
@property(nonatomic, retain)IBOutlet UILabel *latitudeLabel;
@property(nonatomic, retain)IBOutlet UILabel *longitudeLabel;
@property(nonatomic, retain)IBOutlet UITextView *commentsField;

@end
