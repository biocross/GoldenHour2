//
//  ViewController.h
//  GoldenHour
//
//  Created by Siddharth on 28/10/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *cbManager;

@property (weak, nonatomic) IBOutlet UIButton *incidentButton;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

