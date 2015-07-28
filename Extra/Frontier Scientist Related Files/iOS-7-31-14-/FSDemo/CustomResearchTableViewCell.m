//
//  CustomResearchTableViewCell.m
//  FSDemo
//
//  Created by alandrews3 on 5/15/14.
//  Copyright (c) 2014 Andrew Clark. All rights reserved.
//

#import "CustomResearchTableViewCell.h"

@implementation CustomResearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
