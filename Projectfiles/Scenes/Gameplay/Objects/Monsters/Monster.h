//
//  Monster.h
//  Veg_V_Fruit
//
//  Created by Danny on 6/28/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Entity.h"
#import "GameMechanics.h"

#define right 0
#define left 1

@interface Monster : Entity{
    NSString *nameOfMonster;

    //angle of the position the unit is at
    //the change in angle as the unit moves
    float speedAngle;

    //animations of the character
    NSMutableArray *animationFramesRunning;
    CCAction *run;
    NSMutableArray *animationFramesAttack;
    CCSequence *attack;
    NSMutableArray *animationFramesPlant;
    CCSequence *plant;
    NSMutableArray *animationFramesSpawn;
    CCSequence *spawn;
    BOOL hitDidRun;
    CCBlink *blink;
    BOOL blinkDidRun;
    NSMutableDictionary *stats;
    int spawnDelayInitial;
    int spawnDelayTimer;
    
}

//information about the monster

@property (nonatomic, assign) float radiusToSpawn;
@property (nonatomic, assign) float radiusToSpawnDelta;
@property (nonatomic, assign) float angle;
@property (nonatomic, assign) float range;
//units health info
@property (nonatomic, assign) NSInteger hitPoints;
@property (nonatomic, assign) NSInteger hitPointsInit;

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
//whether the unit is attacked
@property (nonatomic, assign) BOOL areaOfEffect;
//the amount of damage the unit does
@property (nonatomic, assign) NSInteger areaOfEffectDamage;

//whether the unit is attacking
@property (nonatomic, assign) BOOL ableToAttack;
//whether the unit is attacked
@property (nonatomic, assign) BOOL invincible;

- (id)initWithMonsterPicture;
- (void)spawnAt:(float)angleOfLocation;
- (void)gotHit:(int)damage;
- (void)attack;
-(void)changePosition;
-(void)destroy;
-(BOOL)collisionWithHitZone:(Monster *)monster;
@end
