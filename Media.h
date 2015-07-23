//
//  Media.h
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LikeButton.h"

typedef NS_ENUM(NSInteger, MediaDownloadState){
    MediaDownloadStateNeedsImage = 0,
    MediaDownloadStateDownloadInProgress = 1,
    MediaDownloadStateNonRecoverableError = 2,
    MediaDownloadStateHasImage = 3,
    
};

@class User;

@interface Media : NSObject<NSCoding>

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSArray *comments;

@property (nonatomic, assign) MediaDownloadState downloadState;

@property (nonatomic, assign) LikeState likeState;



-(instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;


@end
