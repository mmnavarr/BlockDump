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

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //GET PLAYER FROM STARTVIEWCONTROLLER
    /*StartViewController *startView = [[StartViewController alloc] init];
    Player *player = startView.thePlayer;
    NSLog(@"The players name: %@", player.name);*/
    
    //INITIALIZE PLAYER
    Player *thePlayer = [[Player alloc] init];
    thePlayer.name = @"The Player";
    [thePlayer addScore:201050];
    [thePlayer addScore:408300];
    [thePlayer addScore:619020];
    thePlayer.totalTime = 206;
    thePlayer.totalConsumed = 1013;
    
    [self setLabels:(Player *) thePlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setLabels:(Player *) player {
    //CONVERT INTEGERS TO STRING
    NSString *s1 = [NSString stringWithFormat:@"%d", (int)player.highscore];
    NSString *s2 = [NSString stringWithFormat:@"%d", (int)player.totalScore];
    NSString *s3 = [NSString stringWithFormat:@"%d", (int)player.avgScore];
    NSString *s4 = [NSString stringWithFormat:@"%d", (int)player.totalGames];
    NSString *s5 = [NSString stringWithFormat:@"%d", (int)player.totalTime];
    NSString *s6 = [NSString stringWithFormat:@"%d", (int)player.totalConsumed];
    
    _highscoreLabel.text = s1;
    _tscoreLabel.text = s2;
    _avgscoreLabel.text = s3;
    _tgamesLabel.text = s4;
    _ttimeLabel.text = s5;
    _tspritesLabel.text = s6;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
