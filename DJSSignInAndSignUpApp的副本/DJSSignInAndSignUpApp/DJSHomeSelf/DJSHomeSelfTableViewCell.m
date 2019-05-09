//
//  DJSHomeSelfTableViewCell.m
//  DJSSignInAndSignUpApp
//
//  Created by 萨缪 on 2019/4/22.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSHomeSelfTableViewCell.h"
#import <Masonry.h>
@implementation DJSHomeSelfTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.cuteCellImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.cuteCellImageView];
        [self setUIFrame];
    }
    return self;
}

- (void)setUIFrame
{
    [self.cuteCellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    self.nameLabel.font = [UIFont systemFontOfSize:20];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cuteCellImageView.mas_right).offset(80);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(250);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
