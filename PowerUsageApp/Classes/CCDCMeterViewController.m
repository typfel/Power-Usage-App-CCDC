//
//  CCDCMeterViewController.m
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/24/09.
//  Copyright 2009 RobotCrowd. All rights reserved.
//

#import "CCDCMeterViewController.h"


@implementation CCDCMeterViewController

@synthesize meterField;

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
  NSLog(@"Storing %@", meterField.text);
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  NSNumber *meterValue = [numberFormatter numberFromString:meterField.text];
  [numberFormatter release];
  
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

- (void)dealloc {
  [meterRecordings release];
  [super dealloc];
}


@end
