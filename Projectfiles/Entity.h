//
//  Entity.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/16/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCSprite.h"

@interface Entity : CCSprite
{
    float radiusOfWorld;
    float speed;
}

@property (nonatomic, assign) float angle;
//checks if the unit is visible
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) NSInteger damage;
@property (nonatomic, assign) BOOL areaOfEffect;
//the amount of damage the unit does
@property (nonatomic, assign) NSInteger areaOfEffectDamage;
//whether the unit is attacked
@property (nonatomic, assign) BOOL attacked;
@property (nonatomic, assign) float boundingZone;
@property (nonatomic, assign) float boundingZoneAngle1;
@property (nonatomic, assign) float boundingZoneAngle2;
@property (nonatomic, assign) float hitZone;
@property (nonatomic, assign) float hitZoneAngle1;
@property (nonatomic, assign) float hitZoneAngle2;
//the direction the unit moves toward
@property (nonatomic, assign) BOOL moveDirection;

- (void)gotHit:(int)damage;
-(void)changePosition;
-(void)reset;
@end

