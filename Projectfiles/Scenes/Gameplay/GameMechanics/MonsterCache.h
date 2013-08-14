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
    //node that contains all enemy monsters
    CCNode *enemyMonsters;
    //node that contains all player monsters
    CCNode *playerMonster;
    //contains all wall units
    CCNode *wallObjects;
    //contains all ship bullets
    CCNode *shipBullets;
    //contains all seed
    CCNode *seeds;
    //a dictionary to hold the array of different monster units
    NSMutableDictionary* monster;
    //a dictionary that holds the class assiociates with a monster string name
    NSMutableDictionary* monsterClass;
    //array that holds the string name of all the walls units
    NSMutableArray *wallList;
    //the prop of a wall spawning in the level
    NSInteger wallSpawnProp;
    // count the updates (used to determine when monsters should be spawned)
    int updateCount;
}
//enemy barn
@property (nonatomic) Barn *enemyBarn;
//player barn
@property (nonatomic) Barn *playerBarn;
//the 1 bomb the player can use
@property (nonatomic)  Bomb *theBomb;

//flag that is true only when player monster is approaching enemy barn
@property (nonatomic, assign) BOOL  *enemyBarnUnderAttack;
//flag taht is true only when enemy monster is approaching player barn
@property (nonatomic, assign) BOOL  *playerBarnUnderAttack;
//switch that enables this class to start spawning enemy monsters
@property (nonatomic, assign) BOOL ableToSpawn;
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
