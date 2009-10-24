

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface CCDCDateController : UIViewController <CPPlotDataSource> {
    IBOutlet CPLayerHostingView *hostView;
    CPXYGraph *graph;
    NSArray *plotData;
}
@property(readwrite, retain, nonatomic) NSArray *plotData;
@end

