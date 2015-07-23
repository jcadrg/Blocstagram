//
//  CircleSpinnerView.m
//  Blocstagram
//
//  Created by Mac on 7/21/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "CircleSpinnerView.h"

@interface  CircleSpinnerView()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation CircleSpinnerView


//setting a default value

-(id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.strokeThickness = 1;
        self.radius = 12;
        self.strokeColor = [UIColor purpleColor];
    }
    
    
    return self;
}


-(CGSize) sizeThatFits:(CGSize)size{
    return CGSizeMake((self.radius+self.strokeThickness/2+5)*2, (self.radius+self.strokeThickness/2+5)*2);
}




-(CAShapeLayer *) circleLayer{
    if (!_circleLayer) {
        CGPoint arcCenter = CGPointMake(self.radius + self.strokeThickness/2+5, self.radius+self.strokeThickness/2+5);
        CGRect rect = CGRectMake(0, 0, arcCenter.x*2, arcCenter.y*2);
        
        UIBezierPath * smoothedPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:self.radius startAngle:M_PI*3/2 endAngle:M_PI/2+M_PI*5 clockwise:YES];
        
        
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.contentsScale = [[UIScreen mainScreen] scale];
        _circleLayer.frame = rect;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = self.strokeColor.CGColor;
        _circleLayer.lineWidth = self.strokeThickness;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.lineJoin = kCALineJoinBevel;
        
        _circleLayer.path = smoothedPath.CGPath;//In this part we assign the circular path to the layer
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id) [[UIImage imageNamed:@"angle-mask" ] CGImage];
        maskLayer.frame =_circleLayer.bounds;
        _circleLayer.mask = maskLayer;
        
        CFTimeInterval animationDuration = 1;
        CAMediaTimingFunction *linearCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.fromValue = @0;
        animation.toValue = @(M_PI*2);
        animation.duration = animationDuration;
        animation.timingFunction = linearCurve;
        animation.repeatCount = INFINITY;
        animation.fillMode = kCAFillModeForwards;
        animation.autoreverses = NO;
        [_circleLayer.mask addAnimation:animation forKey:@"rotate"];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount= INFINITY;
        animationGroup.removedOnCompletion = NO;
        animationGroup.timingFunction = linearCurve;
        
        CABasicAnimation *strokeStartAnimation =[CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0.015;
        strokeStartAnimation.toValue = @0.515;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.485;
        strokeEndAnimation.toValue = @0.985;
        
        animationGroup.animations =@[strokeStartAnimation, strokeEndAnimation];
        [_circleLayer addAnimation:animationGroup forKey:@"progress"];
        
    }
    
    return _circleLayer;
}

//Positions the circle layer in the center of the view

-(void) layoutAnimatedLayer{
    [self.layer addSublayer:self.circleLayer];
    
    self.circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}


//when a subview is added, it reacts to willmovetosuperview, this method ensures that the positioning is accurate
//ASK
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview != nil) {
        [self layoutAnimatedLayer];
        
    }else{
        [self.circleLayer removeFromSuperlayer];
        self.circleLayer = nil;
    }
}


//Update the position of the layer if the frame changes

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if (self.superview != nil) {
        [self layoutAnimatedLayer];
    }
}

//if the radius changes, it will affect the positioning as well, this overriding recreates the circle layer
-(void) setRadius:(CGFloat)radius{
    _radius = radius;
    
    [_circleLayer removeFromSuperlayer];
    _circleLayer = nil;
    
    [self layoutAnimatedLayer];
}

//informing self.circlelayer if the other 2 properties changed
-(void) setStrokeColor:(UIColor *)strokeColor{
    _strokeColor = strokeColor;
    _circleLayer.strokeColor = strokeColor.CGColor;
    
}

-(void) setStrokeThickness:(CGFloat)strokeThickness{
    _strokeThickness = strokeThickness;
    _circleLayer.lineWidth = strokeThickness;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
