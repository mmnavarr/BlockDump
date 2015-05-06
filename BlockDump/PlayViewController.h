//
//  PlayViewController.h
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface PlayViewController : UIViewController <UIGestureRecognizerDelegate>
{
    int score;
    int blocksEaten;
    float timeLeft;
    
    AVAudioPlayer *blockEaten;
    AVAudioPlayer *gameEnded;
}

@property(strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
