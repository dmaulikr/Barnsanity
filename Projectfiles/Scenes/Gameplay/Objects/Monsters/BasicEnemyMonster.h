/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameMechanics.h"
#import "Monster.h"

//#import "Component.h"
@class Component;

//By subclassing CCSprite you can add attributes like hitpoints and internal logic
@interface BasicEnemyMonster : Monster
{
    //reward for killing this unit
    int reward;
    int energyReward;
}


- (id)initWithMonsterPicture;
- (void)spawnAt:(float) angleOfLocation;
- (void)gotHit:(int)damage;
- (void)attack;
-(void)setStats;
-(void) reset;
@end
