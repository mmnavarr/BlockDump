//
//  ViewController.h
//  BlockDump
//
//  Created by Malcolm Navarro on 4/20/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "Player.h"
#import <UIKit/UIKit.h>
#import "PlayViewController.h"
@import CoreLocation;

//@interface StartViewController : UIViewController <PlayViewControllerDelegate, CLLocationManagerDelegate> {    }
@interface StartViewController : UIViewController <CLLocationManagerDelegate> {    }

@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) Player *playerMain;

@end

