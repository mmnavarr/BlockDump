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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    Player *p1 = [[Player alloc] initWithName:(NSString *)@"Malcolm Navarro" andScore:(NSInteger) 203050];
    Player *p2 = [[Player alloc] initWithName:(NSString *)@"Eric Bledsoe" andScore:(NSInteger) 198400];
    Player *p3 = [[Player alloc] initWithName:(NSString *)@"Sam Hagan" andScore:(NSInteger) 160900];
    Player *p4 = [[Player alloc] initWithName:(NSString *)@"Ron Swanson" andScore:(NSInteger) 160300];
    Player *p5 = [[Player alloc] initWithName:(NSString *)@"Jim Fisher" andScore:(NSInteger) 151900];
    Player *p6 = [[Player alloc] initWithName:(NSString *)@"Bill Nye" andScore:(NSInteger) 139210];
    Player *p7 = [[Player alloc] initWithName:(NSString *)@"Tom Brady" andScore:(NSInteger) 138150];
    Player *p8 = [[Player alloc] initWithName:(NSString *)@"Aaron Hernandez" andScore:(NSInteger) 121000];
    Player *p9 = [[Player alloc] initWithName:(NSString *)@"Wilt Chamberlain" andScore:(NSInteger) 100850];
    Player *p10 = [[Player alloc] initWithName:(NSString *)@"Barack Obama" andScore:(NSInteger) 99330];
    Player *p11 = [[Player alloc] initWithName:(NSString *)@"Albert Einstein" andScore:(NSInteger) 73050];
    Player *p12 = [[Player alloc] initWithName:(NSString *)@"Rose Mary" andScore:(NSInteger) 52000];
    
    
    //ADD PLAYERS TO ARRAY
    _players = [NSMutableArray arrayWithObjects: p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, nil];
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
