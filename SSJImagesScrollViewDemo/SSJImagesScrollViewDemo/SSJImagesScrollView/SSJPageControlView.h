//
//  SSJPageControlView.h
//  imagesScrollViewDemo
//
//  Created by 金汕汕 on 2020/6/24.
//  Copyright © 2020 金汕汕. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSJPageControlView : UIView

//链式语法
/// 宽度
@property (nonatomic,copy) SSJPageControlView *(^everyWidth)(float everyWidth);
/// 间距
@property (nonatomic,copy) SSJPageControlView *(^ledding)(float ledding);
/// 未选中的颜色
@property (nonatomic,copy) SSJPageControlView *(^colorNormal)(UIColor *colorNormal);
/// 选中的颜色
@property (nonatomic,copy) SSJPageControlView *(^colorSelected)(UIColor *colorSelected);

/// 初始化小长方形
/// @param count 总个数
/// @param block <#block description#>
- (void)initWithCount:(NSInteger)count block:(void(^)(SSJPageControlView *pageControlView))block;

/// 更新选中状态
/// @param selectedIndex 被选中的索引
- (void)updateSelectedIndex:(NSInteger)selectedIndex;

@end

/// 使用方法
/**
    CGRect fr = frame;
    fr.origin.y = fr.size.height - 10;
    fr.size.height = 3;
    self.pageControlView = [[SSJPageControlView alloc] initWithFrame:fr];
    UIColor *colorNormal = [UIColor colorWithWhite:1.0 alpha:.5];
    UIColor *colorSelected = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.pageControlView.ledding(5).everyWidth(10);
    self.pageControlView.colorNormal(colorNormal).colorSelected(colorSelected);
    [self addSubview:self.pageControlView];
 */


NS_ASSUME_NONNULL_END
