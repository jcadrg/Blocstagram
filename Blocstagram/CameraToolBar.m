//
//  CameraToolBar.m
//  Blocstagram
//
//  Created by Mac on 7/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "CameraToolBar.h"

@interface CameraToolBar()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *cameraButton;
@property(nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *purpleView;


@end

@implementation CameraToolBar

-(instancetype) initWithImageNames:(NSArray *)imageNames{
    self = [super init];
    
    if (self) {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.leftButton setImage:[UIImage imageNamed:imageNames.firstObject] forState:UIControlStateNormal];
        
        [self.rightButton setImage:[UIImage imageNamed:imageNames.lastObject] forState:UIControlStateNormal];
        
        [self.cameraButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [self.cameraButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 15, 10)];
        
        self.whiteView = [[UIView alloc]init];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        
        self.purpleView =[[UIView alloc] init];
        self.purpleView.backgroundColor = [UIColor colorWithRed:0.345 green:0.318 blue:0.424 alpha:1];
        
        for (UIView *view in @[self.whiteView, self.purpleView, self.leftButton, self.cameraButton, self.rightButton]) {
            [self addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        [self createConstraints];
        
    }
    
    
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.purpleView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.purpleView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.purpleView.layer.mask = maskLayer;
}

-(void) createConstraints{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_leftButton,_cameraButton,_rightButton,_whiteView,_purpleView);
    
    //The three buttons have equal width and are distributed across the whole view
    NSArray *allButtonHorizaontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftButton][_cameraButton(==_leftButton)][_rightButton(==_leftButton)]|" options:kNilOptions metrics:nil views:viewDictionary];
    
    //The left and right buttons have 10 points spacing from the top. All three buttons are aligned with the bottom of the view.
    NSArray *leftButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_leftButton]|" options:kNilOptions metrics:nil views:viewDictionary];
    NSArray *cameraButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraButton]|" options:kNilOptions metrics:nil views:viewDictionary];
    NSArray *rightButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_rightButton]" options:kNilOptions metrics:nil views:viewDictionary];
    
    //The white view goes behind all the buttons, 10 points from the top.
    NSArray *whiteViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_whiteView]|" options:kNilOptions metrics:nil views:viewDictionary];
    NSArray *whiteViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_purpleView]|" options:kNilOptions metrics:nil views:viewDictionary];
    
    //The purple view is positioned identically to the camera button
    NSArray *purpleViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[_leftButton][_purpleView][_rightButton]" options:NSLayoutFormatAlignAllBottom metrics:nil views:viewDictionary];
    NSArray *purpleViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_purpleView]" options:kNilOptions metrics:nil views:viewDictionary];
    
    NSArray *allConstraintArrays = @[allButtonHorizaontalConstraints, leftButtonVerticalConstraints, cameraButtonVerticalConstraints, rightButtonVerticalConstraints, whiteViewHorizontalConstraints, whiteViewVerticalConstraints, purpleViewHorizontalConstraints, purpleViewVerticalConstraints];
    
    for (NSArray *constraintArray in allConstraintArrays) {
        for(NSLayoutConstraint *constraint in constraintArray){
            [self addConstraint:constraint];
        }
    }
}

#pragma mark - buttons Handlers

-(void) leftButtonPressed:(UIButton *)sender{
    [self.delegate leftButtonPressedOnToolBar:self];
}

-(void) rightButtonPressed:(UIButton *) sender{
    [self.delegate rightButtonPressedOnToolBar:self];
}

-(void) cameraButtonPressed:(UIButton *) sender{
    [self.delegate cameraButtonPressedOnToolBar:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
