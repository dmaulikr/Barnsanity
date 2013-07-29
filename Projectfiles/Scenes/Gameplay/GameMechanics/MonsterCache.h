//
//  EnemyCache.h
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/17/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "CCNode.h"
#import "Barn.h"
#import "Bomb.h"
/**
 This class stores all enemies. This is necessary, to be able to draw all enemies on one BatchNode.
 Drawing all enemies on one BatchNode is important for performance reasons.
 **/

@interface MonsterCache : CCNode
{
    //batch for the different kind of monster units
    CCNode *enemyMonsters;
    CCNode *playerMonster;
    CCNode *wallObjects;
    CCNode *shipBullets;
    CCNode *seeds;
    //a dictionary to hold the array of different monster units
    NSMutableDictionary* monster;
    NSMutableDictionary* monsterClass;
    NSMutableArray *wallList;
    NSInteger wallSpawnProp;
    // count the updates (used to determine when monsters should be spawned)
    int updateCount;
}
@property (nonatomic, weak) Barn *enemyBarn;
@property (nonatomic, weak) Barn *playerBarn;
@property (nonatomic, assign) BOOL  *enemyBarnUnderAttack;
@property (nonatomic, assign) BOOL  *playerBarnUnderAttack;
@property (nonatomic, assign) BOOL ableToSpawn;
@property (nonatomic, weak)  Bomb *theBomb;
+ (id)sharedMonsterCache;

//barn
-(void)spawnBarn;

//player monster
-(void) spawn:(NSString*)PlayerTypeClass atAngle:(float) angleOfLocation;

//enemy monster
-(void) spawnEnemyOfType:(NSString*)enemyTypeClass atAngle:(float) angleOfLocation;

//spawn walls

-(void) spawnWall:(NSString*)wallType atAngle:(float) angleOfLocation;
//create ship bullet
-(void)createShipBullet;

//create seed
-(void)createSeed:(NSString*)monsterName;

//create bomb
-(void)createBomb;

//resume game
- (void)gameResumed;

//pause game
- (void)gamePaused;



//Check if there is any monster of a type alive
-(BOOL)anyMonsterAliveOfType:(NSString *) monsterName;
@end
