//
//  ViewController.h
//  BlockDump
//
//  Created by Malcolm Navarro on 4/20/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface StartViewController : UIViewController <CLLocationManagerDelegate>
{
    
}

@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

