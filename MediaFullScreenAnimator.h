//
//  MediaFullScreenAnimator.h
//  Blocstagram
//
//  Created by Mac on 7/14/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface MediaFullScreenAnimator : NSObject<UIViewControllerAnimatedTransitioning>

//This property tells us if the animation is a presenting animation (YES), or a dismissing animation (NO)
@property(nonatomic, assign) BOOL presenting;

//this property references the imageview from the MediaTableViewCell
@property(nonatomic, weak) UIImageView *cellImageView;

@end
