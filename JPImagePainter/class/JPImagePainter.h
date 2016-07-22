//
//  JPImagePainter.h
//  JPImagePainter
//
//  Created by ovopark_iOS on 16/7/21.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPImagePainterDelegate;

@interface JPImagePainter : UIViewController

// 代理属性
@property (weak, nonatomic) id<JPImagePainterDelegate>delegate;

// 需要传入的图片
@property (strong, nonatomic) UIImage *originalImage;

// 涂鸦界面的标题
@property (copy, nonatomic) NSString *painterTitle;

// 供用户传递数据
@property (strong, nonatomic) id userInfo;

// 保存了涂鸦图片的block回调
@property (copy, nonatomic) void(^completedBlock)(UIImage *paintedImage);

@end

// 代理方法
@protocol JPImagePainterDelegate <NSObject>

@optional
// 点击了取消按钮
- (void)imagePainterDidClickCancelButton:(JPImagePainter *)imagePainter;
// 点击了保存按钮
- (void)imagePainter:(JPImagePainter *)imagePainter saveButtonClicked:(UIImage *)paintedImage;

@end
