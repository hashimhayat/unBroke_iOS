//
//  ApplicantNameTableViewCell.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/12/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicantNameTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *applicantName;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;

@property NSString *userID;

@end
