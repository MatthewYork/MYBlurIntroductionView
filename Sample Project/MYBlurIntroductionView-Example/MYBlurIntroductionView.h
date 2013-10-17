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
@property (weak, nonatomic) IBOutlet UIScrollView *MasterScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *PageControl;
@property (weak, nonatomic) IBOutlet UILabel *RightSkipButton;
@property (weak, nonatomic) IBOutlet UILabel *LeftSkipButton;
@property (nonatomic, assign) NSInteger CurrentPanelIndex;

//Init Methods
-(id)initWithFrame:(CGRect)frame panels:(NSArray *)panels;

//Interaction Methods
-(void)changeToPanelAtIndex:(NSInteger)index;
@end
