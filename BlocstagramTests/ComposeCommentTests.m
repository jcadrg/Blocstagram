//
//  ComposeCommentTests.m
//  Blocstagram
//
//  Created by Mac on 8/11/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ComposeCommentView.h"

@interface ComposeCommentTests : XCTestCase

@end

@implementation ComposeCommentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testThatSetTextSetsIsWriting{
    
    ComposeCommentView *cv =[[ComposeCommentView alloc] init];
    
    [cv setText:@"Writing a comment"];
    XCTAssertEqual(cv.isWritingComment, YES, @"Should write a comment");
    [cv setText:@"Not writint a comment"];
    XCTAssertEqual(cv.isWritingComment, NO, @"Should not write a comment");
    
    
}



@end
