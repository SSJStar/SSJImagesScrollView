//
//  SSJImagesScrollView.m
//  imagesScrollViewDemo
//
//  Created by 金汕汕 on 2020/6/23.
//  Copyright © 2020 金汕汕. All rights reserved.
//

/// 核心思想
/** 左中右三张图片，无论翻到上一页还是下一页，翻完之后的处理如下：
        1、更新中间UIImageView展现翻到的那个图片，更新左右两个UIImageView的image内容
        2、将三张图片归位，也就是滚动到中间位置，让其展现在我们面前的永远是centerImageView，保证了左右可以无限轮播
 */

#import "SSJImagesScrollView.h"
#import "SSJPageControlView.h"
//#import "UIColor+Extension.h"
#import "UIImageView+WebCache.h"
@interface  SSJImagesScrollView()<UIScrollViewDelegate>
//滚动视图
@property (nonatomic,strong) UIScrollView *scrollView;
/// 上一页
@property (nonatomic,strong) UIImageView *leftImageView;
/// 当前页
@property (nonatomic,strong) UIImageView *centerImageView;
/// 下一页
@property (nonatomic,strong) UIImageView *rightImageView;
/// 上一页索引
@property (nonatomic,assign) NSInteger lastPageIndex;
/// 当前页索引
@property (nonatomic,assign) NSInteger currpentPageIndex;
/// 下一页索引
@property (nonatomic,assign) NSInteger nextPageIndex;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSArray *datas;

@property (nonatomic,strong) SSJPageControlView *pageControlView;
/// 图片类型
@property (nonatomic,assign) UIImageType type;
/// 占位图片
@property (nonatomic,strong) UIImage *placeholderImage;
@end
@implementation SSJImagesScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollView];
        CGRect fr = frame;
        fr.origin.y = fr.size.height - 10;
        fr.size.height = 3;
        self.pageControlView = [[SSJPageControlView alloc] initWithFrame:fr];
        UIColor *colorNormal = [UIColor colorWithWhite:1.0 alpha:.5];
        UIColor *colorSelected = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.pageControlView.ledding(5).everyWidth(10);
        self.pageControlView.colorNormal(colorNormal).colorSelected(colorSelected);
        [self addSubview:self.pageControlView];
    }
    return self;
}

///初始化UIScrollView和3个UIImageView
- (void)initScrollView{
    //当前view宽度
    float scrollViewWidth = self.frame.size.width;
    float scrollViewHeight = self.frame.size.height;
    
    CGRect scrollViewFrame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;//隐藏滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;//隐藏滚动条
    self.scrollView.layer.cornerRadius = 6.0f;//设置圆角
    [self addSubview:self.scrollView];
    
    //添加左边ImageView
    CGRect leftFrame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.leftImageView = [[UIImageView alloc] initWithFrame:leftFrame];
    [self.scrollView addSubview:self.leftImageView];
    //添加中间ImageView
    CGRect centerFrame = CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.centerImageView = [[UIImageView alloc] initWithFrame:centerFrame];
    [self.scrollView addSubview:self.centerImageView];
    //添加右边ImageView
    CGRect rightFrame = CGRectMake(scrollViewWidth * 2.0, 0, scrollViewWidth, scrollViewHeight);
    self.rightImageView = [[UIImageView alloc] initWithFrame:rightFrame];
    [self.scrollView addSubview:self.rightImageView];
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(scrollViewWidth * 3.0, scrollViewHeight);
    //第一次的时候 滚动到中间
    [self resetLocation];
}

/// 填充图片
/// @param imageNames 图片数组，存放 图片名字或者图片URL
/// @param type 图片类型，判断是不是网络图片
/// @param placeholderImage 占位图片，当图片没加载好的时候预先显示
- (void)drawUIWithImageNames:(NSArray *)imageNames type:(UIImageType)type placeholderImage:(UIImage *)placeholderImage{
    self.type = type;
    self.placeholderImage = placeholderImage;
    if (!self.placeholderImage) {
        self.placeholderImage = [UIImage new];
    }
    if (imageNames.count > 0) {
        self.datas = imageNames;
        [self setPageIndex];
        if(self.openTimer){
            //开启定时方法
            _timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
        [self.pageControlView initWithCount:imageNames.count block:^(SSJPageControlView * _Nonnull pageControlView) {
            [pageControlView updateSelectedIndex:0];
        }];
    }
}


//更新索引
- (void)setPageIndex{
    //每次翻页都会更新self.currpentPageIndex的值，然后根据这个值来更新3张图片的展示内容
    self.scrollView.pagingEnabled = YES;//开启翻页
    NSInteger currentIndex = self.currpentPageIndex;
    if (self.datas.count == 1) {
        self.lastPageIndex = 0;
        self.currpentPageIndex = 0;
        self.nextPageIndex = 0;
        self.scrollView.pagingEnabled = NO;//关闭翻页
    }
    if (self.datas.count == 2) {
        self.lastPageIndex = currentIndex == 0?(1):(0);
        self.currpentPageIndex = currentIndex;
        self.nextPageIndex = currentIndex == 0?(1):(0);
    }
    if (self.datas.count > 2) {
        //当currpentPageIndex=0的时候，上一页就变成了-1，本质上应该显示最后一张图片，所以这里加上self.datas.count
        self.lastPageIndex = currentIndex-1 < 0?(currentIndex-1+self.datas.count):(currentIndex-1);
        self.currpentPageIndex = currentIndex;
        //当currpentPageIndex最后一张的时候，下一页+1就数组越界了，本质上应该显示第一张图片，所以这里减去self.datas.count
        self.nextPageIndex = currentIndex+1 == self.datas.count?(currentIndex+1-self.datas.count):(currentIndex+1);
        NSLog(@"lastPageIndex==%ld  currpentPageIndex==%ld  nextPageIndex==%ld",self.lastPageIndex,self.currpentPageIndex,self.nextPageIndex);
    }
    [self loadImageWithIndex:self.lastPageIndex imageView:self.leftImageView];
    [self loadImageWithIndex:self.currpentPageIndex imageView:self.centerImageView];
    [self loadImageWithIndex:self.nextPageIndex imageView:self.rightImageView];
    /// 更新选中状态
    [self.pageControlView updateSelectedIndex:currentIndex];
}

- (void)loadImageWithIndex:(NSInteger)index imageView:(UIImageView *)imageView{
    if (index < self.datas.count) {
        NSString *imageName = self.datas[index];
        if(imageName.length == 0){
            NSLog(@"SSJImagesScrollView --loadImageWithIndex: -- 图片路径为空！！");
//            return;
        }
        if (self.type == UIImageTypeOfStatic) {
            imageView.image = [UIImage imageNamed:imageName];
        }else if (self.type == UIImageTypeOfUrl) {
            NSURL *imgUrl = [NSURL URLWithString:imageName];
            [imageView sd_setImageWithURL:imgUrl placeholderImage:self.placeholderImage options:SDWebImageProgressiveDownload completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                NSLog(@"下载好了：%@",imageURL.absoluteString);
            }];
        }
        
    }
}
#pragma mark ---------- UIScrollViewDelegate ----------
///执行scrollView的scrollRectToVisible方法才会进入这个代理方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"1111");
    if(self.openTimer){
        self.currpentPageIndex = self.nextPageIndex;
        [self resetLocation];
        //设置左中右图片
        [self setPageIndex];
    }
}

///滚动结束会调用这个代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //无论翻到哪一页，变化的只有图片下标和内容，3个imgeView位置不变
    //当前view宽度
    float scrollViewWidth = self.frame.size.width;
    if (scrollView.contentOffset.x == 0) {//翻到上一页
        self.currpentPageIndex = self.lastPageIndex;
        [self resetLocation];
    }else if (scrollView.contentOffset.x == scrollViewWidth * 2) {//翻到下一页
        self.currpentPageIndex = self.nextPageIndex;
        [self resetLocation];
    }else{//表示没变化
        return;
    }
    NSLog(@"当前是第%ld页",self.currpentPageIndex);
    //设置左中右图片
    [self setPageIndex];
}


/// 重置图片位置,让scrollview滚动到中间，这样永远都可以看到左中右三个图片
- (void)resetLocation{
    //当前view宽度
    float scrollViewWidth = self.frame.size.width;
    CGRect fr = self.scrollView.frame;
    fr.origin.x = scrollViewWidth;
    [self.scrollView scrollRectToVisible:fr animated:NO];
}

#pragma mark --- 定时器方法
- (void)scrollScrollView:(id)sender{
    //    根据核心思想可得，每次滚动后都会重置consizeoffect ,所以定时器就是不停的从scrollViewWidth滚动到scrollViewWidth*2的位置
    float scrollViewWidth = self.frame.size.width;
    CGRect fr = self.scrollView.frame;
    fr.origin.x = scrollViewWidth*2.0;
    [self.scrollView scrollRectToVisible:fr animated:YES];
}
@end
