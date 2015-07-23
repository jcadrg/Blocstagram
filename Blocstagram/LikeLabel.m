//
//  LikeLabel.m
//  Blocstagram
//
//  Created by Mac on 7/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "LikeLabel.h"

@implementation LikeLabel


- (void)drawTextInRect:(CGRect)rect{
    CGPoint rectOrigin= CGPointMake(self.bounds.origin.x, self.bounds.origin.y+8);
    CGRect textRect = CGRectMake(rectOrigin.x, rectOrigin.y, 30, 30);
    
    [super drawTextInRect:textRect];
}


@end
