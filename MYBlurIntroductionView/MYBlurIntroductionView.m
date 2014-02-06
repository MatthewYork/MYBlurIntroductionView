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

/**
 *  Initializes a new MYBlurIntroductionView.
 *
 *  @param frame CGRect - The desired frame size for the introduction view
 *
 *  @return MYBlurIntroductionView : UIView
 */
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.MasterScrollView.delegate = self;
        self.frame = frame;
        [self initializeViewComponents];
    }
    return self;
}

/**
 *  Initializes the high level view components for the introduction view.
 */
-(void)initializeViewComponents{
    //Background Image View
    self.BackgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    self.BackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.BackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.BackgroundImageView];
    
    //Master Scroll View
    self.MasterScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.MasterScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.MasterScrollView.pagingEnabled = YES;
    self.MasterScrollView.delegate = self;
    self.MasterScrollView.showsHorizontalScrollIndicator = NO;
    self.MasterScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.MasterScrollView];
    
    //Page Control
    self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - kPageControlWidth)/2, self.frame.size.height - 48, kPageControlWidth, 37)];
    self.PageControl.currentPage = 0;
    self.PageControl.enabled = NO;
    [self addSubview:self.PageControl];
    
    //Get skipString dimensions
    NSString *skipString = NSLocalizedString(@"Skip", nil);
    CGFloat skipStringWidth = 0;
    kSkipButtonFont = [UIFont systemFontOfSize:16];
    
    if ([MYIntroductionPanel runningiOS7]) {
        //Calculate Title Height
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kSkipButtonFont forKey: NSFontAttributeName];
        skipStringWidth = [skipString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size.width;
        skipStringWidth = ceilf(skipStringWidth);
    }
    else {
        skipStringWidth = [skipString sizeWithFont:kSkipButtonFont constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].width;
    }
    
    //Left Skip Button
    self.LeftSkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LeftSkipButton.frame = CGRectMake(10, self.frame.size.height - 48, 46, 37);
    [self.LeftSkipButton setTitle:skipString forState:UIControlStateNormal];
    [self.LeftSkipButton.titleLabel setFont:kSkipButtonFont];
    [self.LeftSkipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.LeftSkipButton];
    
    //Right Skip Button
    self.RightSkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.RightSkipButton.frame = CGRectMake(self.frame.size.width - skipStringWidth - kLeftRightSkipPadding, self.frame.size.height - 48, skipStringWidth, 37);
    [self.RightSkipButton.titleLabel setFont:kSkipButtonFont];
    [self.RightSkipButton setTitle:skipString forState:UIControlStateNormal];
    [self.RightSkipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.RightSkipButton];
}

-(void)buildIntroductionWithPanels:(NSArray *)panels{
    Panels = panels;
    for (MYIntroductionPanel *panel in Panels) {
        panel.parentIntroductionView = self;
    }
    
    //Add the overlay view to the background
    [self addOverlayViewWithFrame:self.frame];
    
    //Construct panels
    [self addPanelsToScrollView];
}

/**
 *  Adds the overlay view just below the master scroll view for an overlay background look.
 *
 *  @param frame @b CGRect - Specifies the desired size of the overlayed view.
 *
 */
-(void)addOverlayViewWithFrame:(CGRect)frame{
    self.BackgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f,frame.size.width,frame.size.height)];
    self.BackgroundColorView.backgroundColor = self.UserBackgroundColor;
    [self insertSubview:self.BackgroundColorView belowSubview:self.MasterScrollView];
}

-(void)addPanelsToScrollView{
    if (Panels) {
        if (Panels.count > 0) {
            //Set page control number of pages
            self.PageControl.numberOfPages = Panels.count;
            
            //Set items specific to text direction
            if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
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
    
    [self.MasterScrollView setContentSize:CGSizeMake(panelXOffset, self.frame.size.height)];
    
    //Show the information at the first panel with animations
    [self animatePanelAtIndex:0];
}

-(void)buildScrollViewRightToLeft{
    CGFloat panelXOffset = self.frame.size.width*Panels.count;
    [self.MasterScrollView setContentSize:CGSizeMake(panelXOffset + self.frame.size.width, self.frame.size.height)];
    
    for (MYIntroductionPanel *panelView in Panels) {
        //Update panelXOffset to next view origin location
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        [self.MasterScrollView addSubview:panelView];
        
        panelXOffset -= panelView.frame.size.width;
    }
    
    [self appendCloseViewAtXIndex:&panelXOffset];
    
    
    [self.MasterScrollView setContentOffset:CGPointMake(self.frame.size.width*Panels.count, 0)];
    
    self.PageControl.currentPage = Panels.count;
    
    //Show the information at the first panel with animations
    [self animatePanelAtIndex:0];
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
        self.CurrentPanelIndex = scrollView.contentOffset.x/self.MasterScrollView.frame.size.width;
        
        //Trigger the finish if you are at the end
        if (self.CurrentPanelIndex == (Panels.count)) {
            //Trigger the panel didDisappear appear method in the
            if ([Panels[self.PageControl.currentPage] respondsToSelector:@selector(panelDidDisappear)]) {
                [Panels[self.PageControl.currentPage] panelDidDisappear];
            }
            if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
                [delegate introduction:self didFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Assign the last page to be the previous current page
            LastPanelIndex = self.PageControl.currentPage;
            
            //Trigger the panel did appear method, but skip on a bounce
            if (self.PageControl.currentPage != self.CurrentPanelIndex) {
                if ([Panels[LastPanelIndex] respondsToSelector:@selector(panelDidDisappear)]) {
                    [Panels[LastPanelIndex] panelDidDisappear];
                }
            }
            
            //Update Page Control
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]) {
                    [delegate introduction:self didChangeToPanel:Panels[self.CurrentPanelIndex] withIndex:self.CurrentPanelIndex];
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
    else if(self.LanguageDirection == MYLanguageDirectionRightToLeft){
        self.CurrentPanelIndex = (scrollView.contentOffset.x-self.frame.size.width)/self.MasterScrollView.frame.size.width;
        
        //remove self if you are at the end of the introduction
        if (self.CurrentPanelIndex == -1) {
            if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
                [delegate introduction:self didFinishWithType:MYFinishTypeSwipeOut];
            }
        }
        else {
            //Update Page Control
            LastPanelIndex = self.PageControl.currentPage;
            self.PageControl.currentPage = self.CurrentPanelIndex;
            
            //Call Back, if applicable
            if (LastPanelIndex != self.CurrentPanelIndex) { //Keeps from making the callback when just bouncing and not actually changing pages
                if ([(id)delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]) {
                    [delegate introduction:self didChangeToPanel:Panels[Panels.count-1 - self.CurrentPanelIndex] withIndex:Panels.count-1 - self.CurrentPanelIndex];
                }
                //Trigger the panel did appear method in the
                if ([Panels[Panels.count-1 - self.CurrentPanelIndex] respondsToSelector:@selector(panelDidAppear)]) {
                    [Panels[Panels.count-1 - self.CurrentPanelIndex] panelDidAppear];
                }
                
                //Animate content to pop in nicely! :-)
                [self animatePanelAtIndex:Panels.count-1 - self.CurrentPanelIndex];
            }
        }
    }
}

//This will handle our changing opacity at the end of the introduction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
        if (self.CurrentPanelIndex == (Panels.count - 1)) {
            self.alpha = ((self.MasterScrollView.frame.size.width*(float)Panels.count)-self.MasterScrollView.contentOffset.x)/self.MasterScrollView.frame.size.width;
        }
    }
    else if (self.LanguageDirection == MYLanguageDirectionRightToLeft){
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
    
    if ([Panels[index] isCustomPanel] && ![Panels[index] hasCustomAnimation]) {
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

- (void)didPressSkipButton {
    [self skipIntroduction];
}

-(void)skipIntroduction{
    if ([(id)delegate respondsToSelector:@selector(introduction:didFinishWithType:)]) {
        [delegate introduction:self didFinishWithType:MYFinishTypeSkipButton];
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
    int currentIndex = self.CurrentPanelIndex;
    if (self.LanguageDirection == MYLanguageDirectionRightToLeft)
        currentIndex = (Panels.count-1)-self.CurrentPanelIndex;
    
    if (Panels && index < Panels.count && currentIndex != index)
    {
        // For right-to-left, PageControl index is the inverse of the panel indicies.
        if ([Panels[currentIndex] respondsToSelector:@selector(panelDidDisappear)]) {
            [Panels[currentIndex] panelDidDisappear];
        }
        
        CGRect panelRect = [Panels[index] frame];
        [self.MasterScrollView scrollRectToVisible:panelRect animated:YES];
        self.CurrentPanelIndex = index;
        [self animatePanelAtIndex:index];
        
        if (self.LanguageDirection == MYLanguageDirectionLeftToRight)
            self.PageControl.currentPage = index;
        else if (self.LanguageDirection == MYLanguageDirectionRightToLeft)
            self.PageControl.currentPage = (Panels.count-1)-index;
        
        
        if ([Panels[index] respondsToSelector:@selector(panelDidAppear)]) {
            [Panels[index] panelDidAppear];
        }
        
        //Callback to VC delegate, if appropriate
        if([(id)delegate respondsToSelector:@selector(introduction:didChangeToPanel:withIndex:)]){
            [(id)delegate introduction:self didChangeToPanel:Panels[index] withIndex:index];
        }
    }
    else {
        NSLog(@"The index: %d is out of range for Panels array[0...%d]", index, Panels.count-1);
    }
}

-(void)setEnabled:(BOOL)enabled{
    [UIView animateWithDuration:0.3 animations:^{
        if (enabled) {
            if (self.LanguageDirection == MYLanguageDirectionLeftToRight) {
                self.LeftSkipButton.alpha = !enabled;
                self.RightSkipButton.alpha = enabled;
            }
            else if (self.LanguageDirection == MYLanguageDirectionRightToLeft){
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

#pragma mark - Customization Methods

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    //Save the background color for building
    self.UserBackgroundColor = backgroundColor;
    
    //Immediately apply the color
    if (self.BackgroundColorView) {
        self.BackgroundColorView.backgroundColor = backgroundColor;
    }
}

@end
