//
//  CameraToolBar.h
//  Blocstagram
//
//  Created by Mac on 7/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraToolBar;

@protocol CameraToolBarDelegate <NSObject>

-(void) leftButtonPressedOnToolBar:(CameraToolBar *) toolbar;
-(void) rightButtonPressedOnToolBar:(CameraToolBar *) toolbar;
-(void) cameraButtonPressedOnToolBar:(CameraToolBar *) toolbar;

@end

@interface CameraToolBar : UIView

-(instancetype) initWithImageNames:(NSArray *)imageNames;

@property (nonatomic,weak) NSObject <CameraToolBarDelegate> *delegate;

@end
