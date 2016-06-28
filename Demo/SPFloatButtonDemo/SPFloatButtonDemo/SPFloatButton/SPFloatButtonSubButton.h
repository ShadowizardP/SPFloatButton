//
//  SPFloatButtonSubButton.h
//  SPFloatButtonDemo
//
//  Created by SMartP on 16/6/6.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPFloatButtonSubButtonDelegate <NSObject>

@optional
- (void)floatButtonSubButtonClickedWithTag:(NSInteger)tag;

@end

@interface SPFloatButtonSubButton : UIView

@property (nonatomic , strong) UILabel *label;
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , assign) id<SPFloatButtonSubButtonDelegate> delegate;

+ (instancetype)floatButtonSubButtonWithFrame:(CGRect)frame color:(UIColor *)color title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag;
+ (instancetype)floatButtonSubButtonWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag;

@end
