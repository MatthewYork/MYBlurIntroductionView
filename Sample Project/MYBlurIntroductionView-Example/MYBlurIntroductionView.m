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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame panels:(NSArray *)panels{
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    if (self) {
        self.MasterScrollView.delegate = self;
        Panels = panels;
        
        //Add the blur view to the background
        [self addBlurViewwithFrame:frame];
        [self addPanelsToScrollView];
    }
    return self;
}

//Adds the blur view just below the master scroll view for a blurred background look
-(void)addBlurViewwithFrame:(CGRect)frame{
    self.BlurView = [AMBlurView new];
    self.BlurView.alpha = 1;
    self.BlurView.blurTintColor = [UIColor greenColor];
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
            NSLog(@"TotalWidth: %f", (self.MasterScrollView.frame.size.width*(float)Panels.count));
            NSLog(@"Content offset: %f", self.MasterScrollView.contentOffset.x);
            
            float alpha =((self.MasterScrollView.frame.size.width*(float)Panels.count)-self.MasterScrollView.contentOffset.x)/self.MasterScrollView.frame.size.width;
            NSLog(@"alpha: %f", alpha);
            self.alpha = alpha;
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
    for (MYIntroductionPanel *panelView in Panels) {
        panelView.PanelTitleLabel.alpha = 0;
        panelView.PanelDescriptionLabel.alpha = 0;
    }
    
    if (Panels.count > index) {
        //Get initial frames
        CGRect initialTitleFrame = [Panels[index] PanelTitleLabel].frame;
        CGRect initialDescriptionFrame = [Panels[index] PanelDescriptionLabel].frame;

        //Offset frames
        [[Panels[index] PanelTitleLabel] setFrame:CGRectMake(initialTitleFrame.origin.x + 10, initialTitleFrame.origin.y, initialTitleFrame.size.width, initialTitleFrame.size.height)];
        [[Panels[index] PanelDescriptionLabel] setFrame:CGRectMake(initialDescriptionFrame.origin.x + 10, initialDescriptionFrame.origin.y, initialDescriptionFrame.size.width, initialDescriptionFrame.size.height)];
        
        //Animate Title
        [UIView animateWithDuration:0.3 animations:^{
            [[Panels[index] PanelTitleLabel] setAlpha:1];
            [[Panels[index] PanelTitleLabel] setFrame:initialTitleFrame];
        } completion:^(BOOL finished) {
            //Animate Description
            [UIView animateWithDuration:0.3 animations:^{
                [[Panels[index] PanelDescriptionLabel] setAlpha:1];
                [[Panels[index] PanelDescriptionLabel] setFrame:initialDescriptionFrame];
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

-(void)changeToPanelAtIndex:(NSInteger)index{
    
}


@end
