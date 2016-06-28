//
//  SPFloatButton.h
//  SPFloatButtonDemo
//
//  Created by SMartP on 16/6/6.
//  Copyright © 2016年 SMartP. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , SubButtonShowType)
{
    SubButtonShowTypeVertical = 0,  //纵向优先
    SubButtonShowTypeHorizontal = 1,  //横向优先
    SubButtonShowTypeDisperse = 2,  //四散
};

@protocol SPFloatButtonDelegate <NSObject>

@optional
- (void)floatButtonClicked;
- (void)floatButtonSubButtonClickedWithTag:(NSInteger)tag;

@end

@interface SPFloatButton : UIView

@property(nonatomic , strong) UILabel *label;
@property(nonatomic , strong) UIImageView *imageView;
@property(nonatomic , assign) id<SPFloatButtonDelegate> delegate;
@property(nonatomic , assign) SubButtonShowType subButtonShowType;

+ (instancetype)floatButtonWithRadius:(CGFloat)radius point:(CGPoint)point color:(UIColor *)color inView:(UIView *)view;
+ (instancetype)floatButtonWithRadius:(CGFloat)radius point:(CGPoint)point image:(UIImage *)image inView:(UIView *)view;
- (void)changeColor:(UIColor *)color;
- (void)changeImage:(UIImage *)image;
- (void)startProgressAnimation;
- (void)stopProgressAnimation;
- (void)startBitAnimation;
- (void)stopBitAnimation;
- (void)addSubFloatButtonWithColor:(UIColor *)color title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag;
- (void)addSubFloatButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag;
- (void)deleteSubFloatButtonWithTag:(NSInteger)tag;
- (void)deleteAllSubFloatButtons;
- (NSInteger)getSubFloatButtonCount;

@end
