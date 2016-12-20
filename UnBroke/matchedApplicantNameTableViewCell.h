//
//  matchedApplicantNameTableViewCell.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/18/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface matchedApplicantNameTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *applicantName;
@property (strong, nonatomic) IBOutlet UIButton *contactBtn;
@property NSString *userID;

@end
