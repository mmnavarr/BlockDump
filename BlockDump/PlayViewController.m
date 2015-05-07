//
//  PlayViewController.m
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "PlayViewController.h"

#define ARC4RANDOM_MAX 0x100000000

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // Do any additional setup after loading the view.
    CGRect bounds = [self.view bounds];
    secondCount = 0;
    score = 0;
    
    
    //initialize arrays
    spriteViews = [[NSMutableArray alloc] init];
    
    spriteNames = [[NSMutableArray alloc] init];
    [spriteNames addObject:@"triangle_sprite"];
    [spriteNames addObject:@"circle_sprite"];
    [spriteNames addObject:@"hex_sprite"];
    [spriteNames addObject:@"star_sprite"];
    
    timeLeft = 60.0;
    
    //height and width of the screen
    CGFloat w = CGRectGetWidth(self.view.bounds);
    CGFloat h = CGRectGetHeight(self.view.bounds);
    
    //height and width of the game grid for sprite spawning
    gridW = 257;
    gridH = 397;
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
    [self.view bringSubviewToFront:characterView];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                        message:[NSString stringWithFormat:@"You have run out of time. Score: %i", score]
                                                       delegate:nil
                                              cancelButtonTitle:@"Restart"
                                              otherButtonTitles:@"Home Page", @"Leaderboards", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        
        [alert show];
        
        [timer invalidate];
        
    }
    //generate/add a sprite every two seconds
    if (secondCount == 2){
        secondCount = 0;
        [self spawnSprite];
    }
    _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
}

- (CGFloat) randomBetween: (CGFloat) x and: (CGFloat) y {
    return ((double)arc4random() / ARC4RANDOM_MAX) * (y - x) + x;
}

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
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                case (1):{
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:0];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:0];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:0];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:1];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:2];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
                    spriteName = [spriteNames objectAtIndex:3];
                    UIImage *spriteImg = [UIImage imageNamed:spriteName];
                    UIImageView *spriteView = [[UIImageView alloc] initWithImage:spriteImg];
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
    float x = self.view.center.x;
    float y = self.view.center.y;
    
    int duration = 10;
    [UIView animateWithDuration: duration
                          delay: 0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations: ^{ [sprite setFrame:CGRectMake(x, y
                                                                , gridW/15, gridH/20)]; }
                     completion: ^(BOOL fin) { [self finishedAnimation:nil finished:fin context:sprite]; }];
}


- (void)finishedAnimation:(NSString *)animationId finished:(BOOL)finished
                  context:(UIView *)context
{
    UIImageView *sprite = (UIImageView *)context;
    
    if ([animationId isEqual: @"end"])
    {
        [spriteViews removeObject:sprite];
        [sprite removeFromSuperview];
    }
    else {
        [spriteViews removeObject:sprite];
        [sprite removeFromSuperview];
        
    }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Restart"]){
        
        [self restart];
    }
    else if ([title isEqualToString:@"Leaderboards"]){
        
    }
    else if ([title isEqualToString:@"Home Page"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) restart {
    
    [spriteViews removeAllObjects];
    timeLeft = 60;
    score = 0;
    _timeLabel.text = [NSString stringWithFormat:@"Time: %is", (int)timeLeft];
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %i", (int)score];
    //start the timer
    timer = [NSTimer scheduledTimerWithTimeInterval:1
             
                                             target:self
                                           selector:@selector(updateLabel:)
                                           userInfo:nil
                                            repeats:YES];
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
