//
//  MessagesThreadViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface MessagesThreadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *activeField;

@property NSString *toUser;
@property NSString *convoID;
@property NSString *jobName;

@property NSMutableArray *data;
@property NSArray *sortedData;

@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
