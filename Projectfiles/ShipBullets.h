//
//  ShipBullets.h
//  AngryVeggie
//
//  Created by Danny on 6/27/13.
//
//

#import "Entity.h"

@interface ShipBullets : Entity{
    float distanceToSpawn;
    float angle;

}

//information about the monster
@property (nonatomic, assign) float boundingZone;
@property (nonatomic, assign) float boundingZoneAngle1;
@property (nonatomic, assign) float boundingZoneAngle2;
@property (nonatomic, assign) float hitZone;
@property (nonatomic, assign) float hitZoneAngle1;
@property (nonatomic, assign) float hitZoneAngle2;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) NSInteger damage;
@property (nonatomic, assign) float distanceFromWorld;
//whether the unit is attacked
@property (nonatomic, assign) BOOL areaOfEffect;
//the amount of damage the unit does
@property (nonatomic, assign) NSInteger areaOfEffectDamage;
@property (nonatomic, assign) BOOL attacked;
- (id)initWithMonsterPicture;
- (void)spawn;
- (void)gotHit;
-(void)reset;

@end
