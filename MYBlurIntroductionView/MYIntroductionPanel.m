//
//  MYIntroductionPanel.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYIntroductionPanel.h"

@implementation MYIntroductionPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
        
        self.PanelTitle = title;
        self.PanelDescription = description;
        [self buildPanelWithFrame:frame];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description header:(UIView *)headerView{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
        self.PanelHeaderView = headerView;
        self.PanelTitle = title;
        self.PanelDescription = description;
        [self buildPanelWithFrame:frame];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
        
        self.PanelTitle = title;
        self.PanelDescription = description;
        self.PanelImageView = [[UIImageView alloc] initWithImage:image];
        [self buildPanelWithFrame:frame];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image header:(UIView *)headerView{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
        
        self.PanelHeaderView = headerView;
        self.PanelTitle = title;
        self.PanelDescription = description;
        self.PanelImageView = [[UIImageView alloc] initWithImage:image];
        [self buildPanelWithFrame:frame];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame nibNamed:(NSString *)nibName{
    self = [super init];
    if (self) {
        // Initialization code
        self = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
        self.frame = frame;
        self.isCustomPanel = YES;
        self.hasCustomAnimation = NO;
    }
    return self;
}

-(void)initializeConstants{
    kTitleFont = [UIFont boldSystemFontOfSize:21];
    kTitleTextColor = [UIColor whiteColor];
    kDescriptionFont = [UIFont systemFontOfSize:14];
    kDescriptionTextColor = [UIColor whiteColor];
    kSeparatorLineColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    self.backgroundColor = [UIColor clearColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)buildPanelWithFrame:(CGRect)frame{
    CGFloat panelTitleHeight = 0;
    CGFloat panelDescriptionHeight = 0;
    
    CGFloat runningYOffset = kTopPadding;
    
    //Process panel header view, if it exists
    if (self.PanelHeaderView) {
        self.PanelHeaderView.frame = CGRectMake((frame.size.width - self.PanelHeaderView.frame.size.width)/2, runningYOffset, self.PanelHeaderView.frame.size.width, self.PanelHeaderView.frame.size.height);
        [self addSubview:self.PanelHeaderView];
        
        runningYOffset += self.PanelHeaderView.frame.size.height + kHeaderTitlePadding;
    }
    
    //Calculate title and description heights
    if ([MYIntroductionPanel runningiOS7]) {
        //Calculate Title Height
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kTitleFont forKey: NSFontAttributeName];
        panelTitleHeight = [self.PanelTitle boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size.height;
        panelTitleHeight = ceilf(panelTitleHeight);
        
        //Calculate Description Height
        NSDictionary *descriptionAttributes = [NSDictionary dictionaryWithObject:kDescriptionFont forKey: NSFontAttributeName];
        panelDescriptionHeight = [self.PanelDescription boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:descriptionAttributes context:nil].size.height;
        panelDescriptionHeight = ceilf(panelDescriptionHeight);
    }
    else {
        panelTitleHeight = [self.PanelTitle sizeWithFont:kTitleFont constrainedToSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        
        panelDescriptionHeight = [self.PanelDescription sizeWithFont:kDescriptionFont constrainedToSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    
    //Create title label
    self.PanelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset, frame.size.width - 2*kLeftRightMargins, panelTitleHeight)];
    self.PanelTitleLabel.numberOfLines = 0;
    self.PanelTitleLabel.text = self.PanelTitle;
    self.PanelTitleLabel.font = kTitleFont;
    self.PanelTitleLabel.textColor = kTitleTextColor;
    self.PanelTitleLabel.alpha = 0;
    self.PanelTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.PanelTitleLabel];
    runningYOffset += panelTitleHeight + kTitleDescriptionPadding;
    
    
    //Add small line in between title and description
    self.PanelSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset - 0.5*kTitleDescriptionPadding, frame.size.width - 2*kLeftRightMargins, 1)];
    self.PanelSeparatorLine.backgroundColor = kSeparatorLineColor;
     [self addSubview:self.PanelSeparatorLine];
    
    //Create description label
    self.PanelDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset, frame.size.width - 2*kLeftRightMargins, panelDescriptionHeight)];
    self.PanelDescriptionLabel.numberOfLines = 0;
    self.PanelDescriptionLabel.text = self.PanelDescription;
    self.PanelDescriptionLabel.font = kDescriptionFont;
    self.PanelDescriptionLabel.textColor = kDescriptionTextColor;
    self.PanelDescriptionLabel.alpha = 0;
    self.PanelDescriptionLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.PanelDescriptionLabel];
    
    runningYOffset += panelDescriptionHeight + kDescriptionImagePadding;
    
    //Add image, if there is room
    if (self.PanelImageView.image) {
        self.PanelImageView.frame = CGRectMake(kLeftRightMargins, runningYOffset, self.frame.size.width - 2*kLeftRightMargins, self.frame.size.height - runningYOffset - kBottomPadding);
        self.PanelImageView.contentMode = UIViewContentModeCenter;
        self.PanelImageView.clipsToBounds = YES;
        [self addSubview:self.PanelImageView];
    }

    // If this is a custom panel, set the has Custom animation boolean
    if (self.isCustomPanel == YES) {
        self.hasCustomAnimation = YES;
    }
}

+(BOOL)runningiOS7{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if (currSysVer.floatValue >= 7.0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Interaction Methods

-(void)panelDidAppear{
    //Implemented by subclass
}

-(void)panelDidDisappear{
    //Implemented by subclass
}


@end
