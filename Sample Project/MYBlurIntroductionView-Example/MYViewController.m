//
//  MYViewController.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYViewController.h"

#import "MYCustomPanel.h"

@interface MYViewController ()

@end

@implementation MYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    //Create Stock Panel with header
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TestHeader" owner:nil options:nil][0];
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"Sample Title" description:@"Sample description alskdjf lkajsdflk jasldkfj laksjdfja jasdlk fjalsjdf lkajsdflkj alskdjf lkajsdfl kjasdlkfj alksjdf lkajsdlkf jalksdj lkajsd lkjasdlk jalsk djlak sjdflkajsd flkjasdfkl jaslkdfj lkasdjf klajsdlk jaslkdj lkasdj flkasdlk fjaskjd fklajsd kljaskld aklsdj lkasjd flkajsd lfkjasd lkfjsad" image:[UIImage imageNamed:@"HeaderImage.png"] header:headerView];
    
    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"Sample Title" description:@"Sample description alskdjf lkajsdflk jasldkfj laksjdfja jasdlk fjalsjdf lkajsdflkj alskdjf lkajsdfl kjasdlkfj alksjdf lkajsdlkf jalksdj lkajsd lkjasdlk jalsk djlak sjdflkajsd flkjasdfkl jaslkdfj lkasdjf klajsdlk jaslkdj lkasdj flkasdlk fjaskjd fklajsd kljaskld aklsdj lkasjd flkajsd lfkjasd lkfjsad" image:[UIImage imageNamed:@"ForkImage.png"]];
    
    //Create Panel From Nib
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"TestPanel3"];
    
    //Create custom panel with event callbacks
    MYCustomPanel *panel4 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"MYCustomPanel"];
    
    NSArray *panels = @[panel1, panel2, panel3, panel4];
    
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    
    [introductionView buildIntroductionWithPanels:panels];
    
    [self.view addSubview:introductionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MYIntroduction Delegate 

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %d", panelIndex);
}

-(void)introductionDidFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
}

@end
