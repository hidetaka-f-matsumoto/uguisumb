//
//  CMBSoundManagerTests.m
//  CraftedMusicBox
//
//  Created by 松本 英高 on 2015/11/14.
//  Copyright © 2015年 hidetaka.f.matsumoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMBSoundManager.h"

@interface CMBSoundManagerTests : XCTestCase

@end

@implementation CMBSoundManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testEq {
    NSLog(@"[TEST] EQ: %@", [CMBSoundManager sharedInstance].eq);
}

@end
