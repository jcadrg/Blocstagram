//
//  MediaTableViewCell.m
//  Blocstagram
//
//  Created by Mac on 6/29/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "User.h"
#import "Comment.h"
#import "Media.h"

@interface MediaTableViewCell()

@property(nonatomic,strong) UIImageView *mediaImageView;
@property(nonatomic,strong) UILabel *usernameAndCaptionLabel;
@property(nonatomic,strong) UILabel *commentLabel;
@property (nonatomic,strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint *usernameAndCaptionLabelHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint *commentLabelHeightConstraint;

@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *userNameLabelGray;
static UIColor *commentLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;

@implementation MediaTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.mediaImageView=[[UIImageView alloc] init];
        self.usernameAndCaptionLabel =[[UILabel alloc] init];
        self.usernameAndCaptionLabel.numberOfLines = 0;
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        
        for (UIView *view in @[self.mediaImageView, self.usernameAndCaptionLabel, self.commentLabel]) {
            
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        
        }
        
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView,_usernameAndCaptionLabel,_commentLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]|" options:kNilOptions metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_usernameAndCaptionLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mediaImageView][_usernameAndCaptionLabel][_commentLabel]" options:kNilOptions metrics:nil views:viewDictionary]];
        
        self.imageHeightConstraint=[NSLayoutConstraint constraintWithItem:_mediaImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        self.usernameAndCaptionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_usernameAndCaptionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        self.commentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_commentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        
        [self.contentView addConstraints:@[self.imageHeightConstraint,self.usernameAndCaptionLabelHeightConstraint,self.commentLabelHeightConstraint]];
        
    }
    
    return self;
}

+(void) load{
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    userNameLabelGray =[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
    commentLabelGray =[UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1];
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1];
    
    NSMutableParagraphStyle *mutableParagraphStyle =[[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;
    
}


-(NSAttributedString *) usernameAndCaptionString{
    CGFloat usernameFontSize =15;
    
    //make string that says  "username caption text"
    NSString *baseString = [NSString stringWithFormat:@"%@ %@",self.mediaItem.user.userName, self.mediaItem.caption];
    
    NSMutableAttributedString *mutableUsernameAndCaptionString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName :[lightFont fontWithSize:usernameFontSize],NSParagraphStyleAttributeName:paragraphStyle}];
    
    //attributed string, with username bold
    
    NSRange usernameRange =[baseString rangeOfString:self.mediaItem.user.userName];
    [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:usernameRange];
    [mutableUsernameAndCaptionString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
    
    return mutableUsernameAndCaptionString;
    
}

-(NSAttributedString *) commentString{
    NSMutableAttributedString *commentString =[[NSMutableAttributedString alloc] init];
    for (Comment *comment in self.mediaItem.comments) {
        
        NSString *baseString =[NSString stringWithFormat:@"%@ %@\n",comment.from.userName, comment.text];
        
        //make an attribute string, with the "username" bold
        
        NSMutableAttributedString *oneCommentString =[[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName:lightFont, NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSRange userNameRange =[baseString rangeOfString:comment.from.userName];
        [oneCommentString addAttribute:NSFontAttributeName value:boldFont range:userNameRange];
        [oneCommentString addAttribute:NSForegroundColorAttributeName value:linkColor range:userNameRange];
        
        [commentString appendAttributedString:oneCommentString];
    
    }
    return commentString;
}

/*-(CGSize) sizeOfString:(NSAttributedString *) string{
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds)-40, 0.0);
    CGRect sizeRect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    sizeRect.size.height +=20;
    sizeRect = CGRectIntegral(sizeRect);
    
    return sizeRect.size;
}*/


-(void) layoutSubviews{
    
    [super layoutSubviews];
    
    /*CGFloat imageHeight = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
    self.mediaImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
    
    CGSize sizeOfUserNameAndCaptionLabel = [self sizeOfString:self.usernameAndCaptionLabel.attributedText];
    self.usernameAndCaptionLabel.frame =CGRectMake(0, CGRectGetMaxY(self.mediaImageView.frame),CGRectGetWidth(self.contentView.bounds), sizeOfUserNameAndCaptionLabel.height);
    
    CGSize sizeOfCommentLabel = [self sizeOfString:self.commentLabel.attributedText];
    self.commentLabel.frame = CGRectMake(0, CGRectGetMaxY(self.usernameAndCaptionLabel.frame), CGRectGetWidth(self.bounds), sizeOfCommentLabel.height);*/
    
    CGSize maxSize= CGSizeMake((CGRectGetWidth(self.bounds)), CGFLOAT_MAX);
    CGSize userNameLabelSize = [self.usernameAndCaptionLabel sizeThatFits:maxSize];
    CGSize commentLabelSize = [self.commentLabel sizeThatFits:maxSize];
    
    self.usernameAndCaptionLabelHeightConstraint.constant=userNameLabelSize.height + 20;
    self.commentLabelHeightConstraint.constant = commentLabelSize.height + 20;
    
    self.usernameAndCaptionLabel.backgroundColor=userNameLabelGray;
    self.commentLabel.backgroundColor=commentLabelGray;
    
    //hide the line between cells
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
}

-(void) setMediaItem:(Media *)mediaItem{
    _mediaItem = mediaItem;
    self.mediaImageView.image=_mediaItem.image;
    self.usernameAndCaptionLabel.attributedText = [self usernameAndCaptionString];
    self.commentLabel.attributedText = [self commentString];
    
    self.imageHeightConstraint.constant = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
}

+(CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width{
    //create a cell
    MediaTableViewCell *layoutCell = [[MediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    
    //set to given width and maximum possible height
    //layoutCell.frame = CGRectMake(0, 0, width, CGFLOAT_MAX);
    
    //give it the media item
    layoutCell.mediaItem =mediaItem;
    
    //make it adjust the image view and labels
    //[layoutCell layoutSubviews];
    
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    //the height will be  wherever the bottom of the comments labels
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    
    
    return CGRectGetMaxY(layoutCell.commentLabel.frame);
}

@end
