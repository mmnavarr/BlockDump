//
//  ViewController.m
//  BlockDump
//
//  Created by Malcolm Navarro on 4/7/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "StartViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"

@interface StartViewController ()

@property (weak, nonatomic) IBOutlet HTPressableButton *playButton;
@property (weak, nonatomic) IBOutlet HTPressableButton *hiscoreButton;
@property (weak, nonatomic) IBOutlet HTPressableButton *statsButton;
@property (weak, nonatomic) IBOutlet HTPressableButton *howtoButton;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Rounded Play button
    CGRect frame1 = CGRectMake(50, 180, 120, 120);
    HTPressableButton *playButton = [[HTPressableButton alloc] initWithFrame:frame1 buttonStyle:HTPressableButtonStyleRounded];
    [playButton setTag:1];
    playButton.buttonColor = [UIColor ht_grapeFruitColor];
    playButton.shadowColor = [UIColor ht_grapeFruitDarkColor];
    UIImage *btnImage1 = [UIImage imageNamed:@"ic_play.png"];
    [playButton setImage:btnImage1 forState:UIControlStateNormal];
    playButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
    [playButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [playButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [playButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];

    
    // Rounded Leaderboards button
    CGRect frame2 = CGRectMake(200, 180, 120, 120);
    HTPressableButton *hiscoreButton = [[HTPressableButton alloc] initWithFrame:frame2 buttonStyle:HTPressableButtonStyleRounded];
    [hiscoreButton setTag:2];
    hiscoreButton.buttonColor = [UIColor ht_sunflowerColor];
    hiscoreButton.shadowColor = [UIColor ht_citrusColor];
    UIImage *btnImage2 = [UIImage imageNamed:@"ic_hiscore2.png"];
    [hiscoreButton setImage:btnImage2 forState:UIControlStateNormal];
    hiscoreButton.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 28, 16);
    [hiscoreButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [hiscoreButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [hiscoreButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];

    
    // Rounded Statistics button
    CGRect frame3 = CGRectMake(50, 330, 120, 120);
    HTPressableButton *statsButton = [[HTPressableButton alloc] initWithFrame:frame3 buttonStyle:HTPressableButtonStyleRounded];
    [statsButton setTag:3];
    statsButton.buttonColor = [UIColor ht_lavenderColor];
    statsButton.shadowColor = [UIColor ht_lavenderDarkColor];
    UIImage *btnImage3 = [UIImage imageNamed:@"ic_stats.png"];
    [statsButton setImage:btnImage3 forState:UIControlStateNormal];
    statsButton.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 28, 16);
    [statsButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [statsButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [statsButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];

    
    // Rounded Intro button
    CGRect frame4 = CGRectMake(200, 330, 120, 120);
    HTPressableButton *howtoButton = [[HTPressableButton alloc] initWithFrame:frame4 buttonStyle:HTPressableButtonStyleRounded];
    [howtoButton setTag:4];
    howtoButton.buttonColor = [UIColor ht_emeraldColor];
    howtoButton.shadowColor = [UIColor ht_nephritisColor];
    UIImage *btnImage4 = [UIImage imageNamed:@"ic_howto2.png"];
    [howtoButton setImage:btnImage4 forState:UIControlStateNormal];
    howtoButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 24, 12);
    [howtoButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [howtoButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [howtoButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];
    
    
    [self.view addSubview:playButton];
    [self.view addSubview:hiscoreButton];
    [self.view addSubview:statsButton];
    [self.view addSubview:howtoButton];
    
}


- (IBAction)holdDown:(id) sender
{
    //Move image down with button press
    HTPressableButton *tmp = sender;
    switch (tmp.tag) {
        case 1:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 0, 0);
            NSLog(@"Hold down button #1");
            break;
        case 2:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(28, 16, 16, 16);
            
            NSLog(@"Hold down button #2");
            break;
        case 3:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(26, 16, 16, 16);
            NSLog(@"Hold down button #3");
            break;
        case 4:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(24, 12, 12, 12);
            NSLog(@"Hold down button #4");
            break;
        default:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 0,0);
            NSLog(@"Hold down button default");
            break;
    }
}

- (IBAction)holdRelease:(id) sender
{
    //Move image up with button release
    HTPressableButton *tmp = sender;
    switch (tmp.tag) {
        case 1:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
            NSLog(@"Hold release button #1");
            [self performSegueWithIdentifier:@"playSeg" sender:self];
            break;
        case 2:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(100, 160, 280, 160);
            NSLog(@"Hold release button #2");
            [self performSegueWithIdentifier:@"leaderSeg" sender:self];
            break;
        case 3:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 28, 16);
            NSLog(@"Hold release button #3");
            [self performSegueWithIdentifier:@"statSeg" sender:self];
            break;
        case 4:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 24, 12);
            NSLog(@"Hold release button #4");
            [self performSegueWithIdentifier:@"tutorialSeg" sender:self];
            break;
        default:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
            NSLog(@"Hold release button default");
            break;
    }
}


//USE THESE TO SET THE BUTTON LOCATIONS SO ITS SCALES FOR iPhone 4/5/6
+ (CGFloat) window_height   {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (CGFloat) window_width   {
    return [UIScreen mainScreen].applicationFrame.size.width;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
