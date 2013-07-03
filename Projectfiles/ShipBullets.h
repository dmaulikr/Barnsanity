//
//  ShipBullets.h
//  AngryVeggie
//
//  Created by Danny on 6/27/13.
//
//

#import "CCSprite.h"

@interface ShipBullets : CCSprite{
    float radiusOfWorld;
    float distanceToSpawn;
    float speed;
    float angle;
    float distanceFromWorld;
}

//information about the monster
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) NSInteger damage;
//whether the unit is attacked
@property (nonatomic, assign) BOOL areaOfEffect;
//the amount of damage the unit does
@property (nonatomic, assign) NSInteger areaOfEffectDamage;
@property (nonatomic, assign) BOOL attacked;
- (id)initWithMonsterPicture;
- (void)spawn;
- (void)gotHit;

@end
