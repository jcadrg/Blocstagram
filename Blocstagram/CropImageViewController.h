//
//  CropImageViewController.h
//  Blocstagram
//
//  Created by Mac on 7/29/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MediaFullScreenViewController.h"

@class CropImageViewController;

@protocol CropImageViewControllerDelegate <NSObject>

-(void) cropControllerFinishedWithImage:(UIImage *) croppedImage;

@end

@interface CropImageViewController : MediaFullScreenViewController

-(instancetype) initWithImage:(UIImage *) sourceImage;

@property (nonatomic, weak) NSObject <CropImageViewControllerDelegate> *delegate;

@end
