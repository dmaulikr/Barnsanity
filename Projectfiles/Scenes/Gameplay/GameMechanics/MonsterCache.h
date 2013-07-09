//
//  EnemyCache.h
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/17/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "CCNode.h"
#import "Barn.h"

/**
 This class stores all enemies. This is necessary, to be able to draw all enemies on one BatchNode.
 Drawing all enemies on one BatchNode is important for performance reasons.
 **/

@interface MonsterCache : CCNode
{
    
    //batch for the different kind of monster units
    CCNode *enemyMonsters;
    CCNode *playerMonster;
    CCNode *shipBullets;
    //a dictionary to hold the array of different monster units
    NSMutableDictionary* monster;
    
    // count the updates (used to determine when monsters should be spawned)
    int updateCount;
}
@property (nonatomic, weak) Barn *enemyBarn;
@property (nonatomic, weak) Barn *playerBarn;

+ (id)sharedMonsterCache;

//barn
-(void)spawnBarn;

//player monster
-(void) spawn:(Class)PlayerTypeClass atAngle:(float) angleOfLocation;

//create ship bullet
-(void)createShipBullet;

@end
