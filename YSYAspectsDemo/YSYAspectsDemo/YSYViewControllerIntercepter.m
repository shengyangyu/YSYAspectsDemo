//
//  YSYViewControllerIntercepter.m
//  YSYAspectsDemo
//
//  Created by shengyang_yu on 16/4/28.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYViewControllerIntercepter.h"
#import <UIKit/UIKit.h>
#import <Aspects/Aspects.h>

@implementation YSYViewControllerIntercepter

+ (void)load {
    [super load];
    [YSYViewControllerIntercepter shareInstance];
}

+ (instancetype)shareInstance {

    static dispatch_once_t onceToken;
    static YSYViewControllerIntercepter *tInstance = nil;
    if (!tInstance) {
        dispatch_once(&onceToken, ^{
            tInstance = [[YSYViewControllerIntercepter alloc] init];
        });
    }
    return tInstance;
}

- (instancetype)init {

    self = [super init];
    if (self) {
        // 拦截
        [UIViewController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            [self loadView:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillAppear:animated viewController:[aspectInfo instance]];
        } error:NULL];
    }
    
    return self;
}

/**
 * 被置换的方法 可以设置统一的东西
 */
- (void)loadView:(UIViewController *)viewController {
     NSLog(@"[%@ loadView]", [viewController class]);

}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    NSLog(@"[%@ viewWillAppear:%@]", [viewController class], animated ? @"YES" : @"NO");
}

@end
