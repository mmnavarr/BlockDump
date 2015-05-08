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
@synthesize lat = _lat;
@synthesize lng = _lng;


-(id)init
{
    self = [super init];
    _name = @"Ricky Bobby";
    _highscore = (NSInteger)0;
    return self;
}

-(id)initWithName:(NSString *)aFirstName andScore:(NSInteger)aScore andLat:(double)aLat andLng:(double)aLng
{
    _name = aFirstName;
    _highscore = aScore;
    _lat = aLat;
    _lng = aLng;
    return self;
}

- (void) print
{
    NSLog(@"Player name: %@ with highscore of %ld located @ (%f,%f)", _name, (long)_highscore, _lat, _lng);
}

@end
