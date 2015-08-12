//
//  MediaTests.m
//  Blocstagram
//
//  Created by Mac on 8/11/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Media.h"
#import "User.h"
#import "Comment.h"


@interface MediaTests : XCTestCase

@end

@implementation MediaTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testThatInitializerWorks{
    NSDictionary *userDictionary = @{@"id":@"8675309",
                                       @"username":@"d'oh",
                                       @"full_name":@"Homer Simpson",
                                       @"profile_picture":@"http://www.example.com/example.jpg"};
    
    
    NSDictionary *commentUserDictionary = @{@"id": @"8675309",
                                            @"username": @"d'oh",
                                            @"full_name": @"Marge",
                                            @"profile_picture" : @"http://www.example.com/example.jpg"};
    
    
    
    NSDictionary *commentDictionary = @{@"id":@"12345",
                                        @"text": @"I love duff beer",
                                        @"from": commentUserDictionary};
    
    NSDictionary *mediaDictionary =@{@"user":@"12345",
                                         @"caption":@{@"text":@"I love duff beer"},
                                         @"user_has_liked": @"true",
                                         @"comments":@{@"data":@[commentDictionary]},
                                         @"images":@{@"standard_resolution":@{@"url":@"http://www.example.com/example.jpg"}}};
    
    User *mediaUser = [[User alloc] initWithDicionary:userDictionary];
    Comment *comment = [[Comment alloc] initWithDictionary:commentDictionary];
    Media *mediaToTest = [[Media alloc] initWithDictionary:mediaDictionary];
    
    XCTAssertEqual(mediaToTest.likeState,LikeStateLiked, @"Media should be liked" );
    XCTAssertEqualObjects(mediaToTest.user, mediaUser, @"Media user should be equal");
    XCTAssertEqualObjects(mediaToTest.comments, @[comment]);
    XCTAssertEqualObjects(mediaToTest.mediaURL, [NSURL URLWithString:mediaDictionary[@"images"][@"standard_resolution"][@"url"]], @"Media URL should match");
    
                                        
    
    
}



@end
