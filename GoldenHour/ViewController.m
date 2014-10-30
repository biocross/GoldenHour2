//
//  ViewController.m
//  GoldenHour
//
//  Created by Siddharth on 28/10/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkBlue) userInfo:nil repeats:YES];

    
    self.incidentButton.enabled = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"skipInitialScreen"];
    
    if(number.boolValue)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"skipInitialScreen"];
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] isEqualToString:@"doctor"])
        {
            [self performSegueWithIdentifier:@"doctorSegue" sender:self];
        }
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] isEqualToString:@"civilian"])
        {
            [self performSegueWithIdentifier:@"civillian" sender:self];
        }
    }
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    return;
}

- (IBAction)reportPressed:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                                                   message:@"Your location will be sent to indentify this incident."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
    
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //Insert URL here
                                                              if(!self.cbManager) {
                                                                  self.cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
                                                              }
                                                              
                                                              self.cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
                                                              if(!self.cbManager) {
                                                                  self.cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
                                                              }
                                                              
                                                              /*
                                                               When the application requests to start scanning for bluetooth devices that is when the user is presented with a consent dialog.
                                                               */
                                                              [self.cbManager scanForPeripheralsWithServices:nil options:nil];
                                                              [self.cbManager stopScan];
                                                              
                                                              
                                                              [delegate startBroadcastingIncident];
                                                              
                                                              self.label.alpha = 1;
                                                              self.label.text = @"Thank You for helping! Your Phone is now beaconing your locationto get help here faster. Please DON'T lock your phone.";
                                                          }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {}];
    
    [alert addAction:okayAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) checkBlue{
    
    
    if(![self checkBluetoothAccess])
    {
        self.incidentButton.enabled = NO;
        self.label.text = @"Please enable bluetooth to continue";
        self.label.textColor = [UIColor redColor];
    }
    else{
        self.incidentButton.enabled = YES;
        self.label.text = @"Bluetooth Enabled";
        self.label.textColor = [UIColor greenColor];
        self.label.alpha = 0;
    }
}

- (BOOL)checkBluetoothAccess {
    if(!self.cbManager) {
        self.cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    
    /*
     We can ask the bluetooth manager ahead of time what the authorization status is for our bundle and take the appropriate action.
     */
    CBCentralManagerState state = [self.cbManager state];
    if(state == CBCentralManagerStatePoweredOn)
    {
        return YES;
    }
    return NO;
}

- (IBAction)doctorTapped:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"doctor" forKey:@"userType"];
}

- (IBAction)civillianTapped:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"civilian" forKey:@"userType"];
}


@end
