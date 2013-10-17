//
//  MYBlurIntroductionView.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYBlurIntroductionView.h"

@implementation MYBlurIntroductionView
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    if (self) {
        self.MasterScrollView.delegate = self;
        self.frame = frame;
    }
    return self;
}

//Public method used to build panels
-(void)buildIntroductionWithPanels:(NSArray *)panels{
    Panels = panels;
    for (MYIntroductionPanel *panel in Panels) {
        panel.parentIntroductionView = self;
    }
    
    //Initialize Constants
    [self initializeConstants];
    
    //Add the blur view to the background
    [self addBlurViewwithFrame:self.frame];
    
    //Construct panels
    [self addPanelsToScrollView];
}

-(void)initializeConstants{
    kBlurTintColor = [UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1];
}

//Adds the blur view just below the master scroll view for a blurred background look
-(void)addBlurViewwithFrame:(CGRect)frame{
    self.BlurView = [AMBlurView new];
    self.BlurView.alpha = 1;
    self.BlurView.blurTintColor = kBlurTintColor;
    [self.BlurView setFrame:CGRectMake(0.0f,0.0f,frame.size.width,frame.size.height)];
    [self insertSubview:self.BlurView belowSubview:self.MasterScrollView];
}

-(void)addPanelsToScrollView{
    if (Panels) {
        if (Panels.count > 0) {
            //Set page control number of pages
            self.PageControl.numberOfPages = Panels.count;
            
            //Set items specific to text direction
            if (LanguageDirection == MYLanguageDirectionLeftToRight) {
                self.LeftSkipButton.hidden = YES;
                [self buildScrollViewLeftToRight];
            }
            else {
                self.RightSkipButton.hidden = YES;
                [self buildScrollViewRightToLeft];
            }
        }
        else {
            NSLog(@"You must pass in panels for the introduction view to have content. 0 panels were found");
        }
    }
    else {
        NSLog(@"You must pass in panels for the introduction view to have content. The panels object was nil.");
    }
}

-(void)buildScrollViewLeftToRight{
    CGFloat panelXOffset = 0;
    for (MYIntroductionPanel *panelView in Panels) {
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        [self.MasterScrollView addSubview:panelView];
        
        //Update panelXOffset to next view origin location
        panelXOffset += panelView.frame.size.width;
    }
    
    [self appendCloseViewAtXIndex:&panelXOffset];
    
    [self.MasterScrollView setContentSize:CGSizeMake(panelXOffset, self.frame.size.width)];
    
    //Show the information at the first panel with animations
    [self animatePanelAtIndex:0];
}

-(void)buildScrollViewRightToLeft{
    CGFloat panelXOffset = 0;
    for (MYIntroductionPanel *panelView in Panels) {
        //Update panelXOffset to next view origin location
        panelXOffset -= panelView.frame.size.width;
        
        [self.MasterScrollView addSubview:panelView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIScrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (LanguageDirection == MYLanguageDirectionLeftToRight) {
        self.CurrentPanelIndex = scrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
        
        //remove self if you are at the end of the introduction
        if (self.CurrentPanelIndex == (Panels.count)) {
            if ([(id)delegate respondsToSelector:@selector(introductionDidFinishWithType:)]) {
                [delegate introductionDidFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Assign the last page to be the previous current page
            LastPanelIndex = self.PageControl.currentPage;
            
            //Trigger the panel did appear method in the
            if ([Panels[LastPanelIndex] respondsToSelector:@selector(panelDidDisappear)]) {
                [Panels[LastPanelIndex] panelDidDisappear];
            }
            
            //Update Page Control
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Format and show new content
            //[self setContentScrollViewHeightForPanelIndex:self.CurrentPanelIndex animated:YES];
            //[self makePanelVisibleAtIndex:(NSInteger)self.CurrentPanelIndex];
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introductionDidChangeToPanel:withIndex:)]) {
                    [delegate introductionDidChangeToPanel:Panels[self.CurrentPanelIndex] withIndex:self.CurrentPanelIndex];
                }
                
                //Trigger the panel did appear method in the
                if ([Panels[self.CurrentPanelIndex] respondsToSelector:@selector(panelDidAppear)]) {
                    [Panels[self.CurrentPanelIndex] panelDidAppear];
                }
                
                //Animate content to pop in nicely! :-)
                [self animatePanelAtIndex:self.CurrentPanelIndex];
            }
        }
    }
    else if(LanguageDirection == MYLanguageDirectionRightToLeft){
        self.CurrentPanelIndex = (scrollView.contentOffset.x-self.frame.size.width)/self.MasterScrollView.frame.size.width;
        
        //remove self if you are at the end of the introduction
        if (self.CurrentPanelIndex == -1) {
            if ([(id)delegate respondsToSelector:@selector(introductionDidFinishWithType:)]) {
                [delegate introductionDidFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Update Page Control
            LastPanelIndex = self.PageControl.currentPage;
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Format and show new content
            //[self setContentScrollViewHeightForPanelIndex:self.CurrentPanelIndex animated:YES];
            //[self makePanelVisibleAtIndex:(NSInteger)self.CurrentPanelIndex];
            
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introductionDidChangeToPanel:withIndex:)]) {
                    [delegate introductionDidChangeToPanel:Panels[self.CurrentPanelIndex] withIndex:self.CurrentPanelIndex];
                }
                
                //Animate content to pop in nicely! :-)
                [self animatePanelAtIndex:self.CurrentPanelIndex];
            }
        }
    }
}

//This will handle our changing opacity at the end of the introduction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (LanguageDirection == MYLanguageDirectionLeftToRight) {
        if (self.CurrentPanelIndex == (Panels.count - 1)) {
            self.alpha = ((self.MasterScrollView.frame.size.width*(float)Panels.count)-self.MasterScrollView.contentOffset.x)/self.MasterScrollView.frame.size.width;;
        }
    }
    else if (LanguageDirection == MYLanguageDirectionRightToLeft){
        if (self.CurrentPanelIndex == 0) {
            self.alpha = self.MasterScrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
        }
    }
}

#pragma mark - Helper Methods
//Show the information at the given panel with animations
-(void)animatePanelAtIndex:(NSInteger)index{
    //If it is a custom panel, skip stock animation
    
    //Hide all labels
    for (MYIntroductionPanel *panelView in Panels) {
        panelView.PanelTitleLabel.alpha = 0;
        panelView.PanelDescriptionLabel.alpha = 0;
        panelView.PanelSeparatorLine.alpha = 0;
        if (panelView.PanelHeaderView) {
            panelView.PanelHeaderView.alpha = 0;
        }
        panelView.PanelImageView.alpha = 0;
    }
    
    if ([Panels[index] isCustomPanel]) {
        return;
    }
    
    //Animate
    if (Panels.count > index) {
        //Get initial frames
        CGRect initialHeaderFrame = CGRectZero;
        if ([Panels[index] PanelHeaderView]) {
            initialHeaderFrame = [Panels[index] PanelHeaderView].frame;
        }
        CGRect initialTitleFrame = [Panels[index] PanelTitleLabel].frame;
        CGRect initialDescriptionFrame = [Panels[index] PanelDescriptionLabel].frame;
        CGRect initialImageFrame = [Panels[index] PanelImageView].frame;
        
        //Offset frames
        [[Panels[index] PanelTitleLabel] setFrame:CGRectMake(initialTitleFrame.origin.x + 10, initialTitleFrame.origin.y, initialTitleFrame.size.width, initialTitleFrame.size.height)];
        [[Panels[index] PanelDescriptionLabel] setFrame:CGRectMake(initialDescriptionFrame.origin.x + 10, initialDescriptionFrame.origin.y, initialDescriptionFrame.size.width, initialDescriptionFrame.size.height)];
        [[Panels[index] PanelHeaderView] setFrame:CGRectMake(initialHeaderFrame.origin.x, initialHeaderFrame.origin.y - 10, initialHeaderFrame.size.width, initialHeaderFrame.size.height)];
        [[Panels[index] PanelImageView] setFrame:CGRectMake(initialImageFrame.origin.x, initialImageFrame.origin.y + 10, initialImageFrame.size.width, initialImageFrame.size.height)];
        
        //Animate title and header
        [UIView animateWithDuration:0.3 animations:^{
            [[Panels[index] PanelTitleLabel] setAlpha:1];
            [[Panels[index] PanelTitleLabel] setFrame:initialTitleFrame];
            [[Panels[index] PanelSeparatorLine] setAlpha:1];
            
            if ([Panels[index] PanelHeaderView]) {
                [[Panels[index] PanelHeaderView] setAlpha:1];
                [[Panels[index] PanelHeaderView] setFrame:initialHeaderFrame];
            }
        } completion:^(BOOL finished) {
            //Animate description
            [UIView animateWithDuration:0.3 animations:^{
                [[Panels[index] PanelDescriptionLabel] setAlpha:1];
                [[Panels[index] PanelDescriptionLabel] setFrame:initialDescriptionFrame];
                [[Panels[index] PanelImageView] setAlpha:1];
                [[Panels[index] PanelImageView] setFrame:initialImageFrame];
            }];
        }];
    }
}

-(void)appendCloseViewAtXIndex:(CGFloat*)xIndex{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, 400)];
    
    [self.MasterScrollView addSubview:closeView];
    
    *xIndex += self.MasterScrollView.frame.size.width;
}

#pragma mark - Interaction Methods

- (IBAction)didPressSkipButton {
    [self skipIntroduction];
}

-(void)skipIntroduction{
    if ([(id)delegate respondsToSelector:@selector(introductionDidFinishWithType:)]) {
        [delegate introductionDidFinishWithType:MYFinishTypeSkipButton];
    }
    
    [self hideWithFadeOutDuration:0.3];
}

-(void)hideWithFadeOutDuration:(CGFloat)duration{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:nil];
}

-(void)changeToPanelAtIndex:(NSInteger)index{
    
}

-(void)setEnabled:(BOOL)enabled{
    [UIView animateWithDuration:0.3 animations:^{
        if (enabled) {
            if (LanguageDirection == MYLanguageDirectionLeftToRight) {
                self.LeftSkipButton.alpha = !enabled;
                self.RightSkipButton.alpha = enabled;
            }
            else if (LanguageDirection == MYLanguageDirectionRightToLeft){
                self.LeftSkipButton.alpha = enabled;
                self.RightSkipButton.alpha = !enabled;
            }
            
            self.MasterScrollView.scrollEnabled = YES;
        }
        else {
            self.LeftSkipButton.alpha = enabled;
            self.RightSkipButton.alpha = enabled;
            self.MasterScrollView.scrollEnabled = NO;
        }
    }];
}
@end
