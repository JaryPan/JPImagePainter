//
//  JPImagePainterView.h
//  JPImagePainterDemo
//
//  Created by ovopark_iOS on 16/4/11.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPImagePainterViewType) {
    JPImagePainterViewTypePush, // push进来的界面
    JPImagePainterViewTypePresent, // present进来的界面
};

@protocol JPImagePainterViewDelegate;

@interface JPImagePainterView : UIView

@property (weak, nonatomic) id<JPImagePainterViewDelegate>delegate;

// 仅对“没有导航条的情况有效”
@property (copy, nonatomic) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame originalImage:(UIImage *)image andViewType:(JPImagePainterViewType)type;

@end

@protocol JPImagePainterViewDelegate <NSObject>

@optional
- (void)imagePainterViewCancelButtonClicked:(JPImagePainterView *)imagePainterView;
- (void)imagePainterView:(JPImagePainterView *)imagePainterView saveButtonClicked:(UIImage *)paintedImage;

@end
