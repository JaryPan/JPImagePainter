//
//  PainterZoomView.m
//  JPImagePainterDemo
//
//  Created by ovopark_iOS on 16/4/11.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "PainterZoomView.h"

@interface PainterZoomView ()
{
    UIImageView *imageView;
    PainterView *painterView;
}

@end

@implementation PainterZoomView

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    if (self = [super initWithFrame:frame]) {
        // 图片
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.image = image;
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        // 绘画图层
        painterView = [[PainterView alloc] initWithFrame:imageView.frame];
        painterView.backgroundColor = [UIColor clearColor];
        painterView.brushColor = [UIColor redColor];
        painterView.brushWidth = 2;
        painterView.userInteractionEnabled = NO;
        [self addSubview:painterView];
    }
    
    return self;
}

#pragma mark - 重新设置frame
- (void)resetFrame:(CGRect)frame
{
    self.frame = frame;
    imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    painterView.frame = imageView.frame;
}

#pragma mark - setPainterModel
- (void)setPainterModel:(PainterModel )painterModel
{
    _painterModel = painterModel;
    painterView.painterModel = painterModel;
    
    if (painterModel == PainterModelPaint) {
        imageView.userInteractionEnabled = YES;
    } else {
        imageView.userInteractionEnabled = NO;
    }
}

- (void)setBrushWidth:(CGFloat)brushWidth
{
    _brushWidth = brushWidth;
    painterView.brushWidth = brushWidth;
}

- (void)setBrushColor:(UIColor *)brushColor
{
    if (_brushColor != brushColor) {
        _brushColor = brushColor;
    }
    painterView.brushColor = brushColor;
}


#pragma mark - removeLastLine
- (void)removeLastLine
{
    [painterView removeLastLine];
}
#pragma mark - removeLastLine
- (void)removeAllLines
{
    [painterView removeAllLines];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [painterView touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [painterView touchesMoved:touches withEvent:event];
}

@end
