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
//iVars
@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger highscore;
@property (nonatomic) double lat;
@property (nonatomic) double lng;

- (id)init;
- (id)initWithName:(NSString *)aName andScore:(NSInteger)aScore andLat:(double)aLat andLng:(double)aLng;
- (void)print;

@end


#endif
