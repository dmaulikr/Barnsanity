//
//  World.m
//  AngryVeggie
//
//  Created by Danny on 6/18/13.
//
//

#import "World.h"
#import "GamePlayLayer.h"

@implementation World


//This is the method other classes should call to create an instance of Entity
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
	if ((self = [super initWithFile:@"world.png"]))
	{
	}
	return self;
}


@end
