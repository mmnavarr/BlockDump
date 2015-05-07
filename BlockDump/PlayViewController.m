//
//  PlayViewController.m
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize scoreLabel = _scoreLabel;
@synthesize timeLabel = _timeLabel;
@synthesize userLocation;
@synthesize characterView;
@synthesize timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect bounds = [self.view bounds];
    secondCount = 0;
    
    
    //initialize arrays
    spriteViews = [[NSMutableArray alloc] init];
    
    spriteNames = [[NSMutableArray alloc] init];
    [spriteNames addObject:@"triangle_sprite"];
    [spriteNames addObject:@"circle_sprite"];
    [spriteNames addObject:@"hex_sprite"];
    [spriteNames addObject:@"star_sprite"];
    
    timeLeft = 60.0;
    
    //height and width of the screen
    CGFloat w = CGRectGetWidth(bounds);
    CGFloat h = CGRectGetHeight(bounds);
    
    //height and width of the game grid for sprite spawning
    gridW = w - 50.0f;
    gridH = h - 100.0f;
    toW = gridW/2;
    toH = gridH/2;
    topLeft = CGPointMake(50.0, 150.0); //top left corner of the grid
    topRight = CGPointMake(gridW + 50, 150);//top right
    bottomLeft = CGPointMake(50, gridH + 150);//etc
    bottomRight = CGPointMake(gridW + 50, gridH + 150);
    
    
    //start the timer
    timer = [NSTimer scheduledTimerWithTimeInterval:1
     
                                     target:self
                                   selector:@selector(updateLabel:)
                                   userInfo:nil
                                    repeats:YES];
    
    //add the rotation image
    UIImageView *rotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle2"]];
    [rotationView setBounds:CGRectMake(0, 0, w/6.0f, h/11.0f)];
    [rotationView setCenter:CGPointMake(w/2.0f, h-60.0f)];
    [rotationView setUserInteractionEnabled:YES];
    
    //rotation gesture recognizer
    UIRotationGestureRecognizer *rtn = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
    [rtn setDelegate:self];
    
    //add the gesture recognizer to rotation view
    [rotationView addGestureRecognizer:rtn];
    
    //add the main player sprite
    characterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"character"]];
    [characterView setBounds:CGRectMake(0,0, w/8.0f, h/12.0f)];
    [characterView setCenter:self.view.center];
    
    
    
    [self.view addSubview:characterView];
    [self.view addSubview:rotationView];
    
    NSLog(@"latitude %+.6f, longitude %+.6f\n", // debugging location
          userLocation.coordinate.latitude,
          userLocation.coordinate.longitude);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    //handle rotation...
    NSLog(@"Rotating..");
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat rotation = [recognizer rotation];
        //rotate the character in sync with the bottom circle
        [recognizer.view setTransform:CGAffineTransformRotate(recognizer.view.transform, rotation)];
        [characterView setTransform:CGAffineTransformRotate(characterView.transform, rotation)];
        [recognizer setRotation:0];
    }
    
}

- (void) setLocation:(CLLocation *) location {
    userLocation = [[CLLocation alloc] init];
    userLocation = location;
}


- (void) updateLabel:(NSTimer*)theTimer
{
    secondCount++;
    timeLeft = timeLeft - 1;
    if (timeLeft <= 0){
        //game ends
    }
    //generate/add a sprite every two seconds
    if (secondCount == 2){
    int spriteRandom = arc4random_uniform(4);//pick a random sprite
    int sideRandom = arc4random_uniform(4);//pick a random side
    NSString * spriteName = [[NSString alloc] init];
        switch (sideRandom){
            case (0):{//bottom side
                switch (spriteRandom){
                    case (0):{
                        spriteName = [spriteNames objectAtIndex:0];
                        UIImage *spriteImg = [UIImage imageNamed:@"spriteName"];
                        UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                        
                        
                    }
                    case (1):{
                        spriteName = [spriteNames objectAtIndex:1];
                        UIImage *spriteImg = [UIImage imageNamed:@"spriteName"];
                        UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    }
                    case (2):{
                        spriteName = [spriteNames objectAtIndex:2];
                        UIImage *spriteImg = [UIImage imageNamed:@"spriteName"];
                        UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    }
                    case (3):{
                        spriteName = [spriteNames objectAtIndex:3];
                        UIImage *spriteImg = [UIImage imageNamed:@"spriteName"];
                        UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    }
                }
            }
            case (1):{//left side
                switch (spriteRandom){
                    case (0):{
                        spriteName = [spriteNames objectAtIndex:0];
                    }
                    case (1):{
                        spriteName = [spriteNames objectAtIndex:1];
                    }
                    case (2):{
                        spriteName = [spriteNames objectAtIndex:2];
                    }
                    case (3):{
                        spriteName = [spriteNames objectAtIndex:3];
                    }
                }
            }
            case (2):{//top side
                switch (spriteRandom){
                    case (0):{
                        spriteName = [spriteNames objectAtIndex:0];
                    }
                    case (1):{
                        spriteName = [spriteNames objectAtIndex:1];
                    }
                    case (2):{
                        spriteName = [spriteNames objectAtIndex:2];
                    }
                    case (3):{
                        spriteName = [spriteNames objectAtIndex:3];
                    }
                }
            }
            case (3):{//right side
                switch (spriteRandom){
                    case (0):{
                        spriteName = [spriteNames objectAtIndex:0];
                    }
                    case (1):{
                        spriteName = [spriteNames objectAtIndex:1];
                    }
                    case (2):{
                        spriteName = [spriteNames objectAtIndex:2];
                    }
                    case (3):{
                        spriteName = [spriteNames objectAtIndex:3];
                    }
                }
            }
        }
    }
    _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
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
