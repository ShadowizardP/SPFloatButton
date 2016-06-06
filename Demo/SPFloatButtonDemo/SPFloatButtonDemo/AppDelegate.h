//
//  AppDelegate.h
//  SPFloatButtonDemo
//
//  Created by SMartP on 16/6/6.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPFloatButton.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//添加全局floatView
@property (nonatomic , strong) SPFloatButton *floatButton;


@end

