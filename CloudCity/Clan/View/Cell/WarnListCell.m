//
//  WarnListCell.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 18/07/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "WarnListCell.h"
#import "UIButton+WebCache.h"

@implementation WarnListCell

- (void)awakeFromNib
{
    _lbl_name.font = [UIFont fontWithSize:15.f];
    _lbl_name.textColor = K_COLOR_DARK;
    _lbl_content.font = [UIFont fontWithSize:12.f];
    _lbl_content.textColor = K_COLOR_DARK_Cell;
    [self.lbl_content setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.lbl_content setNumberOfLines:0];
    [self.lbl_content setTextAlignment:NSTextAlignmentLeft];
    self.lbl_content.preferredMaxLayoutWidth = kSCREEN_WIDTH-15-15-45-30;
    self.btn_avatar.layer.cornerRadius = 45/2;
    self.btn_avatar.layer.borderColor = kCOLOR_BORDER.CGColor;
    self.btn_avatar.layer.borderWidth = 0.5;
    self.btn_avatar.contentMode = UIViewContentModeScaleAspectFit;
    self.btn_avatar.clipsToBounds = YES;
    self.iv_line.image = [Util imageWithColor:K_COLOR_MOST_LIGHT_GRAY];
    
    self.backgroundColor = kCLEARCOLOR;
    self.contentView.backgroundColor = kCLEARCOLOR;
    self.iv_newmess = [[UIImageView alloc]initWithImage:[Util imageWithColor:[UIColor redColor]]];
    
    [self.contentView addSubview:self.iv_newmess];
    _iv_newmess.hidden = YES;
    
    self.iv_newmess.layer.masksToBounds = YES;
    self.iv_newmess.layer.cornerRadius = 4.0;
    _iv_newmess.backgroundColor = [UIColor whiteColor];
    [_iv_newmess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_btn_avatar.mas_trailing).offset(-3);
        make.top.equalTo(_btn_avatar.mas_top).offset(2);
        make.width.equalTo(@8);
        make.height.equalTo(@8);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setWarn:(NotificationModel *)warn
{
    _warn = warn;
    _lbl_content.text = _warn.content;
    self.lbl_content.preferredMaxLayoutWidth = kSCREEN_WIDTH-15-15-45-30;
    _lbl_name.text = _warn.author;
    [_btn_avatar sd_setImageWithURL:[NSURL URLWithString:_warn.msgtoid_avatar] forState:UIControlStateNormal placeholderImage:kIMG(@"portrait")];
    _iv_newmess.hidden = (_warn.is_have_read && [_warn.is_have_read intValue]==1) ? YES : NO;
}

@end
