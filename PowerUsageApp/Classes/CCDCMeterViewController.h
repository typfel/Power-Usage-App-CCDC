//
//  CCDCMeterViewController.h
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/24/09.
//  Copyright 2009 RobotCrowd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCDCMeterViewController : UIViewController {
  UITextField *meterValue1;
  UITextField *meterValue2;
  UITextField *meterValue3;
  UITextField *meterValue4;
  UITextField *meterValue5;
  UITextField *meterValue6;
  
  UITextField *meterValues[6];
  NSMutableArray *meterRecordings;
}

@property (nonatomic, assign) IBOutlet UITextField *meterValue1;
@property (nonatomic, assign) IBOutlet UITextField *meterValue2;
@property (nonatomic, assign) IBOutlet UITextField *meterValue3;
@property (nonatomic, assign) IBOutlet UITextField *meterValue4;
@property (nonatomic, assign) IBOutlet UITextField *meterValue5;
@property (nonatomic, assign) IBOutlet UITextField *meterValue6;

- (IBAction)storeMeterReading:(id)sender;
- (IBAction)valueEntered:(id)sender;

@end
