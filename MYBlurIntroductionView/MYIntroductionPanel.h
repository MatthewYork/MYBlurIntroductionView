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
const static CGFloat kBottomPadding = 48;
const static CGFloat kHeaderTitlePadding = 10;
const static CGFloat kTitleDescriptionPadding = 10;
const static CGFloat kDescriptionImagePadding = 10;
static UIFont *kTitleFont = nil;
static UIColor *kTitleTextColor = nil;
static UIFont *kDescriptionFont = nil;
static UIColor *kDescriptionTextColor = nil;
static UIColor *kSeparatorLineColor = nil;

@class MYBlurIntroductionView;

@interface MYIntroductionPanel : UIView

@property (weak) MYBlurIntroductionView *parentIntroductionView;

//Init Methods
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description header:(UIView *)headerView;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image header:(UIView *)headerView;
-(id)initWithFrame:(CGRect)frame nibNamed:(NSString *)nibName;

//Support Methods
+(BOOL)runningiOS7;

- (void) hideContent;
- (void) showContent;

//Interaction Methods
-(void)panelDidAppear;
-(void)panelDidDisappear;

@end
