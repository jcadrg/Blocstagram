//
//  DataSource.h
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>



@class Media;

typedef void (^NewItemCompletionBlock)(NSError *error);

@interface DataSource : NSObject

+(instancetype) sharedInstance;





@property (nonatomic,strong,readonly) NSArray *mediaItems;
@property(nonatomic,strong,readonly) NSString *accessToken;

-(void) removeMediaItemsAtIndex:(NSUInteger)index;

-(void) deleteMediaItem:(Media *)item;

+(NSString *) instagramClientId;

-(void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;
-(void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;




@end
