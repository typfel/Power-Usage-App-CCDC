//
//  CCDCGraphViewController.m
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/24/09.
//  Copyright 2009 RobotCrowd. All rights reserved.
//

#import "CCDCGraphViewController.h"


@implementation CCDCGraphViewController

@synthesize dataForPlot;

- (void)viewDidLoad {
	[super viewDidLoad];
	NSDate *refDate = [NSDate dateWithNaturalLanguageString:@"0:00 Jan 1, 2007"];
    NSTimeInterval oneDay = 24 * 60 * 60;
	// Create graph from theme
	graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
	CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
	[graph applyTheme:theme];
	CPLayerHostingView *hostingView = (CPLayerHostingView *)self.view;
	hostingView.hostedLayer = graph;
	
	graph.paddingLeft = 5.0;
	graph.paddingTop = 5.0;
	graph.paddingRight = 5.0;
	graph.paddingBottom = 5.0;
	
	// Setup plot space
	CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
	
	plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat(20.0)];
	plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.0) length:CPDecimalFromFloat([[self maxkW] floatValue]+20)];
	
	
    // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
    CPXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPDecimalFromFloat(oneDay);
    x.constantCoordinateValue = CPDecimalFromString(@"4");
    x.minorTicksPerInterval = 5;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTimeFormatter *timeFormatter = [[[CPTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
    timeFormatter.referenceDate = refDate;
    x.axisLabelFormatter = timeFormatter;
	
	CPXYAxis *y = axisSet.yAxis;
	y.majorIntervalLength = CPDecimalFromString(@"5");
	y.minorTicksPerInterval = 50;
	y.constantCoordinateValue = CPDecimalFromString(@"4");
	NSArray *exclusionRanges = [NSArray arrayWithObjects:
								[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
								[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
								[CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(3.99) length:CPDecimalFromFloat(0.02)],
								nil];
	y.labelExclusionRanges = exclusionRanges;
	
	// Create a blue plot area
	
	CPScatterPlot *boundLinePlot = [[[CPScatterPlot alloc] init] autorelease];
	boundLinePlot.identifier = @"Blue Plot";
	boundLinePlot.dataLineStyle.miterLimit = 1.0f;
	boundLinePlot.dataLineStyle.lineWidth = 3.0f;
	boundLinePlot.dataLineStyle.lineColor = [CPColor blueColor];
	boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
	
	// Do a blue gradient
	CPColor *areaColor1 = [CPColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
	CPGradient *areaGradient1 = [CPGradient gradientWithBeginningColor:areaColor1 endingColor:[CPColor clearColor]];
	areaGradient1.angle = -90.0f;
	CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient1];
	boundLinePlot.areaFill = areaGradientFill;
	boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];    
	
	// Add plot symbols
	CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPColor blackColor];
	CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
	plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
	plotSymbol.lineStyle = symbolLineStyle;
	plotSymbol.size = CGSizeMake(10.0, 10.0);
	boundLinePlot.plotSymbol = plotSymbol;
	
	// Create a green plot area
	/*CPScatterPlot *dataSourceLinePlot = [[[CPScatterPlot alloc] init] autorelease];
	 dataSourceLinePlot.identifier = @"Green Plot";
	 dataSourceLinePlot.dataLineStyle.lineWidth = 3.f;
	 dataSourceLinePlot.dataLineStyle.lineColor = [CPColor greenColor];
	 dataSourceLinePlot.dataSource = self;
	 [graph addPlot:dataSourceLinePlot];
	 
	 // Put an area gradient under the plot above
	 CPColor *areaColor = [CPColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
	 CPGradient *areaGradient = [CPGradient gradientWithBeginningColor:areaColor endingColor:[CPColor clearColor]];
	 areaGradient.angle = -90.0f;
	 areaGradientFill = [CPFill fillWithGradient:areaGradient];
	 dataSourceLinePlot.areaFill = areaGradientFill;
	 dataSourceLinePlot.areaBaseValue = CPDecimalFromString(@"1");
	 */
	
	
	// Add some initial data
	/*NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	 NSUInteger i;
	 for ( i = 0; i < 60; i++ ) {
	 id x = [NSNumber numberWithFloat:1+i]; // days, right?
	 id y = [NSNumber numberWithFloat:1.2*i*rand()/RAND_MAX]; // PWR consumption
	 [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	 }*/
	self.dataForPlot = [self loadAndPreprocessData];

	NSLog(@"self.maxkW :  %d ", [[self maxkW] intValue]);
}

-(void)changePlotRange 
{
	// Setup plot space
	CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0) length:CPDecimalFromFloat(3.0 + 2.0)];
	plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0) length:CPDecimalFromFloat(3.0 + 2.0*rand()/RAND_MAX)];
}

- (NSArray *)loadAndPreprocessData
{
	// Load the previous recordings from disk
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		NSAssert(NO, @"Documents directory not found!");
	}
	
	NSString *recordingsFile = [documentsDirectory stringByAppendingPathComponent:@"recordings.plist"];
	
	NSArray *meterRecordings = [[NSMutableArray alloc] initWithContentsOfFile:recordingsFile];
	
	if (meterRecordings == nil)
		meterRecordings = [[NSMutableArray alloc] init];
	
	NSNumber *lastMeterValue = [NSNumber numberWithInt:0];
	NSMutableArray *processedData = [NSMutableArray array];
	for (NSDictionary *recording in meterRecordings) {
		NSNumber *meterValue = [recording objectForKey:@"meterValue"];
		NSNumber *deltaValue = [NSNumber numberWithInt:[meterValue intValue] ];
		NSNumber *timestamp = [NSNumber numberWithInt:[meterRecordings indexOfObject:recording]];
		lastMeterValue = meterValue;
		NSLog(@"  timestamp: %@   value :%@", [timestamp description], [deltaValue description]);
		[processedData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:timestamp, @"x", deltaValue, @"y", nil]];
	}
	
	return processedData;
}


// Returns the max kW value-
- (NSInteger * ) maxkW{
	// Load the previous recordings from disk
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		NSAssert(NO, @"Documents directory not found!");
	}
	
	NSString *recordingsFile = [documentsDirectory stringByAppendingPathComponent:@"recordings.plist"];
	NSArray *meterRecordings = [[NSMutableArray alloc] initWithContentsOfFile:recordingsFile];
	
	if (meterRecordings == nil)
		meterRecordings = [[NSMutableArray alloc] init];
	
	
	
	NSNumber *maxKWValueSoFar = [NSNumber numberWithInt:0];
	NSMutableArray *processedData = [NSMutableArray array];
	for (NSDictionary *recording in meterRecordings) {
		NSNumber *meterValue = [recording objectForKey:@"meterValue"];
		if (meterValue > maxKWValueSoFar) {
			maxKWValueSoFar = meterValue;
		}
	}
	
	return maxKWValueSoFar;
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
	return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
	// Green plot gets shifted above the blue
	if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"])
	{
		if ( fieldEnum == CPScatterPlotFieldY ) 
			num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
	}
	return num;
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


- (void)dealloc {
	[dataForPlot release];
	[super dealloc];
}


@end
