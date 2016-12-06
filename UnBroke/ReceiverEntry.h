//
//  ReceiverEntry.h
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverEntry : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *receiver;
@property (strong, nonatomic) IBOutlet UITextView *message;

@end
