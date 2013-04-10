//
//  FJFlagAnnotation.m
//  FlagJack
//
//  Created by Ian Guerin on 4/9/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJFlagAnnotation.h"

@implementation FJFlagAnnotation

- (FJFlagAnnotation*) initWithCoordinate: (CLLocationCoordinate2D) coordinate andTitle: (NSString*) title andSubtitle: (NSString*) subtitle {
	_coordinate = coordinate;
	_subtitle = subtitle;
	_title = title;
	
	return self;
}

@end
