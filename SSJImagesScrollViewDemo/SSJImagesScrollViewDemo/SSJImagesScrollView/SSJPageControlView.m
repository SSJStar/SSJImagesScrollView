//
//  SSJPageControlView.m
//  imagesScrollViewDemo
//
//  Created by 金汕汕 on 2020/6/24.
//  Copyright © 2020 金汕汕. All rights reserved.
//

#import "SSJPageControlView.h"
@interface SSJPageControlView ()
@property (nonatomic,assign) float everyWidthValue;
@property (nonatomic,assign) float leddingValue;
@property (nonatomic,strong) UIColor *colorNormalValue;
@property (nonatomic,strong) UIColor *colorSelectedValue;
@property (nonatomic,strong) UIView *backView;
@end
@implementation SSJPageControlView

#pragma mark -- 初始化参数值
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initParameter];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initParameter];
    }
    return self;
}

/// 设置成员变量默认值
- (void)initParameter{
    self.everyWidthValue = 10.0;
    self.leddingValue = 3.0;
    self.colorNormalValue = [UIColor whiteColor];
    self.colorSelectedValue = [UIColor blackColor];
}

#pragma mark -- 初始化小长方形

/// 初始化小长方形
/// @param count 总个数
/// @param block <#block description#>
- (void)initWithCount:(NSInteger)count block:(void(^)(SSJPageControlView *pageControlView))block{
    CGSize size = self.frame.size;
    ///每一个小长方形宽度
    float everyWidth = self.everyWidthValue;
    ///每一个小长方形高度
    float everyHeight = size.height;
    ///小长方形之间的间距
    float ledding = self.leddingValue;
    ///添加所有小长方形的背景iview，为了居中布局
    self.backView = [UIView new];
    float backViewWidth = count * everyWidth + (count - 1) * ledding;
    float backViewX = (size.width - backViewWidth) / 2.0;
    self.backView.frame = CGRectMake(backViewX, 0, backViewWidth, everyHeight);
    [self addSubview:self.backView];
    ///添加一个个小长方形
    float x = 0 , y = 0;
    for (int i = 0; i < count; i ++) {
        if(i > 0)
            x = i * (everyWidth + ledding);
        CGRect frameEve = CGRectMake(x, y, everyWidth, everyHeight);
        UIView *eveChildView = [[UIView alloc] initWithFrame:frameEve];
        eveChildView.tag = i;
        eveChildView.backgroundColor = self.colorNormalValue;
        [self.backView addSubview:eveChildView];
    }
    ///设置第一个被选中
    [self updateSelectedIndex:0];
}

/// 更新选中状态
/// @param selectedIndex 被选中的索引
- (void)updateSelectedIndex:(NSInteger)selectedIndex{
    for (UIView *childView in self.backView.subviews) {
        childView.backgroundColor = self.colorNormalValue;
        if (childView.tag == selectedIndex) {
            childView.backgroundColor = self.colorSelectedValue;
        }
    }
}

#pragma mark -- 链式语法
- (SSJPageControlView *(^)(float everyWidth))everyWidth{
    return ^(float everyWidth){
        self.everyWidthValue = everyWidth;
        return self;
    };
}

- (SSJPageControlView *(^)(float ledding))ledding{
    return ^(float ledding){
        self.leddingValue = ledding;
        return self;
    };
}

- (SSJPageControlView *(^)(UIColor *colorNormal))colorNormal{
    return ^(UIColor *colorNormal){
        self.colorNormalValue = colorNormal;
        return self;
    };
}

- (SSJPageControlView *(^)(UIColor *colorSelected))colorSelected{
    return ^(UIColor *colorSelected){
        self.colorSelectedValue = colorSelected;
        return self;
    };
}



@end
