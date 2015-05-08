//
//  TutorialViewController.m
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "TutorialViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"

@interface TutorialViewController ()
@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //Disabled rounded rectangular button
    CGRect frame = CGRectMake(50, 120, 275, 60);
    HTPressableButton *howtoplay = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRounded];
    howtoplay.disabledButtonColor = [UIColor ht_grapeFruitColor];
    howtoplay.disabledShadowColor = [UIColor ht_grapeFruitDarkColor];
    howtoplay.shadowHeight = 0;
    howtoplay.enabled = NO;
    [howtoplay setTitle:@"Collect The Blocks!" forState:UIControlStateNormal];
    [self.view addSubview:howtoplay];
    
    //EVERYTHING IS ON THE STORYBOARD FOR THIS VIEWCONTROLLER
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
