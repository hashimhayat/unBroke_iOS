//
//  ThreadEntry.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ThreadEntry.h"

@implementation ThreadEntry

- (void)awakeFromNib {
    [super awakeFromNib];
    _image.layer.cornerRadius = 10;
    _image.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
