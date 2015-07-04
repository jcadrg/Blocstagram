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

@interface DataSource(){
    NSMutableArray * _mediaItems;
}

@property (nonatomic, strong) NSArray *mediaItems;


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

-(instancetype) init{
    self = [super init];
    
    if (self){
        [self addRandomData];
    }
    
    return self;
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

-(void) addRandomData{
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
}

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



@end
