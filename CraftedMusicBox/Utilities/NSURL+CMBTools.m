//
//  NSURL+CMBTools.m
//  CraftedMusicBox
//
//  Created by hide on 2014/10/05.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "NSURL+CMBTools.h"

@implementation NSURL (CMBTools)

- (NSDictionary *)queryDictionary
{
    NSString *query = [self query];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
