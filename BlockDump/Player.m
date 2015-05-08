//
//  Player.m
//  BlockDump
//
//  Created by Malcolm Navarro on 5/6/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@implementation Player

@synthesize name = _name;
@synthesize highscore = _highscore;
@synthesize avgScore = _avgScore;
@synthesize totalScore = _totalScore;
@synthesize totalConsumed = _totalConsumed;
@synthesize totalTime = _totalTime;
@synthesize totalGames = _totalGames;

-(id)init
{
    self = [super init];
    _name = @"Ricky Bobby";
    _highscore = (NSInteger)0;
    _totalScore = (NSInteger)0;
    _avgScore = (NSInteger)0;
    _totalConsumed = (NSInteger)0;
    _totalTime = (NSInteger)0;
    _totalGames = (NSInteger)0;
    return self;
}

-(id)initWithName:(NSString *)aFirstName andScore:(NSInteger)aScore
{
    _name = aFirstName;
    _highscore = aScore;
    return self;
}

-(void) addScore:(int)score
{
    if (score > _highscore)
        _highscore = score;
    
    _totalScore += score;
    
    _totalGames++;
    
    _avgScore = (_totalScore/_totalGames);
}

@end
