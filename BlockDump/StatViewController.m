//
//  StatViewController.m
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "StartViewController.h"
#import "StatViewController.h"
#import "Player.h"

@interface StatViewController ()

@end

@implementation StatViewController
@synthesize highscoreLabel = _highscoreLabel;
@synthesize tscoreLabel = _tscoreLabel;
@synthesize avgscoreLabel = _avgscoreLabel;
@synthesize tgamesLabel = _tgamesLabel;
@synthesize ttimeLabel = _ttimeLabel;
@synthesize tspritesLabel = _tspritesLabel;
@synthesize thePlayer = _thePlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //LOAD VIEW THAT STATS ARE IN AND STYLE IT
    UIView *view = (UIButton *)[self.view viewWithTag:1];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    view.layer.borderWidth = 3.0f;
    
    //SHOW NAVBAR AGAIN
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //POPULATE THE LABELS WITH PLAYER OBJECT DATA
    [self setLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setLabels {
    //GET USER DEFAULTS DATA
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [defaults integerForKey:@"HighScore"];
    NSInteger totalScore = [defaults integerForKey:@"TotalScore"];
    NSInteger totalGames = [defaults integerForKey:@"TotalGames"];
    NSInteger avgScore = totalScore/totalGames;
    NSInteger totalTime = [defaults integerForKey:@"TotalTime"];
    NSInteger totalSprite = [defaults integerForKey:@"TotalSprite"];
    
    //CONVERT INTEGERS TO STRING
    NSString *s1 = [NSString stringWithFormat:@"%d", (int)highScore];
    NSString *s2 = [NSString stringWithFormat:@"%d", (int)totalScore];
    NSString *s3 = [NSString stringWithFormat:@"%d", (int)avgScore];
    NSString *s4 = [NSString stringWithFormat:@"%d", (int)totalGames];
    NSString *s5 = [NSString stringWithFormat:@"%d", (int)totalTime];
    NSString *s6 = [NSString stringWithFormat:@"%d", (int)totalSprite];
    
    //SET LABELS
    _highscoreLabel.text = s1;
    _tscoreLabel.text = s2;
    _avgscoreLabel.text = s3;
    _tgamesLabel.text = s4;
    _ttimeLabel.text = s5;
    _tspritesLabel.text = s6;
    
}

@end
