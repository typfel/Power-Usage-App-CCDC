//
//  CCDCMeterViewController.h
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/24/09.
//  Copyright 2009 RobotCrowd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCDCMeterViewController : UIViewController {
  UITextField *meterField;
}

@property (nonatomic, assign) IBOutlet UITextField *meterField;

- (IBAction)storeMeterReading:(id)sender;

@end
