//
//  Media.m
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "Media.h"
#import "User.h"
#import "Comment.h"

@implementation Media

- (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary {
    self = [super init];
    
    if (self) {
        self.idNumber = mediaDictionary[@"id"];
        self.user = [[User alloc]initWithDicionary:mediaDictionary[@"user"]];
        NSString *standardResolutionString = mediaDictionary[@"images"][@"standard_resolution"][@"url"];
        NSURL *standardResolutionURL = [NSURL URLWithString:standardResolutionString];
        
        if (standardResolutionURL) {
            self.mediaURL = standardResolutionURL;
            
            self.downloadState = MediaDownloadStateNeedsImage;
            
        }else{
            
            self.downloadState = MediaDownloadStateNonRecoverableError;
        }
        
        NSDictionary *captionDicionary = mediaDictionary[@"caption"];
        
        if ([captionDicionary isKindOfClass:[NSDictionary class]]) {
            self.caption = captionDicionary[@"text"];
        } else {
            self.caption = @"";
        }
        
        NSMutableArray *commentsArray = [NSMutableArray array];
        
        for (NSDictionary *commentDictionary in mediaDictionary[@"comments"][@"data"]) {
            Comment *comment = [[Comment alloc] initWithDictionary:commentDictionary];
            [commentsArray addObject:comment];
        }
        
        NSDictionary *likesDictionary = mediaDictionary [@"likes"];
        
        if ([likesDictionary isKindOfClass:[NSDictionary class]]) {
            self.likesCount = [likesDictionary[@"count"] integerValue];
        }
        
        
        self.comments = commentsArray;
        
        BOOL userHasLiked = [mediaDictionary[@"user_has_liked"] boolValue];
        
        self.likeState = userHasLiked ? LikeStateLiked : LikeStateNotLiked;
    }
    
    return self;
}


#pragma mark - NSCoding

-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if (self) {
        
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.user = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(user))];
        self.mediaURL =[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(mediaURL))];
        self.image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
        
        if(self.image){
            
            self.downloadState = MediaDownloadStateHasImage;
            
        }else if (self.mediaURL){
            
            self.downloadState = MediaDownloadStateNeedsImage;
            
        }else{
            
            self.downloadState = MediaDownloadStateNonRecoverableError;
        }
        
        
        self.caption = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(caption))];
        self.comments = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(comments))];
        
        self.likeState = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(likeState))];
        
        self.likesCount = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(likesCount))];
   
        
    }
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.user forKey:NSStringFromSelector(@selector(user))];
    [aCoder encodeObject:self.mediaURL forKey:NSStringFromSelector(@selector(mediaURL))];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
    [aCoder encodeObject:self.caption forKey:NSStringFromSelector(@selector(caption))];
    [aCoder encodeObject:self.comments forKey:NSStringFromSelector(@selector(comments))];
    
    [aCoder encodeInteger:self.likeState forKey:NSStringFromSelector(@selector(likeState))];
    
    [aCoder encodeInteger:self.likesCount forKey:NSStringFromSelector(@selector(likesCount))];
    

}

@end