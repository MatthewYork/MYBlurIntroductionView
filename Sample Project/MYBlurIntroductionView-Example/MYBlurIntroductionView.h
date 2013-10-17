//
//  MYBlurIntroductionView.h
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "AMBlurView.h"
#import "MYIntroductionPanel.h"

static UIColor *kBlurTintColor = nil;

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

/******************************/
//Delegate Method Declarations
/******************************/
@protocol MYIntroductionDelegate
@optional
-(void)introductionDidFinishWithType:(MYFinishType)finishType;
-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex;
@end

/******************************/
//MYBlurIntroductionView
/******************************/
@interface MYBlurIntroductionView : UIView <UIScrollViewDelegate>{
    NSArray *Panels;
    
    MYLanguageDirection LanguageDirection;
    
    NSInteger LastPanelIndex;
}

/******************************/
//Properties
/******************************/

//Delegate
@property (weak) id <MYIntroductionDelegate> delegate;

@property (nonatomic, retain) AMBlurView *BlurView;
@property (weak, nonatomic) IBOutlet UIImageView *BackgroundImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *MasterScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *PageControl;
@property (weak, nonatomic) IBOutlet UIButton *RightSkipButton;
@property (weak, nonatomic) IBOutlet UIButton *LeftSkipButton;
@property (nonatomic, assign) NSInteger CurrentPanelIndex;

//Construction Methods
-(void)buildIntroductionWithPanels:(NSArray *)panels;

//Interaction Methods
- (IBAction)didPressSkipButton;
-(void)changeToPanelAtIndex:(NSInteger)index;

//Enables or disables use of the introductionView. Use this if you want to hold someone on a panel until they have completed some task
-(void)setEnabled:(BOOL)enabled;
@end
