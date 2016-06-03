//
//  Quartz2DView.m
//  Quartz2D_Demo
//
//  Created by mac373 on 16/5/27.
//  Copyright © 2016年 ole. All rights reserved.
//

#import "DrawBoard.h"

@implementation DGLine
@end

@implementation DGCircular
@end

@implementation DGRectangle
@end

@implementation DrawBoard

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}
- (NSMutableArray *)lines
{
    if (_lines == nil) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}
- (NSMutableArray *)circulars
{
    if (_circulars == nil) {
        _circulars = [NSMutableArray array];
    }
    return _circulars;
}
- (NSMutableArray *)rectangles
{
    if (_rectangles == nil) {
        _rectangles = [NSMutableArray array];
    }
    return _rectangles;
}
- (NSMutableArray *)graphs
{
    if (_graphs == nil) {
        _graphs = [NSMutableArray array];
    }
    return _graphs;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

// 触摸-开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (_drawType)
    {
        case T_PEN:[self touchesBeganPen:touches withEvent:event];break;
        case T_LINE:[self touchesBeganLine:touches withEvent:event];break;
        case T_CIRCULAR:[self touchesBeganCircular:touches withEvent:event];break;
        case T_RECT:[self touchesBeganRectangle:touches withEvent:event];break;
        default:break;
    }
}
// 触摸-移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    switch (_drawType)
    {
        case T_PEN:[self touchesMovedPen:touches withEvent:event];break;
        case T_LINE:[self touchesMovedLine:touches withEvent:event];break;
        case T_CIRCULAR:[self touchesMovedCircular:touches withEvent:event];break;
        case T_RECT:[self touchesMovedRectangle:touches withEvent:event];break;
        default:break;
    }
}

// 离开view(停止触摸)
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    [self touchesMoved:touches withEvent:event];
    //    switch (_drawType)
    //    {
    //        case T_PEN:[self touchesEndedPen:touches withEvent:event];break;
    //        case T_LINE:[self touchesEndedLine:touches withEvent:event];break;
    //        case T_CIRCULAR:[self touchesEndedCircular:touches withEvent:event];break;
    //        case T_RECT:[self touchesEndedRectangle:touches withEvent:event];break;
    //        default:break;
    //    }
}

// 重绘
- (void)drawRect:(CGRect)rect
{
    // 获取上下文
    _ctx = UIGraphicsGetCurrentContext();
    
    // 设置绘图状态
    // 设置边框颜色 红色
    CGContextSetRGBStrokeColor(_ctx, 1.0, 0, 0, 1.0);
    // 设置填充颜色 白色透明
    CGContextSetRGBFillColor(_ctx, 1.0, 1.0, 1.0, 0.1);
    // 设置线条宽度
    CGContextSetLineWidth(_ctx, 10);
    // 设置线条的起点和终点的样式
    CGContextSetLineCap(_ctx, kCGLineCapRound);
    // 设置线条的转角的样式
    CGContextSetLineJoin(_ctx, kCGLineJoinRound);
    
    // 颜色
    //    [[UIColor redColor] set];
    for (id obj in self.graphs)
    {
        if([obj isMemberOfClass:[UIBezierPath class]])
        {
            [self drawPen:(UIBezierPath *)obj];
        }
        else if([obj isMemberOfClass:[DGLine class]])
        {
            [self drawLine:(DGLine *)obj];
            
        }
        else if([obj isMemberOfClass:[DGCircular class]])
        {
            [self drawCircular:(DGCircular *)obj];
            
        }
        else if([obj isMemberOfClass:[DGRectangle class]])
        {
            [self drawRectangle:(DGRectangle *)obj];
        }
    }
    
}

// 画笔-触摸-开始
- (void)touchesBeganPen:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint startPoint = [touch locationInView:touch.view];
    // 3.当用户手指按下的时候创建一条路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 3.1设置路径的相关属性
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineWidth:10];
    // 4.设置当前路径的起点
    [path moveToPoint:startPoint];
    // 5.将路径添加到数组中
    [self.paths addObject:path];
    // 6.调用drawRect方法重回视图
    [self setNeedsDisplay];
    // 7.将路径添加到图形数组中
    [self.graphs addObject:path];
}

// 画笔-触摸-移动
- (void)touchesMovedPen:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint movePoint = [touch locationInView:touch.view];
    // 3.取出当前的path
    UIBezierPath *currentPath = [self.paths lastObject];
    // 4.设置当前路径的终点
    [currentPath addLineToPoint:movePoint];
    // 5.调用drawRect方法重回视图
    [self setNeedsDisplay];
}

// 画直线-触摸-开始
- (void)touchesBeganLine:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint startPoint = [touch locationInView:touch.view];
    // 3.获取起点坐标
    _line = [[DGLine alloc]init];
    _line.begin_x = startPoint.x;
    _line.begin_y = startPoint.y;
    [self.lines addObject:_line];
    // 4.将直线对象添加到图形数组中
    [self.graphs addObject:_line];
}

// 画直线-触摸-移动
- (void)touchesMovedLine:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint movePoint = [touch locationInView:touch.view];
    // 3.计算终点坐标
    _line.end_x = movePoint.x;
    _line.end_y = movePoint.y;
    // 4.重绘
    [self setNeedsDisplay];
}

// 画圆-触摸-开始
- (void)touchesBeganCircular:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    // 1.获取手指对应UITouch对象
    //    UITouch *touch = [touches anyObject];
    //    // 2.通过UITouch对象获取手指触摸的位置
    //    CGPoint startPoint = [touch locationInView:touch.view];
    //    // 3.获取原点坐标
    //    _circular = [[DGCircular alloc]init];
    //    _circular.x = startPoint.x;
    //    _circular.y = startPoint.y;
    //    [self.circulars addObject:_circular];
    //    // 4.将圆对象添加到图形数组中
    //    [self.graphs addObject:_circular];
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint startPoint = [touch locationInView:touch.view];
    // 3.获取原点坐标
    _circular = [[DGCircular alloc]initWithFrame:CGRectMake(startPoint.x,startPoint.y,0.0f,0.0f)];
    [_circular setBackgroundColor:[UIColor blueColor]];
    [_circular.layer setBorderColor:[[UIColor greenColor]CGColor]];
    [_circular.layer setBorderWidth:10.0f];
    _circular.layer.cornerRadius = _circular.frame.size.width/2;
    _circular.layer.masksToBounds = YES;
    _circular.clipsToBounds = YES;
    [self.circulars addObject:_circular];
    // 4.将矩形对象添加到图形数组中
    [self.graphs addObject:_circular];
    // 5.添加进父视图中
    [self addSubview:_circular];
}

// 画圆-触摸-移动
- (void)touchesMovedCircular:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    // 1.获取手指对应UITouch对象
    //    UITouch *touch = [touches anyObject];
    //    // 2.通过UITouch对象获取手指触摸的位置
    //    CGPoint movePoint = [touch locationInView:touch.view];
    //    // 3.计算宽高
    //    _circular.w = movePoint.x - _circular.x;
    //    _circular.h = movePoint.y - _circular.y;
    //    // 4.重绘
    //    [self setNeedsDisplay];
    
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint movePoint = [touch locationInView:touch.view];
    // 3.重绘
    // 画椭圆
    CGFloat w = movePoint.x - _circular.frame.origin.x;
    CGFloat h = movePoint.y - _circular.frame.origin.y;
    [_circular setFrame:CGRectMake(_circular.frame.origin.x, _circular.frame.origin.y, w, h)];
    _circular.layer.cornerRadius = h/2;
    // 画正圆
    //    CGFloat tow_r = sqrt(pow(movePoint.x - _circular.frame.origin.x,2)+pow(movePoint.y - _circular.frame.origin.y, 2));
    //    [_circular setFrame:CGRectMake(_circular.frame.origin.x, _circular.frame.origin.y, tow_r, tow_r)];
    //    _circular.layer.cornerRadius = tow_r/2;
    
    _circular.layer.masksToBounds = YES;
    _circular.clipsToBounds = YES;
}

// 画矩形-触摸-开始
- (void)touchesBeganRectangle:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    // 1.获取手指对应UITouch对象
    //    UITouch *touch = [touches anyObject];
    //    // 2.通过UITouch对象获取手指触摸的位置
    //    CGPoint startPoint = [touch locationInView:touch.view];
    //    // 3.获取原点坐标
    //    _rectangle = [[DGRectangle alloc]init];
    //    _rectangle.x = startPoint.x;
    //    _rectangle.y = startPoint.y;
    //    [self.rectangles addObject:_rectangle];
    //    // 4.将矩形对象添加到图形数组中
    //    [self.graphs addObject:_rectangle];
    
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint startPoint = [touch locationInView:touch.view];
    // 3.获取原点坐标
    _rectangle = [[DGRectangle alloc]initWithFrame:CGRectMake(startPoint.x,startPoint.y,0.0f,0.0f)];
    [_rectangle setBackgroundColor:[UIColor blueColor]];
    [_rectangle.layer setBorderColor:[[UIColor greenColor]CGColor]];
    [_rectangle.layer setBorderWidth:10.0f];
    [self.rectangles addObject:_rectangle];
    // 4.将矩形对象添加到图形数组中
    [self.graphs addObject:_rectangle];
    // 5.添加进父视图中
    [self addSubview:_rectangle];
    // 6.保存索引
    //    _rectangle.index = [self.subviews indexOfObject:_rectangle];
    
}

// 画矩形-触摸-移动
- (void)touchesMovedRectangle:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    // 1.获取手指对应UITouch对象
    //    UITouch *touch = [touches anyObject];
    //    // 2.通过UITouch对象获取手指触摸的位置
    //    CGPoint movePoint = [touch locationInView:touch.view];
    //    // 3.计算宽高
    //    _rectangle.w = movePoint.x - _rectangle.x;
    //    _rectangle.h = movePoint.y - _rectangle.y;
    //    // 4.重绘
    //    [self setNeedsDisplay];
    
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint movePoint = [touch locationInView:touch.view];
    // 3.重绘
    [_rectangle setFrame:CGRectMake(_rectangle.frame.origin.x, _rectangle.frame.origin.y, movePoint.x - _rectangle.frame.origin.x, movePoint.y - _rectangle.frame.origin.y)];
}

// 重绘-画笔
- (void)drawPen:(UIBezierPath *)p
{
    [p stroke];
}

// 重绘-画直线
- (void)drawLine:(DGLine *)l
{
    // 1.设置起点、终点
    CGContextMoveToPoint(_ctx, l.begin_x, l.begin_y);
    CGContextAddLineToPoint(_ctx, l.end_x, l.end_y);
    // 2.渲染
    CGContextStrokePath(_ctx);
}

// 重绘-画圆
- (void)drawCircular:(DGCircular *)c
{
    // 1.画圆
    CGContextAddEllipseInRect(_ctx, CGRectMake(c.x, c.y, c.w, c.h));
    // 2.渲染
    CGContextStrokePath(_ctx);
}

// 重绘-画矩形
- (void)drawRectangle:(DGRectangle *)r
{
    // 1.绘制四边形
    CGContextAddRect(_ctx, CGRectMake(r.x, r.y, r.w, r.h));
    // 2.渲染
    //    CGContextStrokePath(_ctx);//仅边框
    CGContextDrawPath(_ctx, kCGPathFillStroke);//包含边框和填充
}


// 清屏
- (void)clear
{
    [_paths removeAllObjects];
    [_lines removeAllObjects];
    [_circulars removeAllObjects];
    [_rectangles removeAllObjects];
    [_graphs removeAllObjects];
    [self setNeedsDisplay];
    // 移除所有subview
    for (UIView* v in self.subviews)
    {
        [v removeFromSuperview];
    }
}

// 撤销
- (void)back
{
    [_paths removeLastObject];
    [_lines removeLastObject];
    [_circulars removeLastObject];
    [_rectangles removeLastObject];
    [_graphs removeLastObject];
    [self setNeedsDisplay];
    //移除最新的subview
    [[self.subviews lastObject] removeFromSuperview];
}

@end
