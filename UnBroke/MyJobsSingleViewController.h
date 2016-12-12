//
//  MyJobsSingleViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface MyJobsSingleViewController : UIViewController

@property (strong, nonatomic) UITextField *activeField;
@property (strong,nonatomic) NSMutableArray *jobData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *job;
@property (nonatomic, strong) NSMutableArray *jobApplicants;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
