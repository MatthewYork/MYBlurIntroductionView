//
//  MYIntroductionPanel.h
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import <UIKit/UIKit.h>

const static CGFloat kTopPadding = 30;
const static CGFloat kLeftRightMargins = 10;
const static CGFloat kBottomPadding = 10;
const static CGFloat kTitleDescriptionPadding;
static UIFont *kTitleFont = nil;
static UIColor *kTitleTextColor = nil;
static UIFont *kDescriptionFont = nil;
static UIColor *kDescriptionTextColor = nil;

@interface MYIntroductionPanel : UIView

@property (nonatomic, retain) NSString *PanelTitle;
@property (nonatomic, retain) NSString *PanelDescription;
@property (nonatomic, retain) UILabel *PanelTitleLabel;
@property (nonatomic, retain) UILabel *PanelDescriptionLabel;
@property (nonatomic, retain) UIImage *PanelImage;

//Init Methods
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image;
-(id)initWithFrame:(CGRect)frame nibNamed:(NSString *)nibName;

//Support Methods
+(BOOL)runningiOS7;
@end
