//
//  NormalView.m
//  Demo
//
//  Created by SMartP on 16/6/2.
//  Copyright © 2016年 SMartP. All rights reserved.
//

#import "NormalView.h"
#import "AppDelegate.h"

@implementation NormalView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    UILabel *clickText = [[UILabel alloc]initWithFrame:CGRectMake(50, 80, 100, 30)];
    clickText.text = @"点击事件 : ";
    [self addSubview:clickText];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(150, 80, 100, 30)];
    [self addSubview:self.label];
    
    self.label.textColor = [UIColor blackColor];
    UILabel *countText = [[UILabel alloc]initWithFrame:CGRectMake(50, 120, 100, 30)];
    countText.text = @"子view数量 : ";
    [self addSubview:countText];
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 120, 100, 30)];
    [self addSubview:self.countLabel];
    UILabel *tagText = [[UILabel alloc]initWithFrame:CGRectMake(50, 160, 50, 30)];
    tagText.text = @"Tag : ";
    [self addSubview:tagText];
    
    self.tagField = [[UITextField alloc]initWithFrame:CGRectMake(100, 160, 100, 30)];
    self.tagField.backgroundColor = [UIColor whiteColor];
    self.tagField.borderStyle = UITextBorderStyleRoundedRect;
    self.tagField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.tagField];
    
    self.tagHint = [[UILabel alloc]initWithFrame:CGRectMake(210, 160, 100, 30)];
    self.tagHint.text = @"Tag不能为空";
    self.tagHint.hidden = YES;
    self.tagHint.textColor = [UIColor redColor];
    [self addSubview:self.tagHint];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 200, 100, 30)];
    addBtn.backgroundColor = [UIColor blueColor];
    [addBtn setTitle:@"增加该tag子视图" forState:UIControlStateNormal];
    addBtn.tintColor = [UIColor whiteColor];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, 100, 30)];
    deleteBtn.backgroundColor = [UIColor grayColor];
    [deleteBtn setTitle:@"删除该tag子视图" forState:UIControlStateNormal];
    deleteBtn.tintColor = [UIColor whiteColor];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    
    UIButton *deleteAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 240, 100, 30)];
    deleteAllBtn.backgroundColor = [UIColor redColor];
    [deleteAllBtn setTitle:@"删除所有子视图" forState:UIControlStateNormal];
    deleteAllBtn.tintColor = [UIColor whiteColor];
    deleteAllBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleteAllBtn addTarget:self action:@selector(deleteAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteAllBtn];
    
    UIButton *rotationBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 280, 100, 30)];
    rotationBtn.backgroundColor = [UIColor blueColor];
    [rotationBtn setTitle:@"开始转动动画" forState:UIControlStateNormal];
    [rotationBtn setTitle:@"停止转动动画" forState:UIControlStateSelected];
    rotationBtn.tintColor = [UIColor whiteColor];
    rotationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rotationBtn addTarget:self action:@selector(rotationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rotationBtn];
    
    UIButton *bitBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 280, 100, 30)];
    bitBtn.backgroundColor = [UIColor grayColor];
    [bitBtn setTitle:@"开始跳动动画" forState:UIControlStateNormal];
    [bitBtn setTitle:@"停止转动动画" forState:UIControlStateSelected];
    bitBtn.tintColor = [UIColor whiteColor];
    bitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bitBtn addTarget:self action:@selector(bitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bitBtn];
}

- (void)addBtnClicked
{
    [self.tagField resignFirstResponder];
    if (!self.tagField.text ||[self.tagField.text  isEqual: @""]) {
        self.tagHint.hidden = NO;
    }
    else
    {
        self.tagHint.hidden = YES;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        //添加子View
        switch ([appDelegate.floatButton getSubFloatButtonCount] % 4) {
                /**
                 *添加纯色子View
                 *参数说明：
                 *Color：子View颜色，传入nil默认半透明蓝色
                 *title：子View中的字体内容，传入nil则不显示
                 *titleColor：字体颜色，传入nil默认黑色
                 *tag：子View所对应的tag，获取子View点击事件、删除子View时需要
                 */
            case 0:
                [appDelegate.floatButton addSubFloatButtonWithColor:[UIColor redColor] title:[NSString stringWithFormat:@"tag : %@", self.tagField.text] titleColor:nil tag:[self.tagField.text integerValue]];
                break;
                
            case 1:
                [appDelegate.floatButton addSubFloatButtonWithColor:[UIColor yellowColor] title:[NSString stringWithFormat:@"tag : %@", self.tagField.text] titleColor:[UIColor blueColor] tag:[self.tagField.text integerValue]];
                break;
                
                /**
                 *添加图片子View
                 *参数说明：
                 *Image：子View图片，传入nil默认透明
                 *其余同纯色
                 */
            case 2:
                [appDelegate.floatButton addSubFloatButtonWithImage:[UIImage imageNamed:@"2"] title:nil titleColor:nil tag:[self.tagField.text integerValue]];
                break;
                
            case 3:
                [appDelegate.floatButton addSubFloatButtonWithImage:[UIImage imageNamed:@"3"] title:nil titleColor:nil tag:[self.tagField.text integerValue]];
                break;
                
            default:
                break;
        }
        self.countLabel.text = [NSString stringWithFormat:@"%ld" , (long)[appDelegate.floatButton getSubFloatButtonCount]];
    }
}

- (void)deleteBtnClicked
{
    [self.tagField resignFirstResponder];
    if (!self.tagField.text ||[self.tagField.text  isEqual: @""]) {
        self.tagHint.hidden = NO;
    }
    else
    {
        self.tagHint.hidden = YES;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        //删除对应tag子View
        [appDelegate.floatButton deleteSubFloatButtonWithTag:[self.tagField.text integerValue]];
        self.countLabel.text = [NSString stringWithFormat:@"%ld" , (long)[appDelegate.floatButton getSubFloatButtonCount]];
    }
}

- (void)deleteAllBtnClicked
{
    [self.tagField resignFirstResponder];
    self.tagHint.hidden = YES;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //删除所有子View
    [appDelegate.floatButton deleteAllSubFloatButtons];
    self.countLabel.text = [NSString stringWithFormat:@"%ld" , (long)[appDelegate.floatButton getSubFloatButtonCount]];
}

//动画
- (void)rotationBtnClicked:(UIButton *)btn
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (btn.selected) {
        
        //停止浮标转动动画
        [appDelegate.floatButton stopProgressAnimation];
    }
    else
    {
        
        //开始浮标转动动画
        [appDelegate.floatButton startProgressAnimation];
    }
    btn.selected = !btn.selected;
    
}

- (void)bitBtnClicked:(UIButton *)btn
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (btn.selected) {
        
        //停止跳动动画
        [appDelegate.floatButton stopBitAnimation];
    }
    else
    {
        
        //开始跳动动画
        [appDelegate.floatButton startBitAnimation];
    }
    btn.selected = !btn.selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
