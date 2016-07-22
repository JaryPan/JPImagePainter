//
//  PainterView.h
//  JPPainter
//
//  Created by ovopark_iOS on 16/4/7.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PainterModel) {
    PainterModelNone = 0, // 什么也不做
    PainterModelPaint = 2, // 绘画
};

@interface PainterView : UIView

@property (assign, nonatomic) PainterModel painterModel;

@property (assign, nonatomic) CGFloat brushWidth;
@property (strong, nonatomic) UIColor *brushColor;

- (void)removeLastLine;
- (void)removeAllLines;

@end
