//
//  CraftedMusicBoxTests.m
//  CraftedMusicBoxTests
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMBUtility.h"

@interface CraftedMusicBoxTests : XCTestCase

@end

@implementation CraftedMusicBoxTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testPath
{
    CMBUtility *utility = [CMBUtility sharedInstance];
    NSLog(@"[TEST] score dir = %@", [utility getScoreDirPath]);
}

@end
