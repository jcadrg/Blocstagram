//
//  ImageLibraryViewController.m
//  Blocstagram
//
//  Created by Mac on 7/29/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ImageLibraryViewController.h"
#import "CropImageViewController.h"
#import <Photos/Photos.h>

@interface ImageLibraryViewController() <CropImageViewControllerDelegate>

@property (nonatomic,strong) PHFetchResult *result;
@end

@implementation ImageLibraryViewController


//in the initializer we will create this layout and assign an item size
//UICollectionViewFlowLayout organizes items into a grid with an optional header and footer views for each section
-(instancetype) init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    
    return [super initWithCollectionViewLayout:layout];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIImage *cancelImage = [UIImage imageNamed:@"x"];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

-(void) cancelPressed:(UIBarButtonItem *) sender{
    [self.delegate imageLibraryViewController:self didCompleteWithImage:nil];
}


//calculate the size of each cell conforming the collectionViewLayout, with no spacing between cells.
-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat minWidth = 100;
    NSInteger divisor = width / minWidth;
    CGFloat cellSize = width / divisor;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(cellSize, cellSize);
    flowLayout.minimumInteritemSpacing =0;
    flowLayout.minimumLineSpacing =0;
}


//Picture Loading
-(void) loadAssets{
    
    //PHFetchOptions describes different options when retrieving an image, we are choosing to sort them by date of creation
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"CreationDate" ascending:YES]];
    
    self.result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
}

//we ask wether the user has already granted access to their photo library, if not, request authorization, after obtaining it, load the assets, and reload collection view on the main thread
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
                    dispatch_sync(dispatch_get_main_queue(),^{
                        [self loadAssets];
                        [self.collectionView reloadData];
                    });
            }
        }];
    
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        [self loadAssets];
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.result.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSInteger imageViewTag = 54321;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageViewTag];
    
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag =imageViewTag;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
    }
    
    if(cell.tag !=0){
        
        [[PHImageManager defaultManager] cancelImageRequest:(PHImageRequestID) cell.tag];
        
    }
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    PHAsset *asset = self.result[indexPath.row];
    
    cell.tag = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:flowLayout.itemSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info){
        UICollectionViewCell *cellToUpdate =[collectionView cellForItemAtIndexPath:indexPath];
        
        if (cellToUpdate) {
            UIImageView *imageView = (UIImageView *)[cellToUpdate.contentView viewWithTag:imageViewTag];
            imageView.image = result;
        }
    }];
    
    return cell;
    
}

//ask
//User taps a thumbnail, get the full resolution image and pass it  to the crop controller

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset =self.result[indexPath.row];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode= PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *resultImage, NSDictionary *info){
        
        CropImageViewController *cropVC = [[CropImageViewController alloc] initWithImage:resultImage];
        cropVC.delegate = self;
        [self.navigationController pushViewController:cropVC animated:YES];
    
    }];
}

#pragma mark - CropImageViewControllerDelegate

-(void) cropControllerFinishedWithImage:(UIImage *)croppedImage{
    [self.delegate imageLibraryViewController:self didCompleteWithImage:croppedImage];
}




@end
