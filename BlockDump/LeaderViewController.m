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
@end


@implementation LeaderViewController

@synthesize userLocation;
@synthesize responseData = _responseData;
@synthesize players = _players;



- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [self asyncGET];
    
    Player *p1 = [[Player alloc] initWithName:(NSString *)@"LOADING DATA" andScore:(NSInteger) 80085 andLat:0.0 andLng:0.0];
    
    //ADD PLAYERS TO ARRAY
    _players = [NSMutableArray arrayWithObjects: p1, nil];
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



//ASYNC HTTPGET REQUEST WITH ITS REQUIRED METHODS BELOW
- (void) asyncGET {
    NSURL *url = [NSURL URLWithString:@"http://www.cyberplays.com/blockdump/get_highscore.php"];
    //CREATE REQUEST
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //CREATE URL CONNECTION TO FIRE REQUREST
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    [self parseJSON:txt];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //THE REQUEST FAILED
}

//PARSE THE JSON RECEIVED INTO A NSMUTABLEARRAY
- (void) parseJSON:(NSString *)jsonString {
    
    NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
    //BOOL success = TRUE;
    //CLEAR ARRAY FOR NEW DATA
    [_players removeAllObjects];
    
    if (JSONdata != nil) {
        // {} = NSDictionary   [] = NSArray
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSONdata options:0 error:&jsonError];
        
        //IF NO ERROR, LETS PARSE
        if (jsonError == nil) {
            if (dic == (NSDictionary *)[NSNull null]) {
                NSLog(@"Initial NSDictionary is NULL;");
            }
            
            if ([dic objectForKey:@"highscores"] != [NSNull null]) {
                //GET HIGHSCORES ARRAY
                NSArray *itemArray = [dic objectForKey:@"highscores"];
                NSLog(@"Size of item array: %ld", [itemArray count]);
                
                //LOOP THROUGH HIGHSCORES DICTIONARIES TO CREATE THE PLAYER OBJECTS
                for (NSDictionary *itemDic in itemArray){
                    Player *temp;
                    
                    NSString *name = [dic objectForKey:@"player_name"];
                    NSNumber *scoreX = (NSNumber *)[dic objectForKey:@"player_score"];
                    NSNumber *latX = (NSNumber *)[dic objectForKey:@"player_lat"];
                    NSNumber *lngX = (NSNumber *)[dic objectForKey:@"player_lng"];
                    NSLog(@"Player name: %@ with highscore of %@ located @ (%@,%@)", name, scoreX, latX, lngX);
                    
                    //NOW CONVERT NSNUMBER TO TYPES PLAYER OBJECT NEEDS
                    NSInteger score = [scoreX intValue];
                    double lat = [latX doubleValue];
                    double lng = [lngX doubleValue];
                    
                    temp = [[Player alloc] initWithName:name andScore:score andLat:lat andLng:lng];
                    [_players addObject:temp];
                }
                //RELOAD TABLEVIEW WITH NEW DATA
                [self.tableView reloadData];
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLocation:(CLLocation *) location {
    userLocation = [[CLLocation alloc] init];
    userLocation = location;
}


@end
