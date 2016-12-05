//
//  JobEntry.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/4/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobEntry : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *jobTitle;
@property (strong, nonatomic) IBOutlet UILabel *salary;
@property (strong, nonatomic) IBOutlet UILabel *distance;

@end
