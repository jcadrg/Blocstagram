//
//  MediaTableViewCell.m
//  Blocstagram
//
//  Created by Mac on 6/29/15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "Media.h"
#import "Comment.h"
#import "User.h"
#import "LikeButton.h"
#import "ComposeCommentView.h"


@interface MediaTableViewCell ()<UIGestureRecognizerDelegate,ComposeCommmentDelegate>

@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UILabel *usernameAndCaptionLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *usernameAndCaptionLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *commentLabelHeightConstraint;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, strong) LikeButton *likeButton;

@property (nonatomic, strong) ComposeCommentView *commentView;

@property (nonatomic, strong) NSArray *horizontallyRegularConstraints;
@property (nonatomic, strong) NSArray *horizontallyCompactConstraints;






@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *commentLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;


@implementation MediaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.mediaImageView = [[UIImageView alloc] init];
        self.mediaImageView.userInteractionEnabled = YES;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        self.tapGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.tapGestureRecognizer];
        
        self.longPressGestureRecognizer =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        self.longPressGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.longPressGestureRecognizer];
        
                                    
        
        self.usernameAndCaptionLabel = [[UILabel alloc] init];
        self.usernameAndCaptionLabel.numberOfLines = 0;
        self.usernameAndCaptionLabel.backgroundColor = usernameLabelGray;
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = commentLabelGray;
        
        self.likeButton = [[LikeButton alloc] init];
        [self.likeButton addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton.backgroundColor = usernameLabelGray;
        
        self.commentView = [[ComposeCommentView alloc] init];
        self.commentView.delegate = self;
        


        
        for(UIView *view in @[self.mediaImageView, self.usernameAndCaptionLabel, self.commentLabel, self.likeButton, self.commentView]) {
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _usernameAndCaptionLabel, _commentLabel, _likeButton, _commentView);
        
        //[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        
        self.horizontallyCompactConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]" options:kNilOptions metrics:nil views:viewDictionary];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:320];
        NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:_mediaImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        
        self.horizontallyRegularConstraints = @[widthConstraint, centerConstraint];
        
        if (self.traitCollection.horizontalSizeClass ==UIUserInterfaceSizeClassCompact) {
            //It's compact
            [self.contentView addConstraints:self.horizontallyCompactConstraints];
        
        }else if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
            //It's regular
            [self.contentView addConstraints:self.horizontallyRegularConstraints];
        }
        
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_usernameAndCaptionLabel][_likeButton(==38)]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentView]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mediaImageView][_usernameAndCaptionLabel][_commentLabel][_commentView(==100)]" options:kNilOptions metrics:nil views:viewDictionary]];
        
        self.imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:100];
        self.imageHeightConstraint.identifier = @"Image height constraint";
        
        self.usernameAndCaptionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_usernameAndCaptionLabel
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1
                                                                                     constant:100];
        self.usernameAndCaptionLabelHeightConstraint.identifier = @"Username and caption label height constraint";
        
        self.commentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_commentLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:100];
        self.usernameAndCaptionLabelHeightConstraint.identifier = @"Comment label height constraint";
        
        [self.contentView addConstraints:@[self.imageHeightConstraint, self.usernameAndCaptionLabelHeightConstraint, self.commentLabelHeightConstraint]];
    }
    return self;
}

+ (void) load {
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont  fontWithName:@"HelveticaNeue-Bold" size:11];
    
    usernameLabelGray = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];
    commentLabelGray  = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1];
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1];
    NSMutableParagraphStyle *mutableParagrapStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagrapStyle.headIndent = 20.0;
    mutableParagrapStyle.firstLineHeadIndent = 20.0;
    mutableParagrapStyle.tailIndent = -20.0;
    mutableParagrapStyle.paragraphSpacing = 5;
    
    paragraphStyle = mutableParagrapStyle;
}

+(CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width traitCollection:(UITraitCollection *)traitCollection {
    MediaTableViewCell *layoutCell = [[MediaTableViewCell alloc] init];
    
    layoutCell.mediaItem = mediaItem;
    
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    layoutCell.overrideTraitCollection = traitCollection;
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    return CGRectGetMaxY(layoutCell.commentView.frame);
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize usernameLabelSize = [self.usernameAndCaptionLabel sizeThatFits:maxSize];
    CGSize commentLabelSize  = [self.commentLabel sizeThatFits:maxSize];
    
    self.usernameAndCaptionLabelHeightConstraint.constant = usernameLabelSize.height == 0 ? 0 : usernameLabelSize.height + 20;
    self.commentLabelHeightConstraint.constant = commentLabelSize.height == 0 ? 0 : commentLabelSize.height + 20;
    if (self.mediaItem.image.size.width > 0 && CGRectGetWidth(self.contentView.bounds) > 0) {
        //self.imageHeightConstraint.constant = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
        
        //Updating the image height appropiately
        if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            //It's compact
            self.imageHeightConstraint.constant = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
            
        }else if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
            //It's regular
            self.imageHeightConstraint.constant = 320;
        }
        
        
    } else {
        self.imageHeightConstraint.constant = 0;
    }
    
    self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.bounds)/2.0, 0, CGRectGetWidth(self.bounds)/2.0);
}

- (NSMutableAttributedString *) usernameAndCaptionString {
    CGFloat usernameFontSize = 15;
    NSString *baseString = [NSString stringWithFormat:@"%@ %@", self.mediaItem.user.userName, self.mediaItem.caption];
    
    NSMutableAttributedString *mutableUsernameAndCaptionString = [[NSMutableAttributedString alloc] initWithString:baseString
                                                                                                        attributes:@{NSFontAttributeName : [lightFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    NSRange usernameRange = [baseString rangeOfString:self.mediaItem.user.userName];
    [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:usernameRange];
    [mutableUsernameAndCaptionString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
    
    return mutableUsernameAndCaptionString;
}

- (NSMutableAttributedString *) commentString {
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    
    for (Comment *comment in self.mediaItem.comments) {
        NSString *baseString = [NSString stringWithFormat:@"%@ %@\n", comment.from.userName, comment.text];
        
        NSMutableAttributedString *oneCommenString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSRange usernameRange = [baseString rangeOfString:comment.from.userName];
        
        [oneCommenString addAttribute:NSFontAttributeName value:boldFont range:usernameRange];
        [oneCommenString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
        
        [commentString appendAttributedString:oneCommenString];
    }
    
    return commentString;
}

- (void) setMediaItem:(Media *)mediaItem {
    _mediaItem = mediaItem;
    self.mediaImageView.image = _mediaItem.image;
    self.usernameAndCaptionLabel.attributedText = [self usernameAndCaptionString];
    self.commentLabel.attributedText = [self commentString];
    self.likeButton.likeButtonState = mediaItem.likeState;
    
    //When the table cell is created or reused, update the text on the comment view
    self.commentView.text = mediaItem.temporaryComment;
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

#pragma mark - Image View

-(void) tapFired:(UIGestureRecognizer *) sender{
    [self.delegate cell:self didTapImageView:self.mediaImageView];
}

-(void) longPressFired:(UIGestureRecognizer *) sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.delegate cell:self didLongPressImageView:self.mediaImageView];
    }
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.isEditing == NO;
}

#pragma mark - Liking

//informing the delegate that the like button was pressed
-(void) likePressed:(UIButton *)sender{
    [self.delegate cellDidPressLikeButton:self];
}

#pragma mark - ComposeCommenViewDelegate

-(void) commentViewDidPressCommentButton:(ComposeCommentView *)sender{
    [self.delegate cell:self didComposeComment:self.mediaItem.temporaryComment];
}

-(void) commentView:(ComposeCommentView *)sender textDidChange:(NSString *)text{
    self.mediaItem.temporaryComment = text;
}

-(void) commentViewWillStartEditing:(ComposeCommentView *)sender{
    [self.delegate cellWillStartComposingComment:self];
}

-(void) stopComposingComment{
    [self.commentView stopComposingComment];
}


//Update the constraints in case the user rotates the device
-(void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        
        [self.contentView removeConstraints:self.horizontallyRegularConstraints];
        [self.contentView addConstraints:self.horizontallyCompactConstraints];
    
    }else if(self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular){
        
        [self.contentView removeConstraints:self.horizontallyCompactConstraints];
        [self.contentView addConstraints:self.horizontallyRegularConstraints];
    }
    
}

-(UITraitCollection *) traitCollection{
    if (self.overrideTraitCollection) {
        return self.overrideTraitCollection;
    }
    
    return [super traitCollection];
}


@end