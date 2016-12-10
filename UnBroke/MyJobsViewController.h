//
//  MyJobsViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MyJobsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *data;

@end
