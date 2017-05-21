//
//  UIDevice+CMBTools.m
//  CraftedMusicBox
//
//  Created by Hidetaka Matsumoto on 2017/04/10.
//  Copyright © 2017年 hidetaka.f.matsumoto. All rights reserved.
//

#import "UIDevice+CMBTools.h"
#import <sys/utsname.h>

@implementation UIDevice (CMBTools)

+ (NSString *)modelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end

