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
    
    //HEADER
    CGRect frame1 = CGRectMake(40, 110, 290, 60);
    HTPressableButton *howtoplay = [[HTPressableButton alloc] initWithFrame:frame1 buttonStyle:HTPressableButtonStyleRounded];
    howtoplay.disabledButtonColor = [UIColor ht_grapeFruitColor];
    howtoplay.disabledShadowColor = [UIColor ht_grapeFruitDarkColor];
    howtoplay.shadowHeight = 0;
    howtoplay.enabled = NO;
    [howtoplay setTitle:@"Collect The Blocks!" forState:UIControlStateNormal];
    [self.view addSubview:howtoplay];
    
    //PLAY BUTTON -> SEGUE TO PLAYVIEWCONTROLLER
    CGRect frame2 = CGRectMake(40, 565, 290, 60);
    HTPressableButton *play = [[HTPressableButton alloc] initWithFrame:frame2 buttonStyle:HTPressableButtonStyleRounded];
    play.buttonColor = [UIColor ht_grapeFruitColor];
    play.shadowColor = [UIColor ht_grapeFruitDarkColor];
    [play setTitle:@"Let's Play." forState:UIControlStateNormal];
    [play addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:play];
    
    //MOST CONTENT IS ON THE STORYBOARD
}

- (IBAction)holdDown:(id) sender
{
    [self performSegueWithIdentifier:@"letsPlay" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
