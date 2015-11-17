//
//  TableViewCell.m
//  TestApp
//
//  Created by Thangavel on 11/12/15.

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.lbl_title = [[UILabel alloc] init];
        self.lbl_title.tag = 1;
        self.lbl_title.font = [UIFont systemFontOfSize:14.0];
        self.lbl_title.textAlignment = NSTextAlignmentLeft;
        self.lbl_title.textColor = [UIColor colorWithRed:56.0/255.0 green:57.0/255.0 blue:186.0/255.0 alpha:1.0];
        //self.lbl_title.autoresizingMask =UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth ;
        self.lbl_title.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.lbl_title];
        
        self.lbl_desc = [[UILabel alloc] init];
        self.lbl_desc.tag = 2;
        self.lbl_desc.font = [UIFont systemFontOfSize:12.0];
        self.lbl_desc.textAlignment = NSTextAlignmentLeft;
        self.lbl_desc.textColor = [UIColor darkGrayColor];
        self.lbl_desc.numberOfLines=0;
        self.lbl_desc.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:self.lbl_desc];
        
        
        self.img_icon = [[UIImageView alloc] init];
        self.img_icon.tag = 3;
        [self.contentView addSubview:self.img_icon];
        self.contentView.backgroundColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
        self.backgroundColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    }
    return self;
}

@end
