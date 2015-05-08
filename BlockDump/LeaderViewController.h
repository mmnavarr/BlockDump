//
//  LeaderViewController.h
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface LeaderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>

@property(strong, nonatomic) CLLocation *userLocation;
@property(strong, nonatomic) NSMutableData *responseData;
@property(strong, nonatomic) NSMutableArray *players;
@property(strong, nonatomic) IBOutlet UITableView* tableView;

@end
