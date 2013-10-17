//
//  MYCustomPanel.h
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/17/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYIntroductionPanel.h"

@interface MYCustomPanel : MYIntroductionPanel <UITextViewDelegate> {
    
    __weak IBOutlet UIView *CongratulationsView;
}


- (IBAction)didPressEnable:(id)sender;

@end
