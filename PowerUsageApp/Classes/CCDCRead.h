//
//  CCDCRead.h
//  PowerUsageApp
//
//  Created by Andreas B. Westh on 10/24/09.
//  Copyright 2009 abwesth.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCDCRead : NSObject {

	NSNumber *idRead;
	NSNumber *pwrConsumption;
	NSString *note;
}
@property (nonatomic, retain) NSNumber *idRead;
@property (nonatomic, retain) NSNumber *pwrConsumption;
@property (nonatomic, retain) NSString *note;

@end
