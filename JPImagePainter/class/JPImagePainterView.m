//
//  JPImagePainterView.m
//  JPImagePainterDemo
//
//  Created by ovopark_iOS on 16/4/11.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#define kPainterButtonPadding 30
#define kPainterButtonWidth 30
#define kPainterButtonHeight 30

#import "JPImagePainterView.h"
#import "PainterZoomView.h"

@interface JPImagePainterView () <UIScrollViewDelegate>
{
    UIImage *originalImage;
    JPImagePainterViewType viewType;
    
    UIVisualEffectView *topView;
    UILabel *titleLabel;
    UIView *topSeparatorLine;
    
    
    UIScrollView *myScrollView;
    PainterZoomView *painterZoomView;
    
    
    UIVisualEffectView *bottomView;
    UIView *bottomSeparatorLine;
    
    UIButton *cancelButton;
    UIButton *saveButton;
    UIButton *brushStatusButton; // 画笔状态按钮
    UIButton *eraseButton; // 擦除按钮
}

@end

@implementation JPImagePainterView

- (instancetype)initWithFrame:(CGRect)frame originalImage:(UIImage *)image andViewType:(JPImagePainterViewType)type
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:40.0/255.0 alpha:1.0];
        self.clipsToBounds = YES;
        
        // 配置子视图
        [self setupSubviewsWithImage:image forViewType:type];
        
        //注册通知监测横竖屏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark - 设置子控件
- (void)setupSubviewsWithImage:(UIImage *)image forViewType:(JPImagePainterViewType)type
{
    originalImage = image;
    viewType = type;
    
    // 顶部视图
    topView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    topView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
    [self addSubview:topView];
    
    // 标题框
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, self.frame.size.width - 20, 30)];
    titleLabel.textColor = [UIColor colorWithWhite:230.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    // 分割线
    topSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height - 1, topView.frame.size.width, 1)];
    topSeparatorLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    topSeparatorLine.tintColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [topView addSubview:topSeparatorLine];
    
    // 滑动视图
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.minimumZoomScale = 1.0;
    myScrollView.maximumZoomScale = 4.0;
    [self addSubview:myScrollView];
    
    if (image) {
        CGSize imageSize = image.size;
        
        if (imageSize.width/imageSize.height > myScrollView.frame.size.width/myScrollView.frame.size.height) {
            // 图片的宽高比大于屏幕宽高比（过宽）
            painterZoomView = [[PainterZoomView alloc] initWithFrame:CGRectMake(0, myScrollView.frame.size.height/2 - (myScrollView.frame.size.width * imageSize.height/imageSize.width)/2, myScrollView.frame.size.width, myScrollView.frame.size.width * imageSize.height/imageSize.width) andImage:image];
        } else {
            // 刚好或者过高
            painterZoomView = [[PainterZoomView alloc] initWithFrame:CGRectMake(myScrollView.frame.size.width/2 - (myScrollView.frame.size.height * imageSize.width/imageSize.height)/2, 0, myScrollView.frame.size.height * imageSize.width/imageSize.height, myScrollView.frame.size.height) andImage:image];
        }
        
        painterZoomView.backgroundColor = [UIColor clearColor];
        painterZoomView.painterModel = PainterModelPaint;
        painterZoomView.brushWidth = 2;
        painterZoomView.brushColor = [UIColor redColor];
        [myScrollView addSubview:painterZoomView];
    }
    
    
    // 底部工具图
    bottomView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    bottomView.frame = CGRectMake(0, self.frame.size.height - 49, self.frame.size.width, 49);
    [self addSubview:bottomView];
    
    // 分割线
    bottomSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 1)];
    bottomSeparatorLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    bottomSeparatorLine.tintColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [bottomView addSubview:bottomSeparatorLine];
    
    // 取消按钮
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(10, bottomView.frame.size.height/2 - kPainterButtonHeight/2, kPainterButtonWidth, kPainterButtonHeight);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"doodle_cancle"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    
    // 保存按钮
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(bottomView.frame.size.width - 10 - kPainterButtonWidth, cancelButton.frame.origin.y, kPainterButtonWidth, kPainterButtonHeight);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"doodle_save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:saveButton];
    
    // 画笔状态按钮
    brushStatusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    brushStatusButton.frame = CGRectMake(bottomView.frame.size.width/2 - (kPainterButtonPadding + kPainterButtonWidth * 2)/2, cancelButton.frame.origin.y, kPainterButtonWidth, kPainterButtonHeight);
    [brushStatusButton setBackgroundImage:[UIImage imageNamed:@"doodle_brush"] forState:UIControlStateNormal];
    brushStatusButton.layer.cornerRadius = brushStatusButton.frame.size.height/2;
    brushStatusButton.backgroundColor = [UIColor redColor];
    [brushStatusButton addTarget:self action:@selector(brushStatusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:brushStatusButton];
    
    // 擦除按钮
    eraseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    eraseButton.frame = CGRectMake(CGRectGetMaxX(brushStatusButton.frame) + kPainterButtonPadding, brushStatusButton.frame.origin.y, kPainterButtonWidth, kPainterButtonHeight);
    [eraseButton setBackgroundImage:[UIImage imageNamed:@"doodle_eraser"] forState:UIControlStateNormal];
    [eraseButton addTarget:self action:@selector(eraseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:eraseButton];
    
    
    // 把顶部工具栏放到视图前面
    if (topView) {
        [self bringSubviewToFront:topView];
    }
}


#pragma mark - 收到横竖屏切换通知的方法
- (void)deviceOrientationDidChange:(NSNotification *)sender
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        // 竖屏
        topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        titleLabel.frame = CGRectMake(10, 27, [UIScreen mainScreen].bounds.size.width - 20, 30);
    } else {
        // 横屏
        topView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        titleLabel.frame = CGRectMake(10, 7, [UIScreen mainScreen].bounds.size.width - 20, 30);
    }
    
    topSeparatorLine.frame = CGRectMake(0, topView.frame.size.height - 1, topView.frame.size.width, 1);
    
    myScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if (myScrollView.delegate) {
        myScrollView.scrollEnabled = YES;
        myScrollView.zoomScale = 1.0;
    } else {
        myScrollView.delegate = self;
        myScrollView.scrollEnabled = YES;
        myScrollView.zoomScale = 1.0;
        myScrollView.delegate = nil;
        myScrollView.scrollEnabled = NO;
    }
    if (originalImage) {
        CGSize imageSize = originalImage.size;
        
        if (imageSize.width/imageSize.height > myScrollView.frame.size.width/myScrollView.frame.size.height) {
            // 图片的宽高比大于屏幕宽高比（过宽）
            [painterZoomView resetFrame:CGRectMake(0, myScrollView.frame.size.height/2 - (myScrollView.frame.size.width * imageSize.height/imageSize.width)/2, myScrollView.frame.size.width, myScrollView.frame.size.width * imageSize.height/imageSize.width)];
        } else {
            // 刚好或者过高
            [painterZoomView resetFrame:CGRectMake(myScrollView.frame.size.width/2 - (myScrollView.frame.size.height * imageSize.width/imageSize.height)/2, 0, myScrollView.frame.size.height * imageSize.width/imageSize.height, myScrollView.frame.size.height)];
        }
    }
    
    bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49);
    bottomSeparatorLine.frame = CGRectMake(0, 0, bottomView.frame.size.width, 1);
    cancelButton.frame = CGRectMake(10, bottomView.frame.size.height/2 - kPainterButtonHeight/2, kPainterButtonWidth, kPainterButtonHeight);
    saveButton.frame = CGRectMake(bottomView.frame.size.width - 10 - kPainterButtonWidth, cancelButton.frame.origin.y, kPainterButtonWidth, kPainterButtonHeight);
    brushStatusButton.frame = CGRectMake(bottomView.frame.size.width/2 - (kPainterButtonPadding + kPainterButtonWidth * 2)/2, cancelButton.frame.origin.y, kPainterButtonWidth, kPainterButtonHeight);
    eraseButton.frame = CGRectMake(CGRectGetMaxX(brushStatusButton.frame) + kPainterButtonPadding, brushStatusButton.frame.origin.y, kPainterButtonWidth, kPainterButtonHeight);
}



#pragma mark - UIScrollView的代理方法（实现放大）
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return painterZoomView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    painterZoomView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    view.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                              scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - 放弃按钮的点击事件
- (void)cancelButtonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePainterViewCancelButtonClicked:)]) {
        [self.delegate imagePainterViewCancelButtonClicked:self];
    }
}

#pragma mark - 保存按钮的点击事件
- (void)saveButtonAction:(UIButton *)sender
{
    // 强制还原图片
    myScrollView.delegate = self;
    myScrollView.scrollEnabled = YES;
    [myScrollView setZoomScale:1.0 animated:NO];
    
    // 强制变为竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    // 截取图片
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(painterZoomView.frame.size.width, painterZoomView.frame.size.height), NO, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
                CGContextSaveGState(context);
                
                if (viewType == JPImagePainterViewTypePush) {
                    CGContextTranslateCTM(context, window.center.x, window.center.y - painterZoomView.frame.origin.y - 20);
                } else {
                    CGContextTranslateCTM(context, window.center.x, window.center.y - painterZoomView.frame.origin.y);
                }
                
                CGContextConcatCTM(context, window.transform);
                
                CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
                
                [self.layer renderInContext:context];
                
                CGContextRestoreGState(context);
            }
        }
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        // 实现代理方法
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePainterView:saveButtonClicked:)]) {
            [self.delegate imagePainterView:self saveButtonClicked:image];
        }
    });
}

#pragma mark - 画笔状态按钮的点击事件
- (void)brushStatusButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        // 可以缩放
        brushStatusButton.backgroundColor = [UIColor clearColor];
        
        myScrollView.delegate = self;
        myScrollView.scrollEnabled = YES;
        painterZoomView.painterModel = PainterModelNone;
    } else {
        // 可以涂鸦
        brushStatusButton.backgroundColor = [UIColor redColor];
        
        myScrollView.delegate = nil;
        myScrollView.scrollEnabled = NO;
        painterZoomView.painterModel = PainterModelPaint;
    }
}

#pragma mark - 擦除按钮的点击事件
- (void)eraseButtonAction:(UIButton *)sender
{
    [painterZoomView removeLastLine];
}

#pragma mark - setTitle
- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
    }
    
    titleLabel.text = title;
}


@end
