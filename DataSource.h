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


@property (nonatomic, strong, readonly) NSString *accessToken;
@property (nonatomic,strong,readonly) NSArray *mediaItems;



+ (NSString *) instagramClientID;


-(void) deleteMediaItem:(Media *)item;
-(void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;
-(void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler;




@end
