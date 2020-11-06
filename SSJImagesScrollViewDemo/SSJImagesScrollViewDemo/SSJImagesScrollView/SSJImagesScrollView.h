//
//  SSJImagesScrollView.h
//  imagesScrollViewDemo
//
//  Created by 金汕汕 on 2020/6/23.
//  Copyright © 2020 金汕汕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,UIImageType) {
    //本地图片
    UIImageTypeOfStatic,
    //网络图片
    UIImageTypeOfUrl,
};
NS_ASSUME_NONNULL_BEGIN

@interface SSJImagesScrollView : UIView

///是否开启定时轮播，默认false：不开启
@property (nonatomic,assign) BOOL openTimer;

/// 填充图片
/// @param imageNames 图片数组，存放 图片名字或者图片URL
/// @param type 图片类型，判断是不是网络图片
/// @param placeholderImage 占位图片，当图片没加载好的时候预先显示
- (void)drawUIWithImageNames:(NSArray *)imageNames type:(UIImageType)type placeholderImage:(UIImage *)placeholderImage;
@end

NS_ASSUME_NONNULL_END


///使用方法
/**
 - (void)viewWillAppear:(BOOL)animated{
     ///如果是网路图片，那把数组元素换成图片地址就可以了
     NSArray *localImages = @[@"p1.JPG",@"p2.JPG",@"p3.JPG",@"p4.JPG"];
     [self createBannerWithImages:localImages isHttpImage:NO];
 }

 /// 创建图片滚动
 /// @param images 图片名字数组，可以是网络也可以是本地，
 /// @param isHttpImage  是否网络图片
 - (void)createBannerWithImages:(NSArray <NSString *>*)images isHttpImage:(BOOL)isHttpImage{
     /// 先移除已存在的
     for (UIView *childView in self.view.subviews) {
         if ([childView isKindOfClass:[SSJImagesScrollView class] ]) {
             [childView removeFromSuperview];
         }
     }
     /// 添加
     float screenW = [UIScreen mainScreen].bounds.size.width;
     CGRect scrollViewFrame = CGRectMake(15, 0, screenW - 15 * 2, 140);
     SSJImagesScrollView *scView = [[SSJImagesScrollView alloc] initWithFrame:scrollViewFrame];
     scView.openTimer = YES;
     if (!isHttpImage) {
         [scView drawUIWithImageNames:images type:UIImageTypeOfStatic placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
     }else{
         //网络图片
         [scView drawUIWithImageNames:images type:UIImageTypeOfUrl placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
     }
     
     [self.view addSubview:scView];
 }
 */
