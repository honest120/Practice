//
//  BezierPathView.m
//  01、绘图_01
//
//  Created by kinglinfu on 16/8/29.
//  Copyright © 2016年 Tens. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

// 绘图的方法，当视图显示时自动调用，不能手动调用
- (void)drawRect:(CGRect)rect {
    
    [self drawLines];
    
    // [self drawGraphics];
    
    // [self drawArc];
    
    //     [self drawBezier];
    
    //    [self drawBezierPaths];
}


#pragma mark - 画直线
- (void)drawLines {
    
    // 1、创建一条路径对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 2、将画笔移动到某个点
    [path moveToPoint:CGPointMake(20, 50)];
    
    // 3、绘制一条直线到某个点
    [path addLineToPoint:CGPointMake(300, 50)];
    [path addLineToPoint:CGPointMake(160, 200)];
    // [path addLineToPoint:CGPointMake(20, 50)];
    // 4、闭合路径
    [path closePath];
    
    //    [path moveToPoint:CGPointMake(160, 200)];
    //    [path addLineToPoint:CGPointMake(20, 350)];
    //    [path addLineToPoint:CGPointMake(300,350)];
    //    [path closePath];
    
    /*
     CGFloat dashs[] = {2,10,2};
     // 5、设置虚线： dashs: 虚线的虚实线的长度，count: 虚线的组成段数， phase: 设置虚线的起始位置
     [path setLineDash:dashs count:3 phase:0];
     */
    
    // 6、设置线条宽度
    [path setLineWidth:10];
    
    // 7、设置线头的样式：三种样式，kCGLineCapButt, kCGLineCapRound, kCGLineCapSquare
    [path setLineCapStyle:kCGLineCapRound];
    
    // 8、设置线条连接点的样式：kCGLineJoinMiter, kCGLineJoinRound,kCGLineJoinBevel
    [path setLineJoinStyle:kCGLineJoinRound];
    
    // 6、设置描边的颜色
    [[UIColor redColor] setStroke];
    [[UIColor whiteColor] setFill];
    
    // 7、绘制(描边)
    [path stroke];
    
    // 8、绘制(内部填充)
    [path fill];
}

#pragma mark - 画基本图形
- (void)drawGraphics {
    
    CGRect rect = CGRectMake(20, 260, 320, 200);
    
    // 画矩形
    // UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    // 圆角矩形
    // UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:20];
    
    // 内切的椭圆、圆形
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    [[UIColor redColor] setStroke];
    [[UIColor whiteColor] setFill];
    path.lineWidth = 5;
    
    [path stroke];
    [path fill];
}

#pragma mark - 画弧线
- (void)drawArc {
    
    CGPoint center = self.center;
    
    /**
     Center: 圆心
     radius: 半径
     startAngle: 起始弧度
     endAngle: 终点弧度
     clockwise:是否顺时针
     **/
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:150 startAngle:0 endAngle: M_PI_2 clockwise:YES];
    
    path.lineWidth = 5;
    [path addLineToPoint:center];
    [path closePath];
    
    [[UIColor redColor] setStroke];
    [[UIColor whiteColor] setFill];
    
    [path stroke];
    [path fill];
}

#pragma mark - 画贝塞尔曲线
- (void)drawBezier {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor redColor] setStroke];
    path.lineWidth = 5;
    
    CGPoint beginPoint = CGPointMake(0, 300);
    CGPoint endPoint = CGPointMake(50, 300);
    CGPoint controlPoint = CGPointMake(25, 200);
    
    [path moveToPoint:beginPoint];
    // 1、一个控制点的贝塞尔曲线
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    CGPoint beginPoint_1 = CGPointMake(50, 300);
    CGPoint endPoint_1 = CGPointMake(150, 300);
    CGPoint controlPoint_1 = CGPointMake(75, 400);
    CGPoint controlPoint_2 = CGPointMake(125, 200);
    
    [path moveToPoint:beginPoint_1];
    // 2、两个控制点的贝塞尔曲线
    [path addCurveToPoint:endPoint_1 controlPoint1:controlPoint_1 controlPoint2:controlPoint_2];
    
    // 3、拼接两条路径
    UIBezierPath *subPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(170, 300, 200, 200)];
    [path appendPath:subPath];
    
    // 4、移除所有的路径
    // [path removeAllPoints];
    
    [path stroke];
}


#pragma mark - 画波线
- (void)drawBezierPaths {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor redColor] setStroke];
    path.lineWidth = 3;
    
    // 当前视图的宽高
    CGFloat screenWidth = CGRectGetWidth(self.bounds);
    CGFloat screenHeight = CGRectGetHeight(self.bounds);
    
    // 每一个曲线的宽度
    CGFloat width = screenWidth / 10;
    
    for (int i = 0; i < 10; i++) {
        
        // 控制点的Y坐标
        CGFloat controlPoint_Y = 0;
        if (i % 2 == 0) {
            
            controlPoint_Y = screenHeight / 2 - 100;
        } else {
            
            controlPoint_Y = screenHeight / 2 + 100;
        }
        
        CGPoint beginPoint = CGPointMake(i * width, screenHeight / 2);
        CGPoint endPoint = CGPointMake(beginPoint.x + width, screenHeight / 2);
        CGPoint controlPoint = CGPointMake((width / 2)+ (i * width), controlPoint_Y);
        
        [path moveToPoint:beginPoint];
        [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    }
    
    [path stroke];
}

@end






