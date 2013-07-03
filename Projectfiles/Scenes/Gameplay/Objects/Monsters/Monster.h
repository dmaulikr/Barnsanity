//
//  Monster.h
//  Veg_V_Fruit
//
//  Created by Danny on 6/28/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCSprite.h"
#import "GameMechanics.h"

#define right 0
#define left 1

@interface Monster : CCSprite{
    //radius of the world
    float radiusOfWorld;
    //angle of the position the unit is at
    float angle;
    //the change in angle as the unit moves
    float speedAngle;
    //the direction the unit moves toward
    bool moveDirection;
    //animations of the character
    NSMutableArray *animationFramesRunning;
    CCAction *run;
    NSMutableArray *animationFramesAttack;
    CCSequence *attack;
    BOOL hitDidRun;
    CCBlink *blink;
    BOOL blinkDidRun;
    NSMutableDictionary *stats;
}

//information about the monster

//units health info
@property (nonatomic, assign) NSInteger hitPoints;
//whether the unit is visible
@property (nonatomic, assign) BOOL visible;
//whether the unit is visible
@property (nonatomic, assign) BOOL alive;
//whether the unit is attacking
@property (nonatomic, assign) BOOL attacking;
//whether the unit is attacked
@property (nonatomic, assign) BOOL attacked;
//the amount of damage the unit does
@property (nonatomic, assign) NSInteger damage;
//whether the unit should move
@property (nonatomic, assign) BOOL move;
// defines a hit zone, which is smaller as the sprite, only if this hit zone is hit the knight is injured
@property (nonatomic, assign) CGRect hitZone;
//whether the unit is attacked
@property (nonatomic, assign) BOOL areaOfEffect;
//the amount of damage the unit does
@property (nonatomic, assign) NSInteger areaOfEffectDamage;

- (id)initWithMonsterPicture;
- (void)spawnAt:(float)angleOfLocation;
- (void)gotHit:(int)damage;
- (void)attack;
-(void)changePosition;
@end
