//
//  ProfileEditTableViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface ProfileEditTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy,nonatomic) NSArray *identifiers;
@property (copy,nonatomic) NSArray *defaultVal;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBtn;

@property NSDictionary *userData;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
