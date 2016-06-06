//
//  SPFloatButton.m
//  SPFloatButtonDemo
//
//  Created by SMartP on 16/6/6.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import "SPFloatButton.h"
#import "SPFloatButtonRotationView.h"
#import "SPFloatButtonSubButton.h"

@interface SPFloatButton ()<SPFloatButtonSubButtonDelegate>

@property (nonatomic , strong) UIView *fatherView;
@property (nonatomic , strong) SPFloatButtonRotationView *rotationView;
@property (nonatomic , strong) NSMutableArray<SPFloatButtonSubButton *> *subFloatButtons;
@property (nonatomic , strong) UIButton *mask;
@property (nonatomic , assign) BOOL isShowing;

@end

@implementation SPFloatButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = (self.bounds.size.width) / 2;
        self.layer.masksToBounds = YES;
        self.subFloatButtons = [[NSMutableArray alloc]init];
        self.subButtonShowType = SubButtonShowTypeVertical;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color inView:(UIView *)view
{
    if (self = [self initWithFrame:frame]) {
        self.backgroundColor = color ? color : [UIColor colorWithRed:30/255.0 green:110/255.0 blue:190/255.0 alpha:0.5];
        [self initInView:view];
    }
    return self;
}

+ (instancetype)floatButtonWithRadius:(CGFloat)radius point:(CGPoint)point color:(UIColor *)color inView:(UIView *)view
{
    CGRect frame = CGRectMake(point.x, point.y, radius * 2, radius * 2);
    return [[self alloc]initWithFrame:frame color:color inView:view];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image inView:(UIView *)view
{
    if (self = [self initWithFrame:frame]) {
        if (image) {
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            self.imageView.contentMode = UIViewContentModeScaleToFill;
            self.imageView.image = image;
            [self addSubview:self.imageView];
            [self initInView:view];
        }
    }
    return self;
}

+ (instancetype)floatButtonWithRadius:(CGFloat)radius point:(CGPoint)point image:(UIImage *)image inView:(UIView *)view
{
    CGRect frame = CGRectMake(point.x, point.y, radius * 2, radius * 2);
    return [[self alloc]initWithFrame:frame image:image inView:view];
}

- (void)initInView:(UIView *)view
{
    if (view) {
        self.fatherView = view;
    }
    else
    {
        self.fatherView = [UIApplication sharedApplication].keyWindow;
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(floatButtonMove:)];
    [self addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    [self initLabel];
    [self.fatherView addSubview:self];
}

- (void)initLabel
{
    self.label = [[UILabel alloc]init];
    [self addSubview:self.label];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * h_c = [NSLayoutConstraint constraintWithItem:self.label
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0];
    NSLayoutConstraint * v_c = [NSLayoutConstraint constraintWithItem:self.label
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0];
    NSLayoutConstraint * h_l = [NSLayoutConstraint constraintWithItem:self.label
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:(self.bounds.size.width/6.0)];
    NSLayoutConstraint * h_r = [NSLayoutConstraint constraintWithItem:self.label
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0
                                                             constant:(self.bounds.size.width/6.0)];
    NSLayoutConstraint * v_t = [NSLayoutConstraint constraintWithItem:self.label
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:(self.bounds.size.height/6.0)];
    NSLayoutConstraint * v_b = [NSLayoutConstraint constraintWithItem:self.label
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:(self.bounds.size.height/6.0)];
    [self addConstraints:@[h_c , v_c , h_l , h_r , v_t , v_b]];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:8];
}

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(floatButtonClicked)]) {
        [self.delegate floatButtonClicked];
    }
    if (self.subFloatButtons.count != 0) {
        if (self.isShowing) {
            [self hideSubButtons];
        }
        else{
            self.mask = [[UIButton alloc]initWithFrame:self.fatherView.frame];
            self.mask.backgroundColor = [UIColor blackColor];
            self.mask.alpha = 0;
            [self.mask addTarget:self action:@selector(hideSubButtons) forControlEvents:UIControlEventTouchUpInside];
            [self.fatherView addSubview:self.mask];
            [UIView animateWithDuration:0.3 animations:^{
                self.mask.alpha = 0.3;
            }];
            [self showSubButtons];
        }
    }
}

- (void)floatButtonMove:(UIPanGestureRecognizer *)pan
{
    //    if (!self.isShowing) {
    CGPoint trans = [pan translationInView:self.fatherView];
    pan.view.center = CGPointMake(pan.view.center.x + trans.x, pan.view.center.y + trans.y);
    for (SPFloatButtonSubButton *subButton in self.subFloatButtons) {
        subButton.center = CGPointMake(pan.view.center.x + trans.x, pan.view.center.y + trans.y);
    }
    [pan setTranslation:CGPointZero inView:self.fatherView];
    //    }
}

- (void)showSubButtons
{
    self.isShowing = YES;
    switch (self.subButtonShowType) {
        case SubButtonShowTypeVertical:
            [self showSubButtonVertical];
            break;
            
        case SubButtonShowTypeHorizontal:
            [self showSubButtonHorizontal];
            break;
            
        case SubButtonShowTypeDisperse:
            [self showSubButtonDisperse];
            break;
            
        default:
            break;
    }
}

- (void)showSubButtonVertical
{
    [self sortSubButtons];
    BOOL anotherLine = YES;
    BOOL anotherDirection = NO;
    BOOL stop = NO;
    NSInteger xPoint = 0;
    NSInteger yPoint = 0;
    BOOL up;
    BOOL left = NO;
    if (self.center.y > self.fatherView.frame.size.height / 2) {
        up = YES;
        yPoint = -1;
    }
    else
    {
        up = NO;
        yPoint = 1;
    }
    if (self.center.x > self.fatherView.frame.size.width / 2) {
        left = YES;
    }
    else
    {
        left = NO;
    }
    for (NSInteger i = 0; i < self.subFloatButtons.count; i++) {
        SPFloatButtonSubButton *subButton = self.subFloatButtons[i];
        CGFloat transY = (self.frame.size.height + 10) * yPoint;
        CGFloat transX = (self.frame.size.width + 10) * xPoint;
        CGRect frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
        while ([self isOutOfBounds:frame]) {
            if (anotherLine) {
                anotherLine = NO;
                if (up) {
                    yPoint = 1;
                }
                else
                {
                    yPoint = -1;
                }
                transY = (self.frame.size.height + 10) * yPoint;
                frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
            }
            else
            {
                anotherLine = YES;
                yPoint = 0;
                if (left) {
                    xPoint -= 1;
                }
                else
                {
                    xPoint += 1;
                }
                transY = (self.frame.size.height + 10) * yPoint;
                transX = (self.frame.size.width + 10) * xPoint;
                frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                if (frame.origin.x < 0) {
                    if (!anotherDirection) {
                        left = NO;
                        xPoint = 1;
                        transY = (self.frame.size.height + 10) * yPoint;
                        transX = (self.frame.size.width + 10) * xPoint;
                        frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    }
                    else
                    {
                        stop = YES;
                    }
                }
                else if((frame.origin.x + frame.size.width) > self.fatherView.frame.size.width)
                {
                    if (!anotherDirection) {
                        left = YES;
                        xPoint = -1;
                        transY = (self.frame.size.height + 10) * yPoint;
                        transX = (self.frame.size.width + 10) * xPoint;
                        frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    }
                    else
                    {
                        stop = YES;
                    }
                }
            }
        }
        if (stop) {
            break;
        }
        [UIView animateWithDuration:0.3 animations:^{
            subButton.hidden = NO;
            subButton.transform = CGAffineTransformMakeTranslation(transX, transY);
        } completion:^(BOOL finished) {
            
        }];
        if (up) {
            if (yPoint <= 0) {
                yPoint -= 1;
            }
            else
            {
                yPoint += 1;
            }
        }
        else
        {
            if (yPoint >= 0) {
                yPoint += 1;
            }
            else
            {
                yPoint -= 1;
            }
        }
    }
}

- (void)showSubButtonHorizontal
{
    [self sortSubButtons];
    BOOL anotherLine = YES;
    BOOL anotherDirection = NO;
    BOOL stop = NO;
    NSInteger xPoint = 0;
    NSInteger yPoint = 0;
    BOOL up = NO;
    BOOL left = NO;
    if (self.center.x > self.fatherView.frame.size.width / 2) {
        left = YES;
        xPoint = -1;
    }
    else
    {
        left = NO;
        xPoint = 1;
    }
    if (self.center.y > self.fatherView.frame.size.height / 2) {
        up = YES;
    }
    else
    {
        up = NO;
    }
    for (NSInteger i = 0; i < self.subFloatButtons.count; i++) {
        SPFloatButtonSubButton *subButton = self.subFloatButtons[i];
        CGFloat transY = (self.frame.size.height + 10) * yPoint;
        CGFloat transX = (self.frame.size.width + 10) * xPoint;
        CGRect frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
        while ([self isOutOfBounds:frame]) {
            if (anotherLine) {
                anotherLine = NO;
                if (left) {
                    xPoint = 1;
                }
                else
                {
                    xPoint = -1;
                }
                transX = (self.frame.size.width + 10) * xPoint;
                frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
            }
            else
            {
                anotherLine = YES;
                xPoint = 0;
                if (up) {
                    yPoint -= 1;
                }
                else
                {
                    yPoint += 1;
                }
                transY = (self.frame.size.height + 10) * yPoint;
                transX = (self.frame.size.width + 10) * xPoint;
                frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                if (frame.origin.y < 0) {
                    if (!anotherDirection) {
                        up = NO;
                        yPoint = 1;
                        transY = (self.frame.size.height + 10) * yPoint;
                        transX = (self.frame.size.width + 10) * xPoint;
                        frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    }
                    else
                    {
                        stop = YES;
                    }
                }
                else if((frame.origin.y + frame.size.height) > self.fatherView.frame.size.height)
                {
                    if (!anotherDirection) {
                        up = YES;
                        yPoint = -1;
                        transY = (self.frame.size.height + 10) * yPoint;
                        transX = (self.frame.size.width + 10) * xPoint;
                        frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    }
                    else
                    {
                        stop = YES;
                    }
                }
            }
        }
        if (stop) {
            break;
        }
        [UIView animateWithDuration:0.3 animations:^{
            subButton.hidden = NO;
            subButton.transform = CGAffineTransformMakeTranslation(transX, transY);
        } completion:^(BOOL finished) {
            
        }];
        if (left) {
            if (xPoint <= 0) {
                xPoint -= 1;
            }
            else
            {
                xPoint += 1;
            }
        }
        else
        {
            if (xPoint >= 0) {
                xPoint += 1;
            }
            else
            {
                xPoint -= 1;
            }
        }
    }
}

- (void)showSubButtonDisperse
{
    [self sortSubButtons];
    int left = self.frame.origin.x / (self.frame.size.width + 10);
    int right = (self.fatherView.frame.size.width - self.frame.origin.x - self.frame.size.width) / (self.frame.size.width + 10);
    int top = self.frame.origin.y / (self.frame.size.height + 10);
    int bottom = (self.fatherView.frame.size.height - self.frame.origin.y - self.frame.size.height) / (self.frame.size.height + 10);
    int maxCount = (left + right + 1) * (top + bottom + 1) - 1;
    int number = 1;
    int round = 0;
    int count = 0;
    while (count < self.subFloatButtons.count && count < maxCount) {
        round++;
        int group = 0;
        int groupCount = 0;
        while ((number <= ((1 + round * 2) * (1 + round * 2) - 1)) && count < self.subFloatButtons.count && count < maxCount) {
            SPFloatButtonSubButton *subButton = self.subFloatButtons[count];
            int xPoint;
            int yPoint;
            switch (groupCount) {
                case 0:
                {
                    if (group % 2 != 0) {
                        xPoint = - (group / 2 + 1);
                    }
                    else
                    {
                        xPoint = (group / 2);
                    }
                    yPoint = -round;
                    groupCount++;
                    number++;
                    CGFloat transY = (self.frame.size.height + 10) * yPoint;
                    CGFloat transX = (self.frame.size.width + 10) * xPoint;
                    CGRect frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    if (![self isOutOfBounds:frame]) {
                        [UIView animateWithDuration:0.3 animations:^{
                            subButton.hidden = NO;
                            subButton.transform = CGAffineTransformMakeTranslation(transX, transY);
                        } completion:^(BOOL finished) {
                            
                        }];
                        count++;
                    }
                }
                    break;
                    
                case 1:
                {
                    if (group % 2 != 0) {
                        yPoint = (group / 2 + 1);
                    }
                    else
                    {
                        yPoint = - (group / 2);
                    }
                    xPoint = -round;
                    groupCount++;
                    number++;
                    CGFloat transY = (self.frame.size.height + 10) * yPoint;
                    CGFloat transX = (self.frame.size.width + 10) * xPoint;
                    CGRect frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    if (![self isOutOfBounds:frame]) {
                        [UIView animateWithDuration:0.3 animations:^{
                            subButton.hidden = NO;
                            subButton.transform = CGAffineTransformMakeTranslation(transX, transY);
                        } completion:^(BOOL finished) {
                            
                        }];
                        count++;
                    }
                }
                    break;
                    
                case 2:
                {
                    if (group % 2 != 0) {
                        xPoint = (group / 2 + 1);
                    }
                    else
                    {
                        xPoint = - (group / 2);
                    }
                    yPoint = round;
                    groupCount++;
                    number++;
                    CGFloat transY = (self.frame.size.height + 10) * yPoint;
                    CGFloat transX = (self.frame.size.width + 10) * xPoint;
                    CGRect frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    if (![self isOutOfBounds:frame]) {
                        [UIView animateWithDuration:0.3 animations:^{
                            subButton.hidden = NO;
                            subButton.transform = CGAffineTransformMakeTranslation(transX, transY);
                        } completion:^(BOOL finished) {
                            
                        }];
                        count++;
                    }
                }
                    break;
                    
                case 3:
                {
                    
                    if (group % 2 != 0) {
                        yPoint = - (group / 2 + 1);
                    }
                    else
                    {
                        yPoint = (group / 2);
                    }
                    xPoint = round;
                    groupCount++;
                    number++;
                    CGFloat transY = (self.frame.size.height + 10) * yPoint;
                    CGFloat transX = (self.frame.size.width + 10) * xPoint;
                    CGRect frame = CGRectMake(subButton.frame.origin.x + transX, subButton.frame.origin.y + transY, subButton.frame.size.width, subButton.frame.size.height);
                    if (![self isOutOfBounds:frame]) {
                        [UIView animateWithDuration:0.3 animations:^{
                            subButton.hidden = NO;
                            subButton.transform = CGAffineTransformMakeTranslation(transX, transY);
                        } completion:^(BOOL finished) {
                            
                        }];
                        count++;
                    }
                }
                    break;
                    
                case 4:
                {
                    group++;
                    groupCount = 0;
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)sortSubButtons
{
    for (NSInteger i = self.subFloatButtons.count - 1; i >= 0; i--) {
        SPFloatButtonSubButton *subButton = self.subFloatButtons[i];
        [self.fatherView bringSubviewToFront:subButton];
    }
    [self.fatherView bringSubviewToFront:self];
}

- (BOOL)isOutOfBounds:(CGRect)frame
{
    if (frame.origin.x < 0 ||
        frame.origin.y < 0 ||
        (frame.origin.x + frame.size.width) > self.fatherView.frame.size.width ||
        (frame.origin.y + frame.size.height) > self.fatherView.frame.size.height
        ) {
        return YES;
    }
    return NO;
}

- (void)hideSubButtons
{
    if (self.isShowing) {
        self.isShowing = NO;
        if (self.mask) {
            [UIView animateWithDuration:0.3 animations:^{
                self.mask.alpha = 0;
            } completion:^(BOOL finished) {
                self.mask.hidden = YES;
                self.mask = nil;
            }];
        }
        for (SPFloatButtonSubButton *subButton in self.subFloatButtons) {
            [UIView animateWithDuration:0.3 animations:^{
                subButton.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:^(BOOL finished) {
                subButton.hidden = YES;
            }];
        }
    }
}

- (void)changeColor:(UIColor *)color
{
    self.backgroundColor = color;
}

- (void)changeImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)startProgressAnimation
{
    [self stopProgressAnimation];
    self.rotationView = [[SPFloatButtonRotationView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.rotationView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.rotationView];
    
    UIView *whitePoint = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width / 2 - 2, -1, 4, 4)];
    whitePoint.layer.cornerRadius = 5;
    whitePoint.layer.masksToBounds = YES;
    whitePoint.backgroundColor = [UIColor whiteColor];
    [self.rotationView addSubview:whitePoint];
    CATransform3D rotationTransform  = CATransform3DMakeRotation(M_2_PI, 0, 0, 1);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue= [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration= 0.2;
    animation.autoreverses= NO;
    animation.cumulative= YES;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.repeatCount= FLT_MAX;
    [self.rotationView.layer addAnimation:animation forKey:@"rotation"];
}

- (void)stopProgressAnimation
{
    [self.rotationView.layer removeAnimationForKey:@"rotation"];
    [self.rotationView removeFromSuperview];
    self.rotationView = nil;
}

- (void)startBitAnimation
{
    [self stopBitAnimation];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=@(1.0);
    animation.toValue=@(1.1);
    animation.duration=0.5;
    animation.autoreverses=YES;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"bit"];
}

- (void)stopBitAnimation
{
    [self.layer removeAnimationForKey:@"bit"];
}

- (void)addSubFloatButtonWithColor:(UIColor *)color title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag
{
    CGFloat cut = self.frame.size.width / 10;
    CGRect subFrame = CGRectMake(self.frame.origin.x + cut / 2, self.frame.origin.y + cut / 2, self.frame.size.width - cut, self.frame.size.height - cut);
    SPFloatButtonSubButton *subButton = [SPFloatButtonSubButton floatButtonSubButtonWithFrame:subFrame color:color title:title titleColor:(UIColor *)titleColor tag:tag];
    subButton.delegate = self;
    [self.subFloatButtons addObject:subButton];
    [self.fatherView addSubview:subButton];
    subButton.hidden = YES;
}

- (void)addSubFloatButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor tag:(NSInteger)tag
{
    CGFloat cut = self.frame.size.width / 10;
    CGRect subFrame = CGRectMake(self.frame.origin.x + cut / 2, self.frame.origin.y + cut / 2, self.frame.size.width - cut, self.frame.size.height - cut);
    SPFloatButtonSubButton *subButton = [SPFloatButtonSubButton floatButtonSubButtonWithFrame:subFrame image:image title:title titleColor:(UIColor *)titleColor tag:tag];
    subButton.delegate = self;
    [self.subFloatButtons addObject:subButton];
    [self.fatherView addSubview:subButton];
    subButton.hidden = YES;
}

- (void)deleteSubFloatButtonWithTag:(NSInteger)tag
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag==%d" , tag];
    NSArray *selectedSubButtons = [self.subFloatButtons filteredArrayUsingPredicate:predicate];
    for (SPFloatButtonSubButton *subButton in selectedSubButtons) {
        [self.subFloatButtons removeObject:subButton];
    }
}

- (void)deleteAllSubFloatButtons
{
    [self.subFloatButtons removeAllObjects];
}

- (NSInteger)getSubFloatButtonCount
{
    return self.subFloatButtons.count;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - FloatViewSubViewDelegate
- (void)floatButtonSubButtonClickedWithTag:(NSInteger)tag
{
    [self hideSubButtons];
    if ([self.delegate respondsToSelector:@selector(floatButtonSubButtonClickedWithTag:)]) {
        [self.delegate floatButtonSubButtonClickedWithTag:tag];
    }
}

@end
