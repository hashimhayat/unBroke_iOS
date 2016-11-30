//
//  MessagesViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 11/29/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy,nonatomic) NSArray *identifiers;
@property (copy,nonatomic) NSArray *defaultVal;
@property (copy,nonatomic) NSArray *profilePic;

@end
