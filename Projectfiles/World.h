//
//  World.h
//  AngryVeggie
//
//  Created by Danny on 6/18/13.
//
//

#import "CCSprite.h"

@interface World : CCSprite

+(id) createEntity;
-(id) initWithEntityImage;
-(void)reset;
@end
