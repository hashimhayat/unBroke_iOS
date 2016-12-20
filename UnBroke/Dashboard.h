//
//  Dashboard.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/6/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface Dashboard : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *postingsTbl;
@property (strong, nonatomic) IBOutlet UITableView *updatesTbl;

@property NSMutableArray *jobs;
@property NSMutableArray *updates;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property BOOL showPosting;
@property BOOL showNotifications;

@end
