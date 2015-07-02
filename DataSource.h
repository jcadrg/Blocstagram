//
//  DataSource.h
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+(instancetype) sharedInstance;

@property (nonatomic,strong,readonly) NSArray *mediaItems;

-(void) removeMediaItemsAtIndex:(NSUInteger)index;




@end
