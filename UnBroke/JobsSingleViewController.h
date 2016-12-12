//
//  JobsSingleViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface JobsSingleViewController : UIViewController

@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property BOOL applied;
@property (nonatomic, strong) NSDictionary *job;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
