//
//  MyOperation.m
//  KKThreadsDemo
//
//  Created by 看影成痴 on 2020/7/2.
//  Copyright © 2020 看影成痴. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation

- (void)main {
        
    NSLog(@"1, %s, thread:%@", __func__, [NSThread currentThread]);
    
    sleep(2);
    
    NSLog(@"2, %s, thread:%@", __func__, [NSThread currentThread]);
}

@end
