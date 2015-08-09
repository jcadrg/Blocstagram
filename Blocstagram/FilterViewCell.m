//
//  FilterViewCell.m
//  Blocstagram
//
//  Created by Mac on 8/8/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "FilterViewCell.h"

@interface FilterViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *filterLabel;

@end

@implementation FilterViewCell

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.filterLabel =[[UILabel alloc] init];
        
        self.backgroundColor = [UIColor whiteColor];
        self.imageView.backgroundColor = [UIColor whiteColor];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.filterLabel.textAlignment = NSTextAlignmentCenter;
        self.filterLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.filterLabel];
        
    }
    
    return self;
    
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    
    self.imageView.frame = CGRectMake(0, 0, width, width);
    self.filterLabel.frame = CGRectMake(0, width, width, 20);
    
}

-(void) setFilterImage:(UIImage *)filterImage{
    _filterImage = filterImage;
    self.imageView.image = filterImage;
}

-(void) setFilterTitle:(NSString *)filterTitle{
    _filterTitle = filterTitle;
    self.filterLabel.text = filterTitle;
}

@end
