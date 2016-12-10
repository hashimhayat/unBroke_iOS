//
//  titleTableViewCell.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/7/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "titleTableViewCell.h"


@implementation titleTableViewCell

@synthesize imageView = _imageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.layer.cornerRadius = 5;
    _imageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
