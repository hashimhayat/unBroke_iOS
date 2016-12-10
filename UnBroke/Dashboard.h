//
//  Dashboard.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/6/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dashboard : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *notificationsTbl;
@property (strong, nonatomic) IBOutlet UITableView *postingsTbl;
@property (strong, nonatomic) IBOutlet UITableView *updatesTbl;

@property BOOL showNotifications;
@property BOOL showPostings;
@property BOOL showUpdates;

@end
