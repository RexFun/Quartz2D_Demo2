//
//  Quartz2DView.h
//  Quartz2D_Demo
//
//  Created by mac373 on 16/5/27.
//  Copyright © 2016年 ole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseDGView.h"

/* 画图类型 */
typedef NS_ENUM(uint, DrawType)
{
    T_PEN,
    T_LINE,
    T_CIRCULAR,
    T_RECT
};

/* 直线 */
@interface DGLine : NSObject
@property CGFloat begin_x;
@property CGFloat begin_y;
@property CGFloat end_x;
@property CGFloat end_y;
@end

/* 圆形 */
@interface DGCircular : BaseDGView
@property CGFloat x;
@property CGFloat y;
@property CGFloat w;
@property CGFloat h;
@end

/* 矩形 */
@interface DGRectangle : BaseDGView
@property NSInteger index;
@property CGFloat x;
@property CGFloat y;
@property CGFloat w;
@property CGFloat h;
@end

/* 画板 */
@interface DrawBoard : UIView
@property CGContextRef ctx;
@property DrawType drawType;                            //当前画图类型
@property (nonatomic,strong)NSMutableArray* paths;      //画笔路径数组
@property (nonatomic,strong)NSMutableArray* lines;      //直线数组
@property (nonatomic,strong)NSMutableArray* circulars;  //圆形数组
@property (nonatomic,strong)NSMutableArray* rectangles; //矩形数组
@property (nonatomic,strong)NSMutableArray* graphs;     //全部图形数组
@property DGLine* line;                                 //直线对象
@property DGCircular* circular;                         //圆形对象
@property DGRectangle* rectangle;                       //矩形对象

-(void)clear;
-(void)back;
@end
