//
//  MediaTableViewCellTest.m
//  Blocstagram
//
//  Created by Mac on 8/11/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MediaTableViewCell.h"
#import "Media.h"

@interface MediaTableViewCellTest : XCTestCase

@end

@implementation MediaTableViewCellTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testHeightReturnsAppropiateHeight{
    
    NSDictionary *userDictionary =@{@"id":@"8675309",
                                    @"username":@"d'oh",
                                    @"full_name":@"Homer Simpson",
                                    @"profile_picture":@"http://www.example.com/example.jpg"};
    
    
    NSDictionary *mediaDictionary =@{@"user":userDictionary,
                                     @"caption":@{@"text":@"I love duff beer"},
                                     @"user_has_liked": @"true",
                                     @"comments":@{@"data":@[]},
                                     @"images":@{@"standard_resolution":@{@"url":@"http://www.example.com/example.jpg"}}};
    
    
    Media *media = [[Media alloc] initWithDictionary:mediaDictionary];
    media.image = [UIImage imageNamed:@"1.jpg"];
    UITraitCollection *traitCollection =[[UIApplication sharedApplication]keyWindow].traitCollection;
    CGFloat height = [MediaTableViewCell heightForMediaItem:media width:100 traitCollection:traitCollection];
    
    XCTAssertEqual(height, 271, @"Height should be standard height");
    
}



@end
