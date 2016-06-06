//
//  NormalView.h
//  Demo
//
//  Created by SMartP on 16/6/2.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalView : UIScrollView

@property (nonatomic , strong) UILabel * label;
@property (nonatomic , strong) UILabel *countLabel;
@property (nonatomic , strong) UITextField *tagField;
@property (nonatomic, strong) UILabel *tagHint;

@end
