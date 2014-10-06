//
//  NSURL+CMBTools.m
//  CraftedMusicBox
//
//  Created by hide on 2014/10/05.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

#import "NSURL+CMBTools.h"
#import "NSString+CMBTools.h"

@implementation NSURL (CMBTools)

- (NSDictionary *)queryDictionary
{
    NSString *query = [[self query] urlDecode];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = elements[0];
        NSString *val = elements[1];
        // value中の"="を分割してしてしまった場合のフォロー
        for (NSInteger i=2; i<elements.count; i++) {
            val = [NSString stringWithFormat:@"%@=%@", val, elements[i]];
        }
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end
