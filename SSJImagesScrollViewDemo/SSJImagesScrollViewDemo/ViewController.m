//
//  ViewController.m
//  SSJImagesScrollViewDemo
//
//  Created by 苏墨 on 2020/11/6.
//

#import "ViewController.h"
#import "SSJImagesScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

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
@end
