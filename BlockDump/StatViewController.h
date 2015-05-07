//
//  StatViewController.h
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatViewController : UIViewController

@property(strong, nonatomic) IBOutlet UILabel *highscoreLabel;
@property(strong, nonatomic) IBOutlet UILabel *tscoreLabel;
@property(strong, nonatomic) IBOutlet UILabel *avgscoreLabel;
@property(strong, nonatomic) IBOutlet UILabel *tgamesLabel;
@property(strong, nonatomic) IBOutlet UILabel *ttimeLabel;
@property(strong, nonatomic) IBOutlet UILabel *tspritesLabel;

@end
