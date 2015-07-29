//
//  CameraViewController.h
//  Blocstagram
//
//  Created by Mac on 7/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;

@protocol CameraViewControllerDelegate <NSObject>

-(void) cameraViewController:(CameraViewController *) cameraViewController didCompletewithImage:(UIImage *) image;

@end

@interface CameraViewController : UIViewController 

@property (nonatomic, weak) NSObject <CameraViewControllerDelegate> *delegate;

@end
