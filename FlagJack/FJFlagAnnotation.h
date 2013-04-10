//
//  FJFlagAnnotation.h
//  FlagJack
//
//  Created by Ian Guerin on 4/9/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FJFlagAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString* subtitle;
@property (nonatomic, readonly, copy) NSString* title;

- (FJFlagAnnotation*) initWithCoordinate: (CLLocationCoordinate2D) coordinate andTitle: (NSString*) title  andSubtitle: (NSString*) subtitle ;

@end