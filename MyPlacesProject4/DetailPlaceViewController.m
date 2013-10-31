//
//  DetailPlaceViewController.m
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailPlaceViewController.h"

@implementation DetailPlaceViewController

@synthesize ann;// = _ann;
@synthesize photoView, photoSource, nameLabel, subtitleLabel;
@synthesize latitudeLabel, longitudeLabel, commentsField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"oldmap"]];
    self.view.backgroundColor = background;
    [background release];
    
    nameLabel.text = ann.title;
    subtitleLabel.text = ann.subtitle;
    NSString* latitude = [[NSNumber numberWithDouble: ann.coordinate.latitude] stringValue];
    NSString* longitude = [[NSNumber numberWithDouble: ann.coordinate.longitude] stringValue];
    latitudeLabel.text = latitude;
    longitudeLabel.text = longitude;
    commentsField.text = ann.comment;
    
    UIImage *placesImage = [UIImage imageNamed: ann.photo];
    photoView = [[UIImageView alloc] initWithImage: placesImage];
    [photoView release];
    photoSource.selectedSegmentIndex = -1;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [photoView release];
    photoView = nil;
    [nameLabel release];
    nameLabel = nil;
    [subtitleLabel release];
    subtitleLabel = nil;
    [latitudeLabel release];
    latitudeLabel = nil;
    [longitudeLabel release];
    longitudeLabel = nil;
    [deleteButton release];
    deleteButton = nil;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"ViewDidLoad with: %@", nameLabel.text);
    nameLabel.text = ann.title;
    subtitleLabel.text = ann.subtitle;
    NSString* latitude = [[NSNumber numberWithDouble: ann.coordinate.latitude] stringValue];
    NSString* longitude = [[NSNumber numberWithDouble: ann.coordinate.longitude] stringValue];
    latitudeLabel.text = latitude;
    longitudeLabel.text = longitude;
    commentsField.text = ann.comment;
    
    UIImage *placesImage = [UIImage imageNamed: ann.photo];
    photoView = [[UIImageView alloc] initWithImage: placesImage];
    [photoView release];
    photoSource.selectedSegmentIndex = -1;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [photoView release];
    [nameLabel release];
    [subtitleLabel release];
    [latitudeLabel release];
    [longitudeLabel release];
    [deleteButton release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

//required UIImagePickerController methods' implementation
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageFromCamera = [info objectForKey:UIImagePickerControllerOriginalImage];
    [photoView setImage:imageFromCamera];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];	
}

//handler for the alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"AlertView");
    if(buttonIndex == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removePlace" object:self];
        [self dismissModalViewControllerAnimated:YES];
    }
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    if([title isEqualToString:@"Yes"]){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"removePlace" object:self];
//        [self dismissModalViewControllerAnimated:YES];
//    }
//    else if([title isEqualToString:@"No"]){
//        return;
//    }
}

//segmentControl handler for adding a photo
-(IBAction)addPhoto:(id)sender{
    picpicker = [[UIImagePickerController alloc] init];
    picpicker.delegate = self;
    if(photoSource.selectedSegmentIndex == 0){
        [picpicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else if(photoSource.selectedSegmentIndex == 1){
        [picpicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [self presentModalViewController:picpicker animated:YES];
    [picpicker release];
}

-(IBAction)saveCommentforPlace:(id)sender{
    ann.comment = commentsField.text;
    [self.commentsField resignFirstResponder];
}

-(IBAction)closeAnnotationDetails:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}	

//alert user for place removal and then action is handled by the delegate
-(IBAction)removePlaceFromAnnotations:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Delete Place" 
                          message: @"Are you sure you want to permanently delete this place?" 
                          delegate:self
                          cancelButtonTitle:@"Yes" 
                          otherButtonTitles:@"No", nil];
    [alert show];
    [alert release];
}


@end
