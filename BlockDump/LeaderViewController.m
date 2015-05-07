//
//  LeaderViewController.m
//  BlockDump
//
//  Created by Sam on 4/25/15.
//  Copyright (c) 2015 cyberplays. All rights reserved.
//

#import "LeaderViewController.h"
#import "CustomCell.h"
#import "Player.h"

@interface LeaderViewController ()

@property (strong, nonatomic) NSMutableArray *players;

@end



@implementation LeaderViewController

@synthesize userLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Player *p1 = [[Player alloc] initWithName:(NSString *)@"Malcolm Navarro" andScore:(NSInteger *) 203050];
    Player *p2 = [[Player alloc] initWithName:(NSString *)@"Eric Bledsoe" andScore:(NSInteger *) 198400];
    Player *p3 = [[Player alloc] initWithName:(NSString *)@"Sam Hagan" andScore:(NSInteger *) 150900];
    Player *p4 = [[Player alloc] initWithName:(NSString *)@"Ron Swanson" andScore:(NSInteger *) 53000];
    Player *p5 = [[Player alloc] initWithName:(NSString *)@"Bill Belichick" andScore:(NSInteger *) 2000];
    
    
    //ADD PLAYERS TO ARRAY
    _players = [NSMutableArray arrayWithObjects: p1, p2, p3, p4, p5, nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_players count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCell = @"myCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil]forCellReuseIdentifier:myCell];
        cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    }
    
    //GET TEMP PLAYER FROM NSMutableArray + CONVERT NSINTEGER TO STRING
    Player *temp = [_players objectAtIndex:indexPath.row];
    NSString *highscore = [NSString stringWithFormat: @"%ld", (long)temp.highscore];
    
    cell.nameLabel.text = temp.name;
    cell.scoreLabel.text = highscore;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLocation:(CLLocation *) location {
    userLocation = [[CLLocation alloc] init];
    userLocation = location;
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
