//
//  PowerUsageAppAppDelegate.h
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/23/09.
//  Copyright RobotCrowd 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerUsageAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
