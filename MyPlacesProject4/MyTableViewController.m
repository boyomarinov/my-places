//
//  MyTableViewController.m
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTableViewController.h"
#import "AddressAnnotation.h"

@implementation MyTableViewController
@synthesize annotations, searchResults, searchedItem;
@synthesize annDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"List", @"List");
        self.tabBarItem.image = [UIImage imageNamed:@"places"];
        annotations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    //NCenter, which has to catch notification sended by the detail view
    //when a user wants to delete specific location
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removePlaceFromMyPlaces:) 
                                                 name:@"removePlace" 
                                               object:nil];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [annotations release], annotations = nil;
    [searchResults release], searchResults = nil;
    [searchedItem release], searchedItem = nil;
    [annDetails release], annDetails = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //reload source data in the table and if there was a search query present
    //return it automatically for the user in the TB
    [(UITableView*)self.view reloadData];
    if([self searchedItem]){
        [[[self searchDisplayController] searchBar] setText:[self searchedItem]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //cache searched query for the user
    [self setSearchedItem:[[[self searchDisplayController] searchBar] text]];
    [self setSearchResults:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //there is only one category
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    //depending on the table we're going to show return the proper count
    if(tableView == [[self searchDisplayController] searchResultsTableView]){
        numberOfRows = [[self searchResults] count];
    }else{
        numberOfRows = [[self annotations] count];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSInteger rowNum = [indexPath row];
    AddressAnnotation *contentOfRow = nil;
    
    //depending on the table we're going to show, set the current content
    if(tableView == [[self searchDisplayController] searchResultsTableView]){
        contentOfRow = (AddressAnnotation *)[[self searchResults] objectAtIndex:rowNum];
    }else{
        contentOfRow = (AddressAnnotation *)[[self annotations] objectAtIndex:rowNum];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = contentOfRow.title;
    
    return cell;
}

-(NSMutableArray *)getArray{
    return self.annotations;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self searchForItem:searchString];
    
    return YES;
}

-(void)searchForItem:(NSString *)item{
    [self setSearchedItem:item];
    if([self searchResults] == nil){
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        [self setSearchResults:temp];
        [temp release];
    }
    [[self searchResults] removeAllObjects];
    
    if([[self searchedItem] length] != 0){
        for(AddressAnnotation *current in ([self annotations])){
            if(([[current title] rangeOfString:searchedItem options:NSCaseInsensitiveSearch].location != NSNotFound) ||
               ([[current subtitle] rangeOfString:searchedItem options:NSCaseInsensitiveSearch].location != NSNotFound)){
                [[self searchResults] addObject:current];
            }
        }
    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [self setSearchedItem:nil];
    [(UITableView*)self.view reloadData];
}

//notification handler for place removal, sended from DetailPlaceViewController
-(void)removePlaceFromMyPlaces:(NSNotification *)notification{
    //NSLog(@"Handling remove place notification.");
    DetailPlaceViewController *temp = [notification object];
    [self.annotations removeObject: temp.ann];
    [(UITableView*)self.view reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressAnnotation *contentOfRow = nil;
    if(annDetails == nil){
        //NSLog(@"annDetails is nil");
        DetailPlaceViewController *temp = [[DetailPlaceViewController alloc] initWithNibName:@"DetailPlaceViewController" bundle:nil];
        self.annDetails = temp;
        [temp release];
    }
    
    //vajno e da posochim indeksite v syotvetstvie s tablicata, inache niama
    //da se zarejda pravilnoto detailno view za dadeno miasto
    if(tableView == [[self searchDisplayController] searchResultsTableView]){
        contentOfRow = [[self searchResults] objectAtIndex:indexPath.row];
    }else{
        contentOfRow = [[self annotations] objectAtIndex:indexPath.row];
    }
    // Pass the selected object to the new view controller.
    self.annDetails.ann = contentOfRow;
    //slagame primerna snimka, dokato potrebitelq ne zadade svoq
    self.annDetails.ann.photo = @"sample.jpg";
    [self.annDetails setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:annDetails animated:YES];
}

@end
