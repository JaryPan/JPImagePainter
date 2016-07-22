//
//  PainterZoomView.h
//  JPImagePainterDemo
//
//  Created by ovopark_iOS on 16/4/11.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PainterView.h"

@interface PainterZoomView : UIView

@property (assign, nonatomic) PainterModel painterModel;

@property (assign, nonatomic) CGFloat brushWidth;
@property (strong, nonatomic) UIColor *brushColor;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;

- (void)resetFrame:(CGRect)frame;

- (void)removeLastLine;
- (void)removeAllLines;

@end
