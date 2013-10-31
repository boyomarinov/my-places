//
//  MyTableViewController.h
//  MyPlacesProject4
//
//  Created by Snow Leopard User on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailPlaceViewController.h"

@interface MyTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>{

    NSMutableArray *annotations;
    NSMutableArray *searchResults;
    NSString *searchedItem;
    DetailPlaceViewController *annDetails;    
}
-(NSMutableArray *)getArray;
-(void)removePlaceFromMyPlaces:(NSNotification *)notification;
-(void)searchForItem:(NSString *)item;

@property(readonly, nonatomic) NSMutableArray *annotations;
@property(nonatomic, retain) NSMutableArray *searchResults;
@property(nonatomic, copy) NSString *searchedItem;
@property(nonatomic, retain) DetailPlaceViewController *annDetails;

@end
