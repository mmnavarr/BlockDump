//
//  Player.h
//  BlockDump
//
//  Created by Malcolm Navarro on 5/6/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#include <UIKit/UIKit.h>

#ifndef BlockDump_Player_h
#define BlockDump_Player_h

@interface Player : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger highscore;
@property (nonatomic) NSInteger totalScore;
@property (nonatomic) NSInteger avgScore;
@property (nonatomic) NSInteger totalConsumed;
@property (nonatomic) NSInteger totalTime;
@property (nonatomic) NSInteger totalGames;

- (id)initWithName:(NSString *)aFirstName andScore:(NSInteger)aScore;

- (void) averageScore;

- (void) addScore:(int)score;

@end


#endif
