//
//  DDPaintView.m
//  EditImage
//
//  Created by HouHoward on 2017/2/14.
//  Copyright © 2017年 rongzi. All rights reserved.
//

#import "DDPaintView.h"


@interface DDPaintView()
@property (nonatomic, strong) NSMutableArray *paths;
@end

@implementation DDPaintView

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

- (void)clear
{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

- (void)back
{
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

/**
 确定起点
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获得当前的触摸点
    UITouch *touch = [touches anyObject];
    CGPoint startPos = [touch locationInView:touch.view];
    
    // 2.创建一个新的路径
    UIBezierPath *currenPath = [UIBezierPath bezierPath];
    currenPath.lineCapStyle = kCGLineCapRound;
    currenPath.lineJoinStyle = kCGLineJoinRound;
    
    // 设置起点
    [currenPath moveToPoint:startPos];
    
    // 3.添加路径到数组中
    [self.paths addObject:currenPath];
    
    [self setNeedsDisplay];
}

/**
 连线
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:touch.view];
    
    UIBezierPath *currentPath = [self.paths lastObject];
    [currentPath addLineToPoint:pos];
    
    [self setNeedsDisplay];
}

/**
 连线
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor redColor] set];
    
    for (UIBezierPath *path in self.paths) {
        path.lineWidth = 5;
        [path stroke];
    }
}

@end
