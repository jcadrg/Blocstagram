//
//  DataSource.h
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

+(instancetype) sharedInstace;

@property (nonatomic,strong,readonly) NSArray *mediaItems;




@end
