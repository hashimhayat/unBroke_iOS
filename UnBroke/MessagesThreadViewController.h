//
//  MessagesThreadViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesThreadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy,nonatomic) NSArray *identifiers;
@property (copy,nonatomic) NSArray *defaultVal;
@property (copy,nonatomic) NSArray *profilePic;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *activeField;

@end
