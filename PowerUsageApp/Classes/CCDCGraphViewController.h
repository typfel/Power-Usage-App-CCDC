//
//  CCDCGraphViewController.h
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/24/09.
//  Copyright 2009 RobotCrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface CCDCGraphViewController : UIViewController <CPPlotDataSource> {
	IBOutlet CPLayerHostingView *hostView;
	CPXYGraph *graph;
	NSMutableArray *dataForPlot;
	
}
- (NSArray *)loadAndPreprocessData;
- (NSNumber * ) maxkW;
@property(readwrite, retain, nonatomic) NSMutableArray *dataForPlot;

@end
