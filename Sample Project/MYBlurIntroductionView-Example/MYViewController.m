//
//  MYViewController.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYViewController.h"
#import "MYBlurIntroductionView.h"

@interface MYViewController ()

@end

@implementation MYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"Sample Title" description:@"Sample description alskdjf lkajsdflk jasldkfj laksjdfja jasdlk fjalsjdf lkajsdflkj alskdjf lkajsdfl kjasdlkfj alksjdf lkajsdlkf jalksdj lkajsd lkjasdlk jalsk djlak sjdflkajsd flkjasdfkl jaslkdfj lkasdjf klajsdlk jaslkdj lkasdj flkasdlk fjaskjd fklajsd kljaskld aklsdj lkasjd flkajsd lfkjasd lkfjsad"];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"Sample Title" description:@"Sample description alskdjf lkajsdflk jasldkfj laksjdfja jasdlk fjalsjdf lkajsdflkj alskdjf lkajsdfl kjasdlkfj alksjdf lkajsdlkf jalksdj lkajsd lkjasdlk jalsk djlak sjdflkajsd flkjasdfkl jaslkdfj lkasdjf klajsdlk jaslkdj lkasdj flkasdlk fjaskjd fklajsd kljaskld aklsdj lkasjd flkajsd lfkjasd lkfjsad"];
    
    NSArray *panels = @[panel1, panel2];
    
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:panels];
    
    [self.view addSubview:introductionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
