//
//  FilterViewCell.h
//  Blocstagram
//
//  Created by Mac on 8/8/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewCell;

@interface FilterViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *filterImage;
@property (nonatomic, strong) NSString *filterTitle;

@end
