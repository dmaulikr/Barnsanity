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
    if(self.moveDirection==left){
        self.angle+=speed;
            self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
        self.hitZoneAngle1=self.angle+self.hitZone;
        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
        self.hitZoneAngle2=self.angle;
        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
    }else{
       self.angle-=speed;
            self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
        self.hitZoneAngle1=self.angle;
        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
        self.hitZoneAngle2=self.angle-self.hitZone;
        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
    }
    
    self.boundingZoneAngle1=self.angle+self.boundingZone;
    self.boundingZoneAngle1=fmodf(self.boundingZoneAngle1+2*M_PI, 2*M_PI);
    self.boundingZoneAngle2=self.angle-self.boundingZone;
    self.boundingZoneAngle2=fmodf(self.boundingZoneAngle2+2*M_PI, 2*M_PI);
    
    
    float deltaX=radiusOfWorld*cos(self.angle);
    float deltaY=radiusOfWorld*sin(self.angle);
    CGPoint newPosition = ccp(deltaX, deltaY);
    
    
    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
    
    [self setPosition:newPosition];
}

-(void) destroy{
    //turn invisible
    
    self.visible = FALSE;
    self.alive=FALSE;
    self.move=FALSE;
    self.position = ccp(-MAX_INT, 0);
    
    //stop all actions and pause update
    [self stopAllActions];
    
}

//- (void)draw
//{
//    
////
////    
////    [super draw];
////    
////#ifdef DEBUG
////    // visualize the hit zone
////        CGPoint monsterCenter = ccp(self.position.x + self.contentSize.width / 2, self.position.y + self.contentSize.height / 2);
////    ccColor4F rectColor = ccc4f(100, 0, 255, 255); //parameters correspond to red, green, blue, and alpha (transparancy)
////    ccDrawSolidRect(ccp(monsterCenter.x-sinf(self.boundingRadius),monsterCenter.y-cosf(self.boundingRadius)), ccp(monsterCenter.x+sinf(self.boundingRadius),monsterCenter.y+cosf(self.boundingRadius)), rectColor);
////    
////    
////    
////#endif
//}

@end
