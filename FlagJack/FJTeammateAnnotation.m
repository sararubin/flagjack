//
//  FJTeammateAnnotation.m
//  FlagJack
//
//  Created by srubin13 on 4/21/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJTeammateAnnotation.h"

@interface FJTeammateAnnotation ()

@end

@implementation FJTeammateAnnotation

- (FJTeammateAnnotation*) initWithCoordinate: (CLLocationCoordinate2D)coordinate
                                   andName: (NSString*)name
                               andLocation: (NSString*)location {
    _coordinate = coordinate;
    _name = name;
    _location = location;
    _isFrozen = NO;
    
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _location;
}

@end
