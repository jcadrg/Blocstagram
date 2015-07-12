//
//  Comment.m
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//



#import "Comment.h"

@implementation Comment

- (instancetype) initWithDictionary:(NSDictionary *)commentDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = commentDictionary[@"id"];
        self.text = commentDictionary[@"text"];
        self.from =[[User alloc] initWithDicionary:commentDictionary[@"from"]];
    }
    
    return self;
}

@end