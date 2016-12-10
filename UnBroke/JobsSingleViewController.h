//
//  JobsSingleViewController.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsSingleViewController : UIViewController

@property (strong, nonatomic) UITextField *activeField;
@property (strong,nonatomic) NSMutableArray *jobData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
