//
//  UIImage+ImageUtilities.h
//  Blocstagram
//
//  Created by Mac on 7/27/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageUtilities)

-(UIImage *) imageWithFixedOrientation;
-(UIImage *) imageResizedToMatchAspectRatioOfSize:(CGSize) size;
-(UIImage *) imageCroppedToRect:(CGRect) cropRect;

@end
