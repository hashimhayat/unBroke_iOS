//
//  ProfileViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/30/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Firebase;

@interface ProfileViewController :UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy,nonatomic) NSArray *identifiers;
@property (copy,nonatomic) NSArray *defaultVal;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSDictionary *userData;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end
