//
//  CameraViewController.m
//  Blocstagram
//
//  Created by Mac on 7/26/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CameraToolBar.h"
#import "UIImage+ImageUtilities.h"
#import "CropBox.h"
#import "ImageLibraryViewController.h"

@interface CameraViewController ()<CameraToolBarDelegate, ImageLibraryViewControllerDelegate>

@property(nonatomic, strong) UIView *imagePreview;

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

/*@property(nonatomic, strong) NSArray *horizontalLines;
@property(nonatomic, strong) NSArray *verticalLines;*/

@property(nonatomic, strong) UIToolbar *topView;
@property(nonatomic, strong) UIToolbar *bottomView;

@property (nonatomic, strong) CropBox *cropBox;
@property(nonatomic, strong) CameraToolBar *cameraToolBar;
@end

@implementation CameraViewController

#pragma mark - Build the View Hierarchy

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    [self addViewsToViewHierarchy];
    [self setupImageCapture];
    [self createCancelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void) createViews{
    self.imagePreview = [UIView new];
    
    self.topView = [UIToolbar new];
    self.bottomView = [UIToolbar new];
    
    self.cropBox = [CropBox new];
    
    
    
    self.cameraToolBar =[[CameraToolBar alloc] initWithImageNames:@[@"rotate",@"road"]];

    self.cameraToolBar.delegate=self;
    
    UIColor *whiteBG = [UIColor colorWithWhite:1.0 alpha:.15];
    self.topView.barTintColor = whiteBG;
    self.bottomView.barTintColor = whiteBG;
    self.topView.alpha = 0.5;
    self.bottomView.alpha = 0.5;
}

-(void) addViewsToViewHierarchy{
    NSMutableArray *views =[@[self.imagePreview, self.topView, self.bottomView,self.cropBox] mutableCopy];
    
    /*[views addObjectsFromArray:self.horizontalLines];
    [views addObjectsFromArray:self.verticalLines];*/
    [views addObject:self.cameraToolBar];
    
    for (UIView *view in views) {
        [self.view addSubview:view];
    }
}

-(void) setupImageCapture{
    //#1
    self.session =[[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    //#2
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.masksToBounds = YES;
    [self.imagePreview.layer addSublayer:self.captureVideoPreviewLayer];
    
    //#3
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
        dispatch_async(dispatch_get_main_queue(), ^{
            //#4
            if(granted){
                //#5
                AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                
                //#6
                NSError *error = nil;
                AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                
                //this block of code represents that the camera hast been found.
                if(!input){
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
                    [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK button") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                        [self.delegate cameraViewController:self didCompletewithImage:nil];
                        
                    }]];
                    
                    [self presentViewController:alertVC animated:YES completion:nil];
                
                }else{
                    //#7
                    
                    [self.session addInput:input];
                    
                    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
                    self.stillImageOutput.outputSettings =@{AVVideoCodecKey: AVVideoCodecJPEG};
                    
                    [self.session addOutput:self.stillImageOutput];
                    
                    [self.session startRunning];
                }
            }else{
                UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"Camera Permission Denied", @"camera permission denied title") message:NSLocalizedString(@"This app doesen't have permission to use the camera; please update your privacy settings", @"camera permission denied recovery suggestion") preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Button") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                    [self.delegate cameraViewController:self didCompletewithImage:nil];
                }]];
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        });
    }];

    
}

-(void) createCancelButton{
    UIImage *cancelImage = [UIImage imageNamed:@"x"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark - Event Handling

-(void) cancelPressed:(UIBarButtonItem *) sender{
    [self.delegate cameraViewController:self didCompletewithImage:nil];
}

#pragma mark - Layout
//Layout the photo area into a 3x3 grid of squares
-(void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.topView.frame = CGRectMake(0, self.topLayoutGuide.length, width, 44);
    
    CGFloat yOriginOfBottomView = CGRectGetMaxY(self.topView.frame) + width;
    CGFloat heightOfBottomView = CGRectGetHeight(self.view.frame) - yOriginOfBottomView;
    self.bottomView.frame = CGRectMake(0, yOriginOfBottomView, width, heightOfBottomView);
    
    /*CGFloat thirdOfWidth = width/3;
    
    for (int i=0; i < 4; i++) {
        UIView *horizontalLine = self.horizontalLines[i];
        UIView *verticalLine = self.verticalLines[i];
        
        horizontalLine.frame = CGRectMake(0, (i * thirdOfWidth) + CGRectGetMaxY(self.topView.frame), width, 0.5);
        
        CGRect verticalFrame = CGRectMake( i * thirdOfWidth, CGRectGetMaxY(self.topView.frame), 0.5, width);
        
        if (i == 3) {
            verticalFrame.origin.x -= 0.5;
        }
        
        verticalLine.frame = verticalFrame;
    }*/
    
    self.cropBox.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), width, width);
    
    self.imagePreview.frame = self.view.bounds;
    self.captureVideoPreviewLayer.frame= self.imagePreview.bounds;
    
    CGFloat cameraToolBarHeight = 100;
    self.cameraToolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - cameraToolBarHeight, width, cameraToolBarHeight);
}

#pragma mark - CameraToolBarDelegate


//flips between the front and rear cameras
-(void) leftButtonPressedOnToolBar:(CameraToolBar *) toolbar{
    AVCaptureDeviceInput *currentCameraInput = self.session.inputs.firstObject;
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    //if aanother device is found besides the front and rear cameras (devices.count>1), we try tro create an input for it. If the input succeeds, we make a nice dissolve effect
    if (devices.count >1) {
        NSUInteger currentIndex = [devices indexOfObject:currentCameraInput.device];
        NSUInteger newIndex =0;
        
        if (currentIndex < devices.count -1) {
            newIndex = currentIndex + 1;
        }
        
        AVCaptureDevice *newCamera = devices[newIndex];
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
        
        if (newVideoInput) {
            UIView *fakeView = [self.imagePreview snapshotViewAfterScreenUpdates:YES];
            fakeView.frame = self.imagePreview.frame;
            [self.view insertSubview:fakeView aboveSubview:self.imagePreview];
            
            [self.session beginConfiguration];
            [self.session removeInput:currentCameraInput];
            [self.session addInput:newVideoInput];
            [self.session commitConfiguration];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                fakeView.alpha = 0;
            }completion:^(BOOL finished){
                [fakeView removeFromSuperview];
            }];
        }
    }
}
//right camera toolbar will open a different view to allow the user to select a photo from their library
-(void) rightButtonPressedOnToolBar:(CameraToolBar *) toolbar{
    //NSLog(@"Photo library button pressed.");
    ImageLibraryViewController *imageLibraryVC = [[ImageLibraryViewController alloc]init];
    imageLibraryVC.delegate = self;
    [self.navigationController pushViewController:imageLibraryVC animated:YES];
}

-(void) cameraButtonPressedOnToolBar:(CameraToolBar *)toolbar{
    AVCaptureConnection *videoConnection;
    
    //#8
    //Find the right connection object
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts) {
            if ([port.mediaType isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    //#9 Connection is passed to the output object, and returns the image  in a completion block
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error){
        if (imageSampleBuffer) {
            //#10
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
            
            //#11
            image = [image imageWithFixedOrientation];
            image = [image imageResizedToMatchAspectRatioOfSize:self.captureVideoPreviewLayer.bounds.size];
            
            //#12
            /*UIView *leftLine = self.verticalLines.firstObject;
            UIView *rightLine = self.verticalLines.lastObject;
            UIView *topLine = self.horizontalLines.firstObject;
            UIView *bottomLine = self.horizontalLines.lastObject;
            
            CGRect gridRect = CGRectMake(CGRectGetMinX(leftLine.frame),
                                         CGRectGetMinY(topLine.frame),
                                         CGRectGetMaxX(rightLine.frame) - CGRectGetMinX(leftLine.frame),
                                         CGRectGetMinY(bottomLine.frame) - CGRectGetMinY(topLine.frame));*/
            
            CGRect gridRect = self.cropBox.frame;
            
            CGRect cropRect = gridRect;
            cropRect.origin.x = (CGRectGetMinX(gridRect) +(image.size.width - CGRectGetWidth(gridRect))/2);
            
            image = [image imageCroppedToRect:cropRect];
            
            //#13
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate cameraViewController:self didCompletewithImage:image];
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Button") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                    [self.delegate cameraViewController:self didCompletewithImage:nil];
                }]];
                
                [self presentViewController:alertVC animated:YES completion:nil];
            });
        }
    }];

}

#pragma mark - ImageLibraryViewControllerDelegate

//When the image library controller hands an image back, pass it to the camera controller's delegate:

-(void) imageLibraryViewController:(ImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image{
    [self.delegate cameraViewController:self didCompletewithImage:image];
}

//Responding to Toolbar Button Taps
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
