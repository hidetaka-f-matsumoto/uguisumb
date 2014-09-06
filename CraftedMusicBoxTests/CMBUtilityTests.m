//
//  CMBUtilityTests.m
//  CraftedMusicBox
//
//  Created by hide on 2014/07/13.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CMBUtility.h"

@interface CMBUtilityTests : XCTestCase

@end

@implementation CMBUtilityTests

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

- (void)testNoteDataWithABCString
{
    NSString *testAbc = @"^C,,3/4_D'";
    NSArray *infos = [CMBUtility noteInfosWithABCString:testAbc];
    NSLog(@"abc-string to note-infos %@ -> %@", testAbc, infos);
    for (NSDictionary *info in infos) {
        CMBNoteData *data = [[CMBNoteData alloc] initWithInfo:info];
        NSLog(@"note-info to note-data %@ -> %@", info, data);
    }
}

@end
