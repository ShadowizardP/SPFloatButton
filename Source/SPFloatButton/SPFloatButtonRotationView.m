//
//  SPFloatButtonRotationView.m
//  SPFloatButtonDemo
//
//  Created by SMartP on 16/6/6.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import "SPFloatButtonRotationView.h"

@implementation SPFloatButtonRotationView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat alpha;
    CGContextSetLineWidth(context, 15);
    for (int i = 0; i < 50; i++) {
        alpha = 1.0 - (i / 50.0);
        [[UIColor colorWithRed:1 green:1 blue:1 alpha:alpha]set];
        CGContextAddArc(context, self.center.x, self.center.y, self.bounds.size.width / 2 + 2, -M_PI_2 - (M_PI_2 / 50.0 * i), -M_PI_2 - (M_PI_2 / 50.0 * (i + 1)), 1);
        CGContextStrokePath(context);
    }
}


@end
