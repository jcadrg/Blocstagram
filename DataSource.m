//
//  DataSource.m
//  Blocstagram
//
//  Created by Mac on 6/25/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "DataSource.h"
#import "Comment.h"
#import "Media.h"
#import "User.h"
#import "LoginViewController.h"

@interface DataSource(){
    NSMutableArray * _mediaItems;
}

@property (nonatomic, strong) NSArray *mediaItems;

@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,assign) BOOL isLoadingOlderItems;

@property (nonatomic, strong) NSString *accessToken;

@end

@implementation DataSource


+(instancetype) sharedInstance{
    static dispatch_once_t once;
    static id  sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance =[[self alloc] init];
    });
    return sharedInstance;
}

+ (NSString *) instagramClientId {
    return @"006100f5d8224c1dab869b057f2b8994";
}




-(instancetype) init{
    self = [super init];
    
    if (self){
        //[self addRandomData];
        
        [self registerForAccessTokenNotification];
    }
    
    return self;
}

- (void) registerForAccessTokenNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:LoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.accessToken = note.object;
        
        [self populateDataWithParameters:nil];
    }];
}

-(void) removeMediaItemsAtIndex:(NSUInteger)index{
    NSMutableArray *randomMediaItems = [NSMutableArray arrayWithArray:self.mediaItems];
    [randomMediaItems removeObjectAtIndex:index];
    self.mediaItems = randomMediaItems;
    
}

/*-(void) addOneMediaItem{
    NSMutableArray *randomMediaItems = [NSMutableArray array];
    NSString *imageName = [NSString stringWithFormat:@"%d.jpg",5];
    UIImage *image =[UIImage imageNamed:imageName];
    Media *media =[[Media alloc]init];
    
    if (image) {
        media.user = [self randomUser];
        media.image = image;
        
        NSUInteger commentCount = arc4random_uniform(10);
        NSMutableArray *randomComments = [NSMutableArray array];
        for (int i=0; i<=commentCount; i++) {
            Comment *randomComment =[self randomComment];
            [randomComments addObject:randomComment];
        }
        
        media.comments = randomComments;
    }
    
    [randomMediaItems addObject:media];
    self.mediaItems = randomMediaItems;
    
}*/

/*-(void) addRandomData{
    NSMutableArray *randomMediaItems = [NSMutableArray array];
    
    for (int i=0; i<=10; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *image =[UIImage imageNamed:imageName];
        
        if (image) {
            Media *media =[[Media alloc]init];
            media.user =[self randomUser];
            media.image = image;
            media.caption = [self randomCaption];
            
            
            NSUInteger commentCount = arc4random_uniform(10);
            NSMutableArray *randomComments =[NSMutableArray array];
            
            for (int i=0; i<= commentCount; i++) {
                Comment *randomCommment = [self randomComment];
                [randomComments addObject:randomCommment];
            }
            
            media.comments = randomComments;
            
            [randomMediaItems addObject:media];
        }
    }
    
    self.mediaItems =randomMediaItems;
}

-(User *) randomUser{
    User *user = [[User alloc] init];
    user.userName =[self randomStringOfLength:arc4random_uniform(10)];
    
    NSString *firstName = [self randomStringOfLength:arc4random_uniform(7)];
    NSString *lastName = [self randomStringOfLength:arc4random_uniform(12)];
    
    
    user.fullName = [NSString stringWithFormat:@"%@ %@", firstName,lastName];
    
    return user;
}




-(Comment *) randomComment{
    Comment *comment = [[Comment alloc] init];
    
    comment.from =[self randomUser];
    
    NSUInteger wordCount = arc4random_uniform(20);
    
    NSMutableString *randomSentence =[[NSMutableString alloc] init];
    
    for (int i = 0; i <= wordCount; i++){
        NSString *randomWord = [self randomStringOfLength:arc4random_uniform(12)];
        [randomSentence appendFormat:@"%@",randomWord];
        
    }
    
    comment.text =randomSentence;
    
    return comment;
    
}


-(NSString *) randomCaption{
    
    NSUInteger wordCount = arc4random_uniform(10);
    
    NSMutableString *randomSentence =[[NSMutableString alloc] init];
    
    for (int i = 0; i <= wordCount; i++){
        NSString *randomWord = [self randomStringOfLength:arc4random_uniform(7)];
        [randomSentence appendFormat:@"%@",randomWord];
        
    }
    return randomSentence;
}

-(NSString *) randomStringOfLength:(NSUInteger) len{
    
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    
    NSMutableString *s = [NSMutableString string];
    
    for (NSUInteger i=0U; i < len; i++) {
        u_int32_t r = arc4random_uniform((u_int32_t)[alphabet length]);
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C",c];
        
    }
    
    return [NSString stringWithString:s];
}*/

#pragma mark - key/value observing

-(NSUInteger) countOfMediaItems{
    return self.mediaItems.count;
}

-(id) objectInMediaItemsAtIndex:(NSUInteger)index{
    return [self.mediaItems objectAtIndex:index];
    

}

-(NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes{
    return [self.mediaItems objectsAtIndexes:indexes];
}
//In here, _mediaItems is used because mediaItems is declared as readonly, and _mediaItems (IVAR) is declared as modifiable
-(void) insertObject:(Media *)object inMediaItemsAtIndex:(NSUInteger)index{
    [_mediaItems insertObject:object atIndex:index];
    
}

-(void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index{
    [_mediaItems removeObjectAtIndex:index];
}

-(void) replaceMediaItemsAtIndex:(NSUInteger)index withObject:(id) object{
    [_mediaItems replaceObjectAtIndex:index withObject:object];
}

#pragma mark delete an item from the data source

-(void) deleteMediaItem:(Media *)item{
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
                                           
}

-(void) requestNewItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler{
    if(self.isRefreshing==NO){
        self.isRefreshing = YES;
        
        /*NSInteger randomNumber = arc4random_uniform(10);
        
        Media *media =[[Media alloc]init];
        media.user = [self randomUser];
        media.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)randomNumber]];
        //media.caption = [self randomStringOfLength:randomNumber];
        media.caption = [self randomCaption];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
        [mutableArrayWithKVO insertObject:media atIndex:0];*/
        
        self.isRefreshing= NO;
        
        if(completionHandler){
            completionHandler(nil);
        }
        
    }
}

-(void) requestOldItemsWithCompletionHandler:(NewItemCompletionBlock)completionHandler{
    if (self.isLoadingOlderItems == NO) {
        self.isLoadingOlderItems = YES;
        
        
        /*NSInteger randomNumber = arc4random_uniform(10);
        
        Media *media = [[Media alloc] init];
        
        media.user = [self randomUser];
        media.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long) randomNumber]];
        //media.caption = [self randomStringOfLength:randomNumber];
        media.caption = [self randomCaption];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
        [mutableArrayWithKVO addObject:media];*/
        
        self.isLoadingOlderItems = NO;
        
        if(completionHandler){
            completionHandler(nil);
        }
    }
}
- (void) populateDataWithParameters:(NSDictionary *)parameters {
    if (self.accessToken) {
        // only try to get the data if there's an access token
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // do the network request in the background, so the UI doesn't lock up
            
            NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", self.accessToken];
            
            for (NSString *parameterName in parameters) {
                // for example, if dictionary contains {count: 50}, append `&count=50` to the URL
                [urlString appendFormat:@"&%@=%@", parameterName, parameters[parameterName]];
            }
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            if (url) {
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                NSURLResponse *response;
                NSError *webError;
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&webError];
                
                if (responseData) {
                    NSError *jsonError;
                    NSDictionary *feedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
                    
                    if (feedDictionary) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // done networking, go back on the main thread
                            [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];
                        });
                    }
                }
            }
        });
    }
}

- (void) parseDataFromFeedDictionary:(NSDictionary *) feedDictionary fromRequestWithParameters:(NSDictionary *)parameters {
    NSLog(@"%@", feedDictionary);
}



@end
