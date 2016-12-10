//
//  ReceiverEntry.m
//  UnBroke
//
//  Created by Shuaib Jewon on 12/5/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "ReceiverEntry.h"

extern NSInteger cornerRadius;

@implementation ReceiverEntry

- (void)awakeFromNib {
    [super awakeFromNib];
    _image.layer.cornerRadius = cornerRadius;
    _image.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
