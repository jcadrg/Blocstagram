//
//  MediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Mac on 7/14/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

//Custom initializer
-(instancetype) initWithMedia:(Media *)media;

-(void) centerScrollView;

@end
