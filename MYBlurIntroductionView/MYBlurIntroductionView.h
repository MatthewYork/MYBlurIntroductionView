//
//  MYBlurIntroductionView.h
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "MYIntroductionPanel.h"

static const CGFloat kPageControlWidth = 148;
static const CGFloat kLeftRightSkipPadding = 10;
static UIFont *kSkipButtonFont = nil;
//Enum to define types of introduction finishes
typedef enum {
    MYFinishTypeSwipeOut = 0,
    MYFinishTypeSkipButton
}MYFinishType;

//Enum to define language direction
typedef enum {
    MYLanguageDirectionLeftToRight = 0,
    MYLanguageDirectionRightToLeft
}MYLanguageDirection;

@class MYBlurIntroductionView;

/******************************/
//Delegate Method Declarations
/******************************/
@protocol MYIntroductionDelegate
@optional
-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType;
-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex;
@end

/******************************/
//MYBlurIntroductionView
/******************************/
@interface MYBlurIntroductionView : UIView <UIScrollViewDelegate>{
    NSArray *Panels;
    
    NSInteger LastPanelIndex;
}

/******************************/
//Properties
/******************************/

//Delegate
@property (weak) id <MYIntroductionDelegate> delegate;

@property (nonatomic, retain) UIView *BlurView;
@property (nonatomic, retain) UIView *BackgroundColorView;
@property (retain, nonatomic) UIImageView *BackgroundImageView;
@property (retain, nonatomic) UIScrollView *MasterScrollView;
@property (retain, nonatomic) UIPageControl *PageControl;
@property (retain, nonatomic) UIButton *RightSkipButton;
@property (retain, nonatomic) UIButton *LeftSkipButton;
@property (nonatomic, assign) NSInteger CurrentPanelIndex;
@property (nonatomic, assign) MYLanguageDirection LanguageDirection;
@property (nonatomic, retain) UIColor *UserBackgroundColor;

/**
 *  Public method used to build panels
 *
 *  @param panels @b Array of MYIntroductionPanel objects
 */
-(void)buildIntroductionWithPanels:(NSArray *)panels;

/**
 *  Handles the event that the skip button was tapped.
 */
- (IBAction)didPressSkipButton;

/**
 *  Changes the panel to a desired index. The index is relative to the array of panels passed in to the @em buildIntroductionWithPanels
 *
 *  @param index @b NSInteger The desired panel number to be changed to
 */
-(void)changeToPanelAtIndex:(NSInteger)index;

/**
 *  Enables or disables use of the introductionView. Use this if you want to hold someone on a panel until they have completed some task
 *
 *  @param enabled @b BOOL The desired enabled status of the introduction view
 */
-(void)setEnabled:(BOOL)enabled;

/**
 *  Changes the background color of the introduction view. This background color sits a layer above the background image layer.
 *
 *  @param backgroundColor  @b UIColor The desired background color
 */
-(void)setBackgroundColor:(UIColor *)backgroundColor;
@end
