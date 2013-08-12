//
//  AlertSign.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/18/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "AlertSign.h"

@implementation AlertSign
+(id) createEntity
{
	id myEntity = [[self alloc] initWithEntityImage];
    
    //Don't worry about this, this is memory management stuff that will be handled for you automatically
#ifndef KK_ARC_ENABLED
	[myEntity autorelease];
#endif // KK_ARC_ENABLED
    return myEntity;
}

-(id) initWithEntityImage
{
	// Loading the Entity's sprite using a file, is a ship for now but you can change this
	if ((self = [super initWithFile:@"skipahead.png"]))
	{
        [self runAction:[CCRepeatForever actionWithAction:[CCBlink actionWithDuration:2.4f blinks:1]]];

	}
	return self;
}



@end
