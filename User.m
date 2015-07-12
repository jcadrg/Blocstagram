//
//  User.m
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype) initWithDicionary:(NSDictionary *)userDictionary{
    self = [super init];
    
    
    
    if (self) {
        self.idNumber = userDictionary[@"id"];
        self.userName = userDictionary[@"userName"];
        self.fullName = userDictionary[@"full_name"];
        
        NSString *profileURLString = userDictionary[@"profile_picture"];
        NSURL *profileURL= [NSURL URLWithString:profileURLString];
        
        if (profileURL) {
            self.profilePictureURL = profileURL;
        }
        
    }
    
    
    
    
    
    return self;
}

@end
