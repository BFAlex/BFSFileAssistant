//
//  BFRunloop.m
//  BFFileManagerDemo
//
//  Created by BFsAlex on 2018/9/28.
//  Copyright © 2018年 BFAlex. All rights reserved.
//

#import "BFRunloop.h"

@implementation BFRunloop

#pragma mark - API

+ (instancetype)runloop {
    
    BFRunloop *rl = [[BFRunloop alloc] init];
    if (rl) {
        //
    }
    
    return rl;
}

- (void)showRunloop {
    
    NSRunLoop *myRunloop = [NSRunLoop currentRunLoop];
    //
    CFRunLoopObserverCallBack callBack;
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunloop, &context);
    
}

@end
