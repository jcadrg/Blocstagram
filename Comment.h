//
//  Comment.h
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@class User;

@interface Comment : NSObject

@property (nonatomic,strong) NSString *idNumber;
@property (nonatomic,strong) User *from;
@property (nonatomic, strong) NSString *text;

@end
