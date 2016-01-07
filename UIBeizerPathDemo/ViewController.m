//
//  ViewController.m
//  UIBeizerPathDemo
//
//  Created by 张雪东 on 16/1/7.
//  Copyright © 2016年 张雪东. All rights reserved.
//

#import "ViewController.h"

#define KSCREENSIZE ([UIScreen mainScreen].bounds.size)
#define MINCNTROLHEIGHT 100
@interface ViewController ()

@property (nonatomic,assign) CGFloat controlX;
@property (nonatomic,assign) CGFloat controlY;
@property (nonatomic,strong) UIView *controlView;

@property (nonatomic,assign) CGPoint prePoint;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) CADisplayLink *displayLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    _shapeLayer = shapeLayer;
    [self.view.layer addSublayer:shapeLayer];
    
    [self configControlPoint];
 
    [self configDisplayLink];
}

-(void)configControlPoint{

    _controlX = KSCREENSIZE.width / 2;
    _controlY = MINCNTROLHEIGHT;
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(_controlX, _controlY, 3, 3)];
    _controlView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_controlView];
}

-(void)configDisplayLink{

    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculatePath)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink = displayLink;
}

- (void)calculatePath{
    
    CALayer *layer = _controlView.layer.presentationLayer;
    _controlX = layer.position.x;
    _controlY = layer.position.y;
    [self updateShapeLayerPath];
}

-(void)updateShapeLayerPath {
    
    UIBezierPath *tPath = [UIBezierPath bezierPath];
    [tPath moveToPoint:CGPointZero];
    [tPath addLineToPoint:CGPointMake(KSCREENSIZE.width, 0)];
    [tPath addLineToPoint:CGPointMake(KSCREENSIZE.width, MINCNTROLHEIGHT)];
    [tPath addQuadCurveToPoint:CGPointMake(0, MINCNTROLHEIGHT) controlPoint:CGPointMake(_controlX, _controlY)];
    [tPath closePath];
    _shapeLayer.path = tPath.CGPath;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self configDisplayLink];
    UITouch *touch = [touches anyObject];
    _prePoint = [touch locationInView:self.view];
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        
        _controlX = KSCREENSIZE.width / 2 + currentPoint.x - _prePoint.x;
        _controlY = MINCNTROLHEIGHT + currentPoint.y - _prePoint.y;
        
        _controlView.frame = CGRectMake(_controlX, _controlY, 3, 3);
        [self updateShapeLayerPath];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _controlView.frame = CGRectMake(KSCREENSIZE.width / 2, MINCNTROLHEIGHT, 3, 3);
    } completion:^(BOOL finished) {
        [_displayLink invalidate];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
