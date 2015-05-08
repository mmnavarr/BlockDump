//
//  ViewController.m
//  BlockDump
//
//  Created by Malcolm Navarro on 4/7/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "StartViewController.h"
#import "LeaderViewController.h"
#import "StatViewController.h"
#import "PlayViewController.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
#import "Player.h"


@interface StartViewController ()
@end



@implementation StartViewController

@synthesize userLocation;
@synthesize locationManager;
@synthesize playerMain = _playerMain;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //HIDE NAVBAR
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //start location manager to get location for leaderboards
    [self startLocationManager];
    NSLog(@"latitude %+.6f, longitude %+.6f\n",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    
    /* All buttons are made with the initWithFrame using a CGRect as the argument.
     They contain a tag for reference, an image and a holdDown and holdRelease.
     holdDown and holdRelease control moving the image witht the button click create a clean UI */
     
    
    
    //CREATE ROUNDED PLAY BUTTON
    CGRect frame1 = CGRectMake(55, 220, 120, 120);
    HTPressableButton *playButton = [[HTPressableButton alloc] initWithFrame:frame1 buttonStyle:HTPressableButtonStyleRounded];
    [playButton setTag:1];
    playButton.buttonColor = [UIColor ht_grapeFruitColor];
    playButton.shadowColor = [UIColor ht_grapeFruitDarkColor];
    UIImage *btnImage1 = [UIImage imageNamed:@"ic_play.png"];
    [playButton setImage:btnImage1 forState:UIControlStateNormal];
    playButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
    [playButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [playButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [playButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];

    
    //CREATE ROUNDED LEADERBOARDS BUTTON
    CGRect frame2 = CGRectMake(205, 220, 120, 120);
    HTPressableButton *hiscoreButton = [[HTPressableButton alloc] initWithFrame:frame2 buttonStyle:HTPressableButtonStyleRounded];
    [hiscoreButton setTag:2];
    hiscoreButton.buttonColor = [UIColor ht_sunflowerColor];
    hiscoreButton.shadowColor = [UIColor ht_citrusColor];
    UIImage *btnImage2 = [UIImage imageNamed:@"ic_hiscore2.png"];
    [hiscoreButton setImage:btnImage2 forState:UIControlStateNormal];
    hiscoreButton.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 28, 16);
    [hiscoreButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [hiscoreButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [hiscoreButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];

    
    //CREATE ROUNDED STATS BUTTON
    CGRect frame3 = CGRectMake(55, 360, 120, 120);
    HTPressableButton *statsButton = [[HTPressableButton alloc] initWithFrame:frame3 buttonStyle:HTPressableButtonStyleRounded];
    [statsButton setTag:3];
    statsButton.buttonColor = [UIColor ht_lavenderColor];
    statsButton.shadowColor = [UIColor ht_lavenderDarkColor];
    UIImage *btnImage3 = [UIImage imageNamed:@"ic_stats.png"];
    [statsButton setImage:btnImage3 forState:UIControlStateNormal];
    statsButton.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 28, 16);
    [statsButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [statsButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [statsButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];

    
    //CREATE ROUNDED TUTORIAL BUTTON
    CGRect frame4 = CGRectMake(205, 360, 120, 120);
    HTPressableButton *howtoButton = [[HTPressableButton alloc] initWithFrame:frame4 buttonStyle:HTPressableButtonStyleRounded];
    [howtoButton setTag:4];
    howtoButton.buttonColor = [UIColor ht_emeraldColor];
    howtoButton.shadowColor = [UIColor ht_nephritisColor];
    UIImage *btnImage4 = [UIImage imageNamed:@"ic_howto2.png"];
    [howtoButton setImage:btnImage4 forState:UIControlStateNormal];
    howtoButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 24, 12);
    [howtoButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDown];
    [howtoButton addTarget:self action:@selector(holdRelease:) forControlEvents:UIControlEventTouchUpInside];
    [howtoButton addTarget:self action:@selector(holdDown:) forControlEvents:UIControlEventTouchDragInside];
    
    //ADD ALL BUTTON TO VIEW
    [self.view addSubview:playButton];
    [self.view addSubview:hiscoreButton];
    [self.view addSubview:statsButton];
    [self.view addSubview:howtoButton];
    
}


- (IBAction)holdDown:(id) sender
{
    //MOVE IMAGE DOWN WITH PRESS
    HTPressableButton *tmp = sender;
    switch (tmp.tag) {
        case 1:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 0, 0);
            NSLog(@"Hold down button #1");
            break;
        case 2:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(28, 16, 16, 16);
            
            NSLog(@"Hold down button #2");
            break;
        case 3:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(26, 16, 16, 16);
            NSLog(@"Hold down button #3");
            break;
        case 4:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(24, 12, 12, 12);
            NSLog(@"Hold down button #4");
            break;
        default:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 0,0);
            NSLog(@"Hold down button default");
            break;
    }
}

- (IBAction)holdRelease:(id) sender
{
    //MOVE IMAGE UP WITH RELEASE
    //ALSO SEGUE TO NEXT VIEWCONTROLLER
    HTPressableButton *tmp = sender;
    switch (tmp.tag) {
        case 1:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
            NSLog(@"Hold release button #1");
            [locationManager stopUpdatingLocation];
            [self performSegueWithIdentifier:@"playSeg" sender:self];
            break;
        case 2:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(100, 160, 280, 160);
            NSLog(@"Hold release button #2");
            [locationManager stopUpdatingLocation];
            [self performSegueWithIdentifier:@"leaderSeg" sender:self];
            break;
        case 3:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 28, 16);
            NSLog(@"Hold release button #3");
            [locationManager stopUpdatingLocation];
            [self performSegueWithIdentifier:@"statSeg" sender:self];
            break;
        case 4:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 24, 12);
            NSLog(@"Hold release button #4");
            [locationManager stopUpdatingLocation];
            [self performSegueWithIdentifier:@"tutorialSeg" sender:self];
            break;
        default:
            tmp.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 12, 0);
            NSLog(@"Hold release button default");
            break;
    }
}

//START LOCATION MANAGER TO GET USER LOCATION
- (void) startLocationManager{
    userLocation = [[CLLocation alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    //[locationManager locationServicesEnabled]; // deprecated?
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        userLocation = location;
        
    }
}

//SEGUE METHOD TO PASS USER LOCATION TO THESE VIEWCONTROLLERS
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"playSeg"]){
         PlayViewController *playViewController = segue.destinationViewController;
         playViewController.userLocation = self.userLocation;
     }
     else if ([segue.identifier isEqualToString:@"leaderSeg"]){
         LeaderViewController *destViewController = segue.destinationViewController;
         destViewController.userLocation = self.userLocation;
     }
 }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
