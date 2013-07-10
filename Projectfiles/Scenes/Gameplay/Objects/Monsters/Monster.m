//
//  Monster.m
//  Veg_V_Fruit
//
//  Created by Danny on 6/28/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Monster.h"
#import "GameMechanics.h"


@implementation Monster
- (id)initWithMonsterPicture
{
    @throw @"- (id)initWithMonsterPicture has to be implemented in Subclass.";
}

- (void)spawnAt:(float) angleOfLocation
{
    @throw @"- (void)spawnAt has to be implemented in Subclass.";
}

- (void)attack{
    @throw @"- (void)attack has to be implemented in Subclass.";
}

- (void)gotHit:(int)damage
{
    @throw @"- (void)gotHit has to be implemented in Subclass.";
}

-(void)changePosition{
    //move the monster M_PI/480 in a direction
    if(moveDirection==left){
        angle+=speedAngle;
    }else{
        angle-=speedAngle;
    }
    float deltaX=radiusToSpawn*cos(angle);
    float deltaY=radiusToSpawn*sin(angle);
    CGPoint newPosition = ccp(deltaX, deltaY);
    
    
    self.rotation=CC_RADIANS_TO_DEGREES(-angle+M_PI_2);
    
    [self setPosition:newPosition];
}

- (void)draw
{
    [super draw];
    
#ifdef DEBUG
    // visualize the hit zone
    
    ccDrawColor4B(100, 0, 255, 255); //purple, values range from 0 to 255
    CGPoint origin = ccp(self.hitZone.origin.x - self.position.x, self.hitZone.origin.y - self.position.y);
    CGPoint destination = ccp(origin.x + self.hitZone.size.width, origin.y + self.hitZone.size.height);
    ccDrawRect(origin, destination);
    
    
#endif
}

@end
