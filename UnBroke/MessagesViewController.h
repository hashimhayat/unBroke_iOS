//
//  MessagesViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface MessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSString *applicantID;
@property NSString *toUser;
@property NSString *convoID;
@property NSString *jobName;
@property NSMutableArray *data;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
