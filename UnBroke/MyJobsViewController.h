//
//  MyJobsViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//
#import <UIKit/UIKit.h>

@import Firebase;

@interface MyJobsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *originalData;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
