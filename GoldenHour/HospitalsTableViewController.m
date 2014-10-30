//
//  HospitalsTableViewController.m
//  GoldenHour
//
//  Created by Pratham Mehta on 29/10/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "HospitalsTableViewController.h"
#import "AppDelegate.h"

@interface HospitalsTableViewController () <CLLocationManagerDelegate>


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *places;

@end

@implementation HospitalsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self updateTable:nil];
    
    self.timer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(updateTable:) userInfo:nil repeats:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void) updateTable:(NSTimer *)timer
{
    if(((AppDelegate *)[[UIApplication sharedApplication] delegate]).location)
    {
        CLLocation *location = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).location;
        
        NSString *apiKey = @"AIzaSyBH0_UDW6QuTaYTmpLg4i-6bbc0elMwuB0";
        
        
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&types=doctor&sensor=true&key=%@&rankby=distance", location.coordinate.latitude, location.coordinate.longitude, apiKey];

        NSURL *googleRequestURL=[NSURL URLWithString:url];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
            
        });
    }
}

- (void) fetchedData:(NSData *) data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);
    
    self.places = places;
    if(self.places) [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hospitalCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.places objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.places objectAtIndex:[indexPath row]] objectForKey:@"vicinity"];
    
    return cell;
}


@end
