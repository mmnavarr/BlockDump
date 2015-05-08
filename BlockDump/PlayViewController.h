//
//  PlayViewController.h
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
@import CoreLocation;
@import CoreMotion;

@interface PlayViewController : UIViewController <UIGestureRecognizerDelegate>
{
    int score;
    int blocksEaten;
    float timeLeft;
    int secondCount;
    
    CGFloat gridW;
    CGFloat gridH;
    CGFloat toW;
    CGFloat toH;
    CGPoint topLeft;
    CGPoint topRight;
    CGPoint bottomLeft;
    CGPoint bottomRight;
    
    AVAudioPlayer *gameStarted;
    AVAudioPlayer *gameEnded;
    NSMutableArray *spriteNames;
    NSMutableArray *spriteViews;
}

@property(strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
@property(strong, nonatomic) UIImageView * characterView;
@property(strong, nonatomic) CLLocation *userLocation;
@property(strong, nonatomic) NSTimer * timer;
@property(strong, nonatomic) CMMotionManager *motionManager;

@end
