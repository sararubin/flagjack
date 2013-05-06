//
//  FJEnemyAnnotation.m
//  FlagJack
//
//  Created by srubin13 on 4/21/13.
//  Copyright (c) 2013 Guerin. All rights reserved.
//

#import "FJEnemyAnnotation.h"

@implementation FJEnemyAnnotation

- (FJEnemyAnnotation*) initWithCoordinate: (CLLocationCoordinate2D)coordinate andName: (NSString*)name andLocation: (NSString*)location andIdentifier: (int) ident
{
    _coordinate = coordinate;
    _name = name;
	_displayName = @"Enemy";
    _location = location;
    _isFrozen = NO;
	_ident = ident;
    
    return self;
}

- (NSString *)title {
    return _displayName;
}

- (NSString *)subtitle {
    return _location;
}

- (void)print {
    NSLog(@"Teammate %@", _name);
}

@end
