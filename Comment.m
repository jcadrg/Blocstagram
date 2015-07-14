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

#pragma mark - NSCoding

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if(self){
        self.idNumber =[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.text = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(text))];
        self.from = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(from))];
        
    }
    
    return self;
}



-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.text forKey:NSStringFromSelector(@selector(text))];
    [aCoder encodeObject:self.from forKey:NSStringFromSelector(@selector(from))];
}

@end