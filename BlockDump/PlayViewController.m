//
//  PlayViewController.m
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "PlayViewController.h"
#import "LeaderViewController.h"
#import "StartViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
#define ARC4RANDOM_MAX 0x100000000


@interface PlayViewController ()
@property (weak, nonatomic) IBOutlet HTPressableButton *backButton;
@property (weak, nonatomic) IBOutlet HTPressableButton *restartButton;
@end


@implementation PlayViewController

@synthesize scoreLabel = _scoreLabel;
@synthesize timeLabel = _timeLabel;
@synthesize userLocation;
@synthesize characterView;
@synthesize timer;
@synthesize motionManager;
@synthesize thePlayer = _thePlayer;
@synthesize responseData = _responseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view.
    [self setupSounds];
    secondCount = 0;
    score = 0;
    characterState = 0;
    blockCollisions = 0;
    highscore = false;
    
    //for accelerometer/gyro data
    motionManager = [[CMMotionManager alloc] init];
    
    if (motionManager.isDeviceMotionAvailable){
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
    }
    
    
    //initialize arrays
    spriteViews = [[NSMutableArray alloc] init];
    
    //add image names for creating random sprite imageviews later
    spriteNames = [[NSMutableArray alloc] init];
    [spriteNames addObject:@"triangle_sprite"];
    [spriteNames addObject:@"circle_sprite"];
    [spriteNames addObject:@"hex_sprite"];
    [spriteNames addObject:@"star_sprite"];
    
    timeLeft = 60.0;
    
    //height and width of the screen
    w = CGRectGetWidth(self.view.bounds);
    h = CGRectGetHeight(self.view.bounds);
    
    //height and width of the game grid for sprite spawning
    gridW = 257;
    gridH = 397;
    
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
    [rotationView setUserInteractionEnabled:YES];//important - enables the rotation gesture
    
    //rotation gesture recognizer
    UIRotationGestureRecognizer *rtn = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
    [rtn setDelegate:self];
    
    //add the gesture recognizer to rotation view
    [rotationView addGestureRecognizer:rtn];
    
    //add the main player sprite
    characterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"character"]];
    [characterView setBounds:CGRectMake(0,0, w/8.0f, h/12.0f)];
    [characterView setCenter:self.view.center];
    
    
    //add SubViews to the actual view
    [self.view addSubview:characterView];
    [self.view bringSubviewToFront:characterView];
    [self.view addSubview:rotationView];
    
    //play the game started sound
    [gameStarted play];
    
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
        if (rotation <= -M_PI_4/6){//make the rotation less sensitive
            [characterView setTransform:CGAffineTransformRotate(characterView.transform, M_PI_2)];
            if (characterState == 0){
                characterState = 3;
            }
            else{
                characterState--;
            }
            NSLog(@"Character state: %i",characterState);
        }
        else if (rotation >= M_PI_4/6){
            [characterView setTransform:CGAffineTransformRotate(characterView.transform, -M_PI_2)];
            if (characterState == 3){
                characterState = 0;
            }
            else{
                characterState++;
            }
            NSLog(@"Character state: %i",characterState);
        }
        [recognizer setRotation:0];//reset the recognizer while exiting the method
    }
    
}

- (void) updateLabel:(NSTimer*)theTimer
{
    secondCount++;
    timeLeft = timeLeft - 1;
    if (timeLeft <= 0){
        //update statistics page
        [self finishedGame];
        //game ends
        [gameEnded play];
        [self.view.layer removeAllAnimations];
        if (highscore) { //if the user set a highscore, use a different alert view
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                            message:[NSString stringWithFormat:@"You set a high score! Score: %i", score]
                                                           delegate:self
                                                  cancelButtonTitle:@"Restart"
                                                  otherButtonTitles:@"Submit Score", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
            
            [alert show];
        }
        else {//if they didn't set a high score, display the default alert view
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:[NSString stringWithFormat:@"You have run out of time. Score: %i", score]
                                                       delegate:self
                                              cancelButtonTitle:@"Restart"
                                              otherButtonTitles:@"Home Page", @"Leaderboards", nil];
            [alert setAlertViewStyle:UIAlertViewStyleDefault];
        
            [alert show];
        }
        [timer invalidate]; //stop the timer
        
    }
    //generate/add a sprite every two seconds
    if (secondCount%2 == 0){
        [self spawnSprite];
    }
    _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
}

//method to generate a random float for use in sprite spawn coordinate
- (CGFloat) randomBetween: (CGFloat) x and: (CGFloat) y {
    return ((double)arc4random() / ARC4RANDOM_MAX) * (y - x) + x;
}

//method to add a block to the grid
- (void) spawnSprite {
    int spriteRandom = arc4random_uniform(4);//pick a random sprite
    NSLog(@"sprite random: %i", spriteRandom);
    int sideRandom = arc4random_uniform(4);//pick a random side
    NSLog(@"side random: %i", sideRandom);
    NSString * spriteName = [[NSString alloc] init];
    switch (sideRandom){
        case (0):{//bottom side
            switch (spriteRandom){
                case (0):{
                    spriteName = [spriteNames objectAtIndex:0];
                    //get the random image
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    //create a view to contain the image
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:0];//for use in collision handling
                    [spriteView setRestorationIdentifier:spriteName];//for use in collision handling
                    NSLog(@"spriteView made");
                    //generate a spawn point on the bottom side of the grid
                    CGPoint spritePoint = CGPointMake([self randomBetween:bottomLeft.x and:bottomRight.x], bottomLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    //create a CGRect to contain the image using the spawn point
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    
                    //finally, add the subview
                    [spriteViews addObject:spriteView];
                    [self.view addSubview:spriteView];
                    //begin the sprite animation
                    [self beginSpriteAnimation:spriteView];
                    break;
                    
                }
                case (1):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:0];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake([self randomBetween:bottomLeft.x and:bottomRight.x], bottomLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (2):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:0];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake([self randomBetween:bottomLeft.x and:bottomRight.x], bottomLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (3):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:0];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake([self randomBetween:bottomLeft.x and:bottomRight.x], bottomLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
            }
            break;
        }
        case (1):{//left side
            switch (spriteRandom){
                case (0):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:0];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:1];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topLeft.x, [self randomBetween:topLeft.y and:bottomLeft.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                    
                }
                case (1):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:1];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topLeft.x, [self randomBetween:topLeft.y and:bottomLeft.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (2):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:1];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topLeft.x, [self randomBetween:topLeft.y and:bottomLeft.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (3):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:1];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topLeft.x, [self randomBetween:topLeft.y and:bottomLeft.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
            }
            break;
        }
        case (2):{//top side
            switch (spriteRandom){
                case (0):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:0];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:2];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake([self randomBetween:topLeft.x and:topRight.x], topLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (1):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:2];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake([self randomBetween:topLeft.x and:topRight.x], topLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (2):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:2];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake([self randomBetween:topLeft.x and:topRight.x], topLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (3):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:2];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake([self randomBetween:topLeft.x and:topRight.x], topLeft.y);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
            }
            break;
        }
        case (3):{//right side
            switch (spriteRandom){
                case (0):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:0];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:3];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topRight.x, [self randomBetween:topRight.y and:bottomRight.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (1):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:3];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topRight.x, [self randomBetween:topRight.y and:bottomRight.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (2):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:3];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topRight.x, [self randomBetween:topRight.y and:bottomRight.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
                case (3):{
                    //for explanation of the code in each of these cases, see case 0 of case 0
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
                    [spriteView setTag:3];
                    [spriteView setRestorationIdentifier:spriteName];
                    NSLog(@"spriteView made");
                    CGPoint spritePoint = CGPointMake(topRight.x, [self randomBetween:topRight.y and:bottomRight.y]);
                    NSLog(@"Sprite point x value: %f, Sprite point y value: %f", spritePoint.x, spritePoint.y);
                    CGRect spriteRect = CGRectMake(spritePoint.x, spritePoint.y, gridW/15, gridH/20);
                    [spriteView setFrame:spriteRect];
                    [spriteViews addObject:spriteView];
                    
                    [self.view addSubview:spriteView];
                    [self beginSpriteAnimation:spriteView];
                    break;
                }
            }
            break;
        }
    }

}

- (void) beginSpriteAnimation: (UIImageView *) sprite {
    float x;
    float y;
    int duration;
    //sprite.tag contains the side that it was spawned on.
    //sprites spawned on the left or right side need to have a shorter duration
    //because the distance to center is shorter
    switch (sprite.tag){
        case (0):{
            x = self.view.center.x-8; //offset center x and y a little for each side
            y = self.view.center.y + 28;
            duration = 7;
            break;
        }
        case (1):{
            x = self.view.center.x-42;
            y = self.view.center.y-8;
            duration = 5;
            break;
        }
        case (2):{
            x = self.view.center.x-6;
            y = self.view.center.y - 45;
            duration = 7;
            break;
        }
        case (3):{
            x = self.view.center.x+26;
            y = self.view.center.y-7;
            duration = 5;
            break;
            
        }
        default:{
            x = self.view.center.x;
            y = self.view.center.y;
            break;
        }
    }
    
    [UIView animateWithDuration: duration
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{ [sprite setFrame:CGRectMake(x, y
                                                                , gridW/15, gridH/20)]; }
                     completion: ^(BOOL fin) { [self finishedAnimation:nil finished:fin context:sprite]; }];
}


- (void)finishedAnimation:(NSString *)animationId finished:(BOOL)finished
                  context:(UIView *)context
{
    UIImageView *sprite = (UIImageView *)context;
    
    //the the character state matches the block start side when it's animation ends,
    //then there must be a collision
    if (characterState == sprite.tag){
        blockCollisions++;
        //check the type of block using restorationIdentifier
        if ([sprite.restorationIdentifier isEqualToString:@"triangle_sprite"]){
            score -= 10;
            timeLeft -=10;
            _scoreLabel.text = [NSString stringWithFormat:@"Score: %i", score];
            _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
        }
        else if([sprite.restorationIdentifier isEqualToString:@"circle_sprite"]){
            score -= 5;
            _scoreLabel.text = [NSString stringWithFormat:@"Score: %i", score];
            _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
        }
        else if ([sprite.restorationIdentifier isEqualToString:@"hex_sprite"]){
            score += 5;
            _scoreLabel.text = [NSString stringWithFormat:@"Score: %i", score];
            _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
        }
        else{
            score += 10;
            timeLeft += 10;
            _scoreLabel.text = [NSString stringWithFormat:@"Score: %i", score];
            _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
        }
    }
    [spriteViews removeObject:sprite];
    [sprite removeFromSuperview];
        
    
    
}

//update standard user default for statistics page
- (void) finishedGame {
    //GET USER DEFAULTS AND UPDATE PLAYER DATA
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //SEE IF ITS THE NEW HIGHSCORE
    NSInteger highScore = [defaults integerForKey:@"HighScore"];
    if (score > highScore){
        [defaults setInteger:score forKey:@"HighScore"];
        highscore = true;
    }
    //INCR TOTAL SCORE
    NSInteger totalScore = [defaults integerForKey:@"TotalScore"] + score;
    [defaults setInteger:totalScore forKey:@"TotalScore"];
    
    //INCR TOTAL GAMES PLAYED
    NSInteger totalGames = [defaults integerForKey:@"TotalGames"] + 1;
    [defaults setInteger:totalGames forKey:@"TotalGames"];
    
    //SET AVG SCORE
    NSInteger averageScore = totalScore/totalGames;
    [defaults setInteger:averageScore forKey:@"AvgScore"];
    
    //INCR SECOND COUNT
    NSInteger totalTime = [defaults integerForKey:@"TotalTime"] + secondCount;
    [defaults setInteger:totalTime forKey:@"TotalTime"];
    
    NSInteger totalSprite = [defaults integerForKey:@"TotalSprite"] + blockCollisions;
    [defaults setInteger:totalSprite forKey:@"TotalSprite"];
    
    [defaults synchronize];

}




- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Restart"]){
        //restart the game
        [self restart];
    }
    else if ([title isEqualToString:@"Leaderboards"]){
        //go to the leaderboards
        [self performSegueWithIdentifier:@"playToLeader" sender:self];
    }
    else if ([title isEqualToString:@"Home Page"]){
        //go to the home page
        [self performSegueWithIdentifier:@"playToStart" sender:self];
    }
    else if ([title isEqualToString:@"Submit Score"]){
        //get user input for a name for their high score
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name"
                                                        message:[NSString stringWithFormat:@"Please provide a name"]
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles: nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [alert show];
    }
    else if ([title isEqualToString:@"Done"]){
        UITextField *name = [alertView textFieldAtIndex:0];
        NSString *stringName = name.text;
        
        //MAKE ASYNC HTTPOST REQUEST TO POST HIGHSCORE
        [self asyncPOST:stringName];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:[NSString stringWithFormat:@"You have run out of time. Score: %i", score]
                                                       delegate:self
                                              cancelButtonTitle:@"Restart"
                                              otherButtonTitles:@"Home Page", @"Leaderboards", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
    }
}


- (void) asyncPOST:(NSString *)name
{
    NSLog(@"ASYNC POST BEGIN");
    NSURL *url = [NSURL URLWithString:@"http://www.cyberplays.com/blockdump/post_highscore.php"];
    NSString *post = [NSString stringWithFormat:@"name=%@&score=%d",name,score];
    NSLog(@"Post: %@", post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //RESPONSE RECEIVED, INIT IVAR SO WE CAN APPEND DATA TO IT IN didReceiveData
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //APPEND NEW DATA TO INSTANCE VARIABLE
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    //RETURN NIL TO INDICATE CACHE DATA IS NOT REQUIRED HERE
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    NSLog(@"Succeeded! Received %d bytes of data.\n",(int)[_responseData length]);
    NSString *txt = [[NSString alloc] initWithData:_responseData encoding: NSASCIIStringEncoding];
    NSLog(@"The txt %@\n", txt);
}



- (void) restart {
    
    //reset values
    [spriteViews removeAllObjects];
    timeLeft = 60;
    score = 0;
    blockCollisions = 0;
    secondCount = 0;
    _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %i", (int)score];
    //start the timer
    timer = [NSTimer scheduledTimerWithTimeInterval:1
             
                                             target:self
                                           selector:@selector(updateLabel:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void) setupSounds {
    //Set up sound for game end
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Applause"
                                                          ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundPath];
    gameEnded = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                       error:nil];
    gameEnded.volume = 0.3;
    
    //set up sound for game started
    soundPath = [[NSBundle mainBundle] pathForResource:@"Western-Gunshot"
                                                ofType:@"wav"];
    fileURL = [[NSURL alloc] initFileURLWithPath:soundPath];
    gameStarted = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                         error:nil];
    gameStarted.volume = 0.3;
    
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
