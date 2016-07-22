//
//  PainterView.m
//  JPPainter
//
//  Created by ovopark_iOS on 16/4/7.
//  Copyright © 2016年 JaryPan. All rights reserved.
//

#import "PainterView.h"


@interface PainterView ()
{
    NSMutableArray *linesArray;
}

@end

@implementation PainterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        linesArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.painterModel == PainterModelPaint) {
        NSMutableArray *pointArray = [NSMutableArray array];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(self.brushWidth), @"brushWidth", self.brushColor, @"brushColor", pointArray, @"pointArray", nil];
        [linesArray addObject:dic];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.painterModel == PainterModelPaint) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        
        __weak NSMutableArray *pointArray = [linesArray lastObject][@"pointArray"];
        NSValue *pointValue = [NSValue valueWithCGPoint:point];
        [pointArray addObject:pointValue];
        
        // 重绘界面
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    // 得到上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (NSUInteger i = 0; i < linesArray.count; i++) {
        CGFloat brushWidth = [linesArray[i][@"brushWidth"] floatValue];
        __weak UIColor *brushColor = linesArray[i][@"brushColor"];
        __weak NSMutableArray *pointArray = linesArray[i][@"pointArray"];
        
        // 画笔粗细
        CGContextSetLineWidth(context, brushWidth);
        // 画笔颜色
        CGContextSetStrokeColorWithColor(context, brushColor.CGColor);
        
        if (pointArray.count > 0) {
            for (NSUInteger j = 0; j < pointArray.count - 1; j++) {
                __weak NSValue *firstPointValue = pointArray[j];
                __weak NSValue *secondPointValue = pointArray[j+1];
                
                CGPoint firstPoint = [firstPointValue CGPointValue];
                CGPoint secondPoint = [secondPointValue CGPointValue];
                
                // 把笔触移动到一个点
                CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
                // 笔触和另一个点形成一个路径
                CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
            }
        }
        
        
        // 绘制
        CGContextStrokePath(context);
    }
    
    // 关闭图形上下文
    UIGraphicsEndPDFContext();
}


- (void)removeLastLine
{
    [linesArray removeLastObject];
    [self setNeedsDisplay];
}
- (void)removeAllLines
{
    [linesArray removeAllObjects];
    [self setNeedsDisplay];
}


@end
