//
//  AppDelegate.m
//  SPFloatButtonDemo
//
//  Created by SMartP on 16/6/6.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import "AppDelegate.h"
#import "VerticalSubViewViewController.h"
#import "HorizontalSubViewViewController.h"
#import "DisperseSubViewViewController.h"

@interface AppDelegate ()<SPFloatButtonDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    VerticalSubViewViewController *verticalSubViewViewController = [[VerticalSubViewViewController alloc]init];
    UINavigationController *navVerticalSub = [[UINavigationController alloc]initWithRootViewController:verticalSubViewViewController];
    verticalSubViewViewController.title = @"纵向展开";
    HorizontalSubViewViewController *horizontalSubViewViewController = [[HorizontalSubViewViewController alloc]init];
    UINavigationController *navHorizontalSub = [[UINavigationController alloc]initWithRootViewController:horizontalSubViewViewController];
    horizontalSubViewViewController.title = @"横向展开";
    DisperseSubViewViewController *disperseSubViewViewController = [[DisperseSubViewViewController alloc]init];
    UINavigationController *navDisperseSub = [[UINavigationController alloc]initWithRootViewController:disperseSubViewViewController];
    disperseSubViewViewController.title = @"四散展开";
    NSArray *viewCtrs = @[navVerticalSub,navHorizontalSub,navDisperseSub];
    
    UITabBarController *rootTabBarVC = [[UITabBarController alloc]init];
    [rootTabBarVC setViewControllers:viewCtrs];
    
    [self.window setRootViewController:rootTabBarVC];
    
    [self.window makeKeyAndVisible];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    //添加floatView主View（添加FloatView需要在 makeKeyAndVisible 之后）
    /**
     *添加纯色主View
     *参数说明：
     *Radius：主View半径，不能为nil
     *point：初始化位置，不能为nil
     *color：主View颜色，传入nil默认半透明蓝色
     *inView：需要将floatView添加在这个View中，传入nil默认添加在window上，可以跨View、ViewController
     */
    //    self.floatView = [FloatView floatViewWithRadius:30 point:CGPointMake(bounds.size.width - 100 , bounds.size.height - 150) color:nil inView:nil];
    
    /**
     *添加图片主View
     *参数说明：
     *image：主View图片，传入nil默认无图片
     *其余与纯色相同
     */
    self.floatButton = [SPFloatButton floatButtonWithRadius:30 point:CGPointMake(bounds.size.width - 100 , bounds.size.height - 150) image:[UIImage imageNamed:@"1"] inView:nil];
    
    //设置代理（代理方法调用在最下方）
    self.floatButton.delegate = self;
    
    //主View文字(主View Label暴露，可自行更改，默认不限行数，黑色8号字体，内容水平居中)
    self.floatButton.label.text = @"main";
    self.floatButton.label.textColor = [UIColor blackColor];
    
    //添加子View
    
    /**
     *添加纯色子View
     *参数说明：
     *Color：子View颜色，传入nil默认半透明蓝色
     *title：子View中的字体内容，传入nil则不显示
     *titleColor：字体颜色，传入nil默认黑色
     *tag：子View所对应的tag，获取子View点击事件、删除子View时需要
     */
    [self.floatButton addSubFloatButtonWithColor:[UIColor yellowColor] title:@"tag : 888" titleColor:nil tag:888];
    
    /**
     *添加图片子View
     *参数说明：
     *Image：子View图片，传入nil默认透明
     *其余同纯色
     */
    [self.floatButton addSubFloatButtonWithImage:[UIImage imageNamed:@"4"] title:nil titleColor:nil tag:889];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//FloatView代理方法
#pragma mark - FloatViewDelegate

//主View点击事件
- (void)floatButtonClicked
{
    NSArray *vcArray = [(UITabBarController *)self.window.rootViewController viewControllers];
    UINavigationController *nav = (UINavigationController *)vcArray[0];
    VerticalSubViewViewController *verticalSubVC = nav.viewControllers[0];
    nav = (UINavigationController *)vcArray[1];
    HorizontalSubViewViewController *horizontalSubVC = nav.viewControllers[0];
    nav = (UINavigationController *)vcArray[2];
    DisperseSubViewViewController *disperseSubVC = nav.viewControllers[0];
    verticalSubVC.normalView.label.text = @"main clicked";
    horizontalSubVC.normalView.label.text = @"main clicked";
    disperseSubVC.normalView.label.text = @"main clicked";
}

//子View点击事件，通过添加时传入的tag判断具体点击的子View
- (void)floatButtonSubButtonClickedWithTag:(NSInteger)tag
{
    NSArray *vcArray = [(UITabBarController *)self.window.rootViewController viewControllers];
    UINavigationController *nav = (UINavigationController *)vcArray[0];
    VerticalSubViewViewController *verticalSubVC = nav.viewControllers[0];
    nav = (UINavigationController *)vcArray[1];
    HorizontalSubViewViewController *horizontalSubVC = nav.viewControllers[0];
    nav = (UINavigationController *)vcArray[2];
    DisperseSubViewViewController *disperseSubVC = nav.viewControllers[0];
    verticalSubVC.normalView.label.text = [NSString stringWithFormat:@"tag : %ld",(long)tag];;
    horizontalSubVC.normalView.label.text = [NSString stringWithFormat:@"tag : %ld",(long)tag];;
    disperseSubVC.normalView.label.text = [NSString stringWithFormat:@"tag : %ld",(long)tag];
}


@end
