//
//  ImagesTableViewController.m
//  Blocstagram
//
//  Created by Mac on 6/24/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "ImagesTableViewController.h"
#import "User.h"
#import "Media.h"
#import "Comment.h"
#import "DataSource.h"
#import "MediaTableViewCell.h"

@interface ImagesTableViewController ()

@end

@implementation ImagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*for (int i = 1; i<=10; i++) {
        NSString *imageName =[NSString stringWithFormat:@"%d.jpg",i];
        UIImage *image =[UIImage imageNamed:imageName];
        if (image) {
            [self.images addObject:image];
        }
    }*/
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"imageCell"];
    
    //class added as an oberserver
    [[DataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.tableView registerClass:[MediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.images.count;

    //return [DataSource sharedInstance].mediaItems.count;
    return [self items].count;
}

-(id) initWithStyle:(UITableViewStyle)style{

    
    self = [super initWithStyle:style];
    if (self) {
        //custom initialization
        //self.images =[NSMutableArray array];
    }
    
    return self;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
    
    static NSInteger imageViewTag = 1234;
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageViewTag];
    
    if(!imageView){
        //cell with no image yet!!
        imageView =[[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.frame = cell.contentView.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        imageView.tag = imageViewTag;
        [cell.contentView addSubview:imageView];
    
        
    }
    
    //UIImage * image = self.images[indexPath.row];
    //imageView.image = image;
    
    Media *item = [self items][indexPath.row];
    imageView.image =item.image;*/
 
    MediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.mediaItem =[self items][indexPath.row];

    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UIImage *image =self.images[indexPath.row];
    Media *item = [self items][indexPath.row];
    //UIImage *image=item.image;
    //return (CGRectGetWidth(self.view.frame) / image.size.width) * image.size.height;
    //return 300 +(image.size.height /image.size.width * CGRectGetWidth(self.view.frame));
    return [MediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}


// Override to support conditional editing of the table view.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        //[self.images removeObjectAtIndex:indexPath.row];
        
        Media *item = [self items][indexPath.row];
        [[DataSource sharedInstance] deleteMediaItem:item];
        
        /*[[DataSource sharedInstance] removeMediaItemsAtIndex:(NSUInteger)indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];*/

 
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSArray *) items{
    return [DataSource sharedInstance].mediaItems;

}

//When a class gets added as an observer, it also must be set to auto remove itself as an observer later
-(void) dealloc{
    [[DataSource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
}
#pragma mark handling key value Notifications

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    //Checks if the update is coming from the registered object and mediaItems the updated key
    if (object == [DataSource sharedInstance] && [keyPath isEqualToString:@"mediaItems"]) {
        
        //mediaItems changed. This checks what kind of change it is.
        int kindOfChange =[change[NSKeyValueChangeKindKey] intValue];
        
        if(kindOfChange == NSKeyValueChangeSetting){
            
            //this means a new set of images array
            [self.tableView reloadData];
            
            
            
        }else if(kindOfChange == NSKeyValueChangeInsertion || kindOfChange == NSKeyValueChangeRemoval || kindOfChange == NSKeyValueChangeReplacement){
            
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            
            // Convert this NSIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require)
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx,BOOL *stop){
                NSIndexPath *newIndexPath =[NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            // Call `beginUpdates` to tell the table view we're about to make changes
            [self.tableView beginUpdates];
            
            //Tell the table view what the changes are
            
            if (kindOfChange == NSKeyValueChangeInsertion) {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            
            }else if(kindOfChange == NSKeyValueChangeRemoval){
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }else if(kindOfChange == NSKeyValueChangeReplacement){
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            //Tell the table view that we're done telling it about changes, and to complete the animation
            [self.tableView endUpdates];
        }
    }
    
}

-(void) refreshControlDidFire:(UIRefreshControl *) sender{
    [[DataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error){
        [sender endRefreshing];
    }];
}

-(void) infiniteScrollIfNecessary{
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    
    if(bottomIndexPath && bottomIndexPath.row == [DataSource sharedInstance].mediaItems.count - 1){
        
        [[DataSource sharedInstance] requestOldItemsWithCompletionHandler:nil];
        
    }
}

#pragma mark - UIScrollViewDelegate

/*-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [self infiniteScrollIfNecessary];
}*/

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self infiniteScrollIfNecessary];
}



/*-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:YES animated:YES];

    
}*/



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
