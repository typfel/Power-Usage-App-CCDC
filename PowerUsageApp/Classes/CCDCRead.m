//
//  CCDCRead.m
//  PowerUsageApp
//
//  Created by Andreas B. Westh on 10/24/09.
//  Copyright 2009 abwesth.com. All rights reserved.
//

#import "CCDCRead.h"


@implementation CCDCRead
@synthesize idRead, pwrConsumption, note;
-(void)toStringwhoAmI{
	
	NSLog(@"toStringwhoAmI a Reading %d,",self.pwrConsumption);	
}

-(id)initWithMyValues: (NSNumber *) aPwrConValue
			 withNote: (NSString *) aNote
			beastTest: (NSString * ) aTest{
	NSLog(@"initWithValues %d and %@",aPwrConValue,aNote);
	self = [super init];
	if(nil != self) { 
		self.pwrConsumption = aPwrConValue;
		self.note = aNote;
	} 
	return self;
	
}
@end
