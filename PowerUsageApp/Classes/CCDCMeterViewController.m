//
//  CCDCMeterViewController.m
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/24/09.
//  Copyright 2009 RobotCrowd. All rights reserved.
//

#import "CCDCMeterViewController.h"


@implementation CCDCMeterViewController

@synthesize meterValue1;
@synthesize meterValue2;
@synthesize meterValue3;
@synthesize meterValue4;
@synthesize meterValue5;
@synthesize meterValue6;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  meterValues[0] = meterValue1;
  meterValues[1] = meterValue2;
  meterValues[2] = meterValue3;
  meterValues[3] = meterValue4;
  meterValues[4] = meterValue5;
  meterValues[5] = meterValue6;
  
  // Load the previous recordings from disk
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  if (!documentsDirectory) {
    NSAssert(NO, @"Documents directory not found!");
  }
  
  NSString *recordingsFile = [documentsDirectory stringByAppendingPathComponent:@"recordings.plist"];
  
  meterRecordings = [[NSMutableArray alloc] initWithContentsOfFile:recordingsFile];
  
  if (meterRecordings == nil)
    meterRecordings = [[NSMutableArray alloc] init];
  else {
    NSDictionary *lastRecording = [meterRecordings lastObject];
    NSNumber *lastMeterValue = [lastRecording objectForKey:@"meterValue"];
    NSString *meterValueAsString =  [lastMeterValue stringValue];
    
    int j = 5;
    for (int i = [meterValueAsString length] -1; i >= 0 ; i--) {
      meterValues[j].text = [NSString stringWithFormat:@"%c", [meterValueAsString characterAtIndex:i]];
      j--;
    }
  }
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)storeMeterReading:(id)sender {
  
  NSString *meterField = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                          meterValue1.text, meterValue2.text, meterValue3.text,
                          meterValue4.text, meterValue5.text, meterValue6.text];
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  NSNumber *meterValue = [numberFormatter numberFromString:meterField];
  [numberFormatter release];
  
  NSLog(@"Storing %i", [meterValue intValue]);
  
  NSMutableDictionary *recording = [[NSMutableDictionary alloc] init];
  [recording setValue:meterValue forKey:@"meterValue"];
  [recording setValue:[NSDate date] forKey:@"timestamp"];
  
  [meterRecordings addObject:recording];
  [recording release];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  if (!documentsDirectory) {
    NSAssert(NO, @"Documents directory not found!");
  }
  
  NSString *recordingsFile = [documentsDirectory stringByAppendingPathComponent:@"recordings.plist"];
  
  if (![meterRecordings writeToFile:recordingsFile atomically:YES])
    NSLog(@"Failed to store recording");
}

- (IBAction)valueEntered:(id)sender
{
  if (sender == meterValue1)
    [meterValue2 becomeFirstResponder];
  if (sender == meterValue2)
    [meterValue3 becomeFirstResponder];
  if (sender == meterValue3)
    [meterValue4 becomeFirstResponder];
  if (sender == meterValue4)
    [meterValue5 becomeFirstResponder];
  if (sender == meterValue5)
    [meterValue6 becomeFirstResponder];
  if (sender == meterValue6)
    [meterValue6 resignFirstResponder];
}

- (void)dealloc {
  [meterRecordings release];
  [super dealloc];
}


@end
