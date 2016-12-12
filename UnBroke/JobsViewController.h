//
//  JobsViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface JobsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *originalData;

@property NSString *filterCategory;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
