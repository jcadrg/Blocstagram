//
//  MediaFullScreenViewController.m
//  Blocstagram
//
//  Created by Mac on 7/14/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MediaFullScreenViewController.h"
#import "Media.h"

@interface MediaFullScreenViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) Media *media;
@property(nonatomic, strong) UITapGestureRecognizer *tap;
@property(nonatomic,strong) UITapGestureRecognizer *doubleTap;

@end

@implementation MediaFullScreenViewController

-(instancetype) initWithMedia:(Media *)media{
    self = [super init];
    
    if (self) {
        self.media = media;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //#1
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    //#2
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.media.image;
    
    [self.scrollView addSubview:self.imageView];
    
    //#3
    self.scrollView.contentSize = self.media.image.size;
    
    self.tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    self.doubleTap.numberOfTapsRequired =2;
    
    
    //Allows the the single tap recognizer to wait for the double tap gesture recognizer to fail before it succeeds, without this line it would be impossible to double tap because the single tap gesture would fire all the time, before the user could have a chance.
    
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //#4
    self.scrollView.frame = self.view.bounds;
    
    //#5
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    CGFloat scaleWidth =scrollViewFrameSize.width / scrollViewContentSize.width;
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    CGFloat minScale = MIN(scaleWidth,scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1;
    
}
#pragma mark - UIScrollDelegate
//#6
-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

//#7
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centerScrollView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self centerScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) centerScrollView{
    [self.imageView sizeToFit];
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - CGRectGetWidth(contentsFrame))/2;
        
    }else{
        contentsFrame.origin.x =0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - CGRectGetHeight(contentsFrame))/2;
    }else{
        contentsFrame.origin.y=0;
    }
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - Gesture Recognizers

//when the user single-taps, dismiss the view controller

-(void) tapFired:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}

//When the user double taps, adjust the zoom level

-(void) doubleTapFired:(UITapGestureRecognizer *)sender{
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        //#8
        CGPoint locationPoint = [sender locationInView:self.imageView];
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        
        CGFloat x = locationPoint.x - (width / 2);
        CGFloat y = locationPoint.y - (height /2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
        
    }else{
        //#9
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
