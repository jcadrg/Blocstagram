//
//  ComposeCommentView.h
//  Blocstagram
//
//  Created by Mac on 7/23/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposeCommentView;

@protocol ComposeCommmentDelegate <NSObject>

-(void) commentViewDidPressCommentButton:(ComposeCommentView *)sender;
-(void) commentView:(ComposeCommentView *) sender textDidChange:(NSString *) text;
-(void) commentViewWillStartEditing:(ComposeCommentView *)sender;

@end

@interface ComposeCommentView : UIView

@property (nonatomic, weak) NSObject <ComposeCommmentDelegate> *delegate;
@property (nonatomic, assign) BOOL isWritingComment;
@property (nonatomic, strong) NSString *text;

-(void) stopComposingComment;

@end
