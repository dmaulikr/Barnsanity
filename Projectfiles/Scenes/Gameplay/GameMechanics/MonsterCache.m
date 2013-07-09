//
//  EnemyCache.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/17/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "MonsterCache.h"
#import "GameMechanics.h"
#import "BasicEnemyMonster.h"
#import "BasicPlayerMonster.h"
#import "Monster.H"
#import "ShipBullets.h"
#import "Carrot.h"
#import "Orange.h"
#import "Apple.h"
#import "Strawberry.h"
#import "Cherry.h"

#define ENEMY_MAX 300

@implementation MonsterCache

+ (id)sharedMonsterCache
{
    static dispatch_once_t once;
    static id sharedInstance;
    /*  Uses GCD (Grand Central Dispatch) to restrict this piece of code to only be executed once
     This code doesn't need to be touched by the game developer.
     */
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(id) cache
{
	id cache = [[self alloc] init];
	return cache;
}

- (void)dealloc
{
    /*
     When our object is removed, we need to unregister from all notifications.
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) reset{
    CCSpriteBatchNode *playerBatch;
    BasicPlayerMonster* player;
    ShipBullets *bullet;
    CCARRAY_FOREACH([playerMonster children], playerBatch){
        CCARRAY_FOREACH([playerBatch children], player){
            [player reset];
        }
    }
    CCARRAY_FOREACH([shipBullets children], bullet){
        [bullet reset];
    }
    
}
-(id) init
{
	if ((self = [super init]))
	{
        //creating 2 barns, one for each side and add it to the barn array and adding it to self node
        _enemyBarn=[[Barn alloc ]initWithEntityImage:TRUE];
        _playerBarn=[[Barn alloc ]initWithEntityImage:FALSE];
        [self addChild:_enemyBarn];
        [self addChild:_playerBarn];
        
        enemyMonsters= [[CCNode alloc] init];
        playerMonster =[[CCNode alloc] init];
        shipBullets = [[CCNode alloc] init];
        [self addChild:enemyMonsters];
        [self addChild:playerMonster];
        [self addChild:shipBullets];
        
        //create the dictionary for all monster units
        monster = [[NSMutableDictionary alloc] init];
        
        // load all the enemies in a sprite cache, all monsters need to be part of this sprite file
        // currently the knight is used as the only monster type
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"animation_knight.plist"];
        // we need to initialize the batch node with one of the frames
		CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"animation_knight-1.png"];
        /* A batch node allows drawing a lot of different sprites with on single draw cycle. Therefore it is necessary,
         that all sprites are added as child nodes to the batch node and that all use a texture contained in the batch node texture. */
		CCSpriteBatchNode *enemyBatch = [CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        CCSpriteBatchNode *playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:(id<NSCopying>)[Carrot class]];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:(id<NSCopying>)[Orange class]];
        
        playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:(id<NSCopying>)[Apple class]];
        
        playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:(id<NSCopying>)[Strawberry class]];
        
        playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:(id<NSCopying>)[Cherry class]];
        
    
        
        /**
         A Notification can be used to broadcast an information to all objects of a game, that are interested in it.
         Here we sign up for the 'GamePaused' and 'GameResumed' information, that is broadcasted by the GameMechanics class. Whenever the game pauses or resumes, we get informed and can react accordingly.
         **/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamePaused) name:@"GamePaused" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameResumed) name:@"GameResumed" object:nil];
        
        //add update
        [self scheduleUpdate];
	}
	
	return self;
}

- (void)gamePaused
{
    // first pause this CCNode, then pause all monsters
    
    [self pauseSchedulerAndActions];
    
    CCSpriteBatchNode *enemyBatch;
    CCSpriteBatchNode *playerBatch;
    // checks the collision between enemy units and player units
	BasicEnemyMonster* enemy;
    BasicPlayerMonster* player;
    
    CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
	{
        CCARRAY_FOREACH([enemyBatch children], enemy)
        {
            [enemy pauseSchedulerAndActions];
        }
    }
    
    CCARRAY_FOREACH([playerMonster children], playerBatch){
        CCARRAY_FOREACH([playerBatch children], player){
            [player pauseSchedulerAndActions];
        }
    }
}

- (void)gameResumed
{
    // first resume this CCNode, then pause all monsters
    
    [self resumeSchedulerAndActions];
    
    CCSpriteBatchNode *enemyBatch;
    CCSpriteBatchNode *playerBatch;
    // checks the collision between enemy units and player units
	BasicEnemyMonster* enemy;
    BasicPlayerMonster* player;
    
    CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
	{
        CCARRAY_FOREACH([enemyBatch children], enemy)
        {
            [enemy resumeSchedulerAndActions];
        }
    }
    
    CCARRAY_FOREACH([playerMonster children], playerBatch){
        CCARRAY_FOREACH([playerBatch children], player){
            [player resumeSchedulerAndActions];
        }
    }
}




-(void)spawnBarn{
    
    [_enemyBarn constructAt:M_PI ];
    [_playerBarn constructAt:0 ];
}

-(void)createShipBullet{
    CCArray *shipBullet=[shipBullets children];
    ShipBullets* bullet;
    
    /* we try to reuse existing enimies, therefore we use this flag, to keep track if we found an enemy we can
     respawn or if we need to create a new one */
    BOOL foundAvailablePlayerToSpawn = FALSE;
    // if the enemiesOfType array exists, iterate over all already existing enemies of the provided type and check if one of them can be respawned
    if (shipBullet != nil)
    {
        CCARRAY_FOREACH(shipBullet, bullet)
        {
            // find the first free enemy and respawn it
            if (bullet.visible == NO)
            {
                [bullet spawn];
                // remember, that we will not need to create a new enemy
                foundAvailablePlayerToSpawn = TRUE;
                break;
            }
        }
    }
    
    // if we haven't been able to find a enemy to respawn, we need to create one
    if (!foundAvailablePlayerToSpawn)
    {
        // initialize an enemy of the provided class
        bullet=[(ShipBullets *) [ShipBullets alloc] initWithMonsterPicture];
        [shipBullets addChild:bullet];
        [bullet spawn];
    }
    
}
-(void) spawn:(Class)PlayerTypeClass atAngle:(float) angleOfLocation{
    int cost = [[GameMechanics sharedGameMechanics] spawnCostForPlayerMonsterType:PlayerTypeClass];
    if(cost<=[[GameMechanics sharedGameMechanics]game].energy){
        [[GameMechanics sharedGameMechanics]game].energy-=cost;
        [self spawnPlayerOfType:PlayerTypeClass atAngle:(float) angleOfLocation];
    }
}

-(void) spawnPlayerOfType:(Class)PlayerTypeClass atAngle:(float) angleOfLocation{
    /* the 'enemies' dictionary stores an array of available enemies for each enemy type.
     We use the class of the enemy as key for the dictionary, to receive an array of all existing enimies of that type.
     We use a CCArray since it has a better performance than an NSArray. */
	CCSpriteBatchNode* playerOfType = [monster objectForKey:PlayerTypeClass];
    BasicPlayerMonster* player;
    
    /* we try to reuse existing enimies, therefore we use this flag, to keep track if we found an enemy we can
     respawn or if we need to create a new one */
    BOOL foundAvailablePlayerToSpawn = FALSE;
    // if the enemiesOfType array exists, iterate over all already existing enemies of the provided type and check if one of them can be respawned
        CCARRAY_FOREACH([playerOfType children], player)
        {
            // find the first free enemy and respawn it
            if (player.visible == NO)
            {
                [player spawnAt:angleOfLocation];
                // remember, that we will not need to create a new enemy
                foundAvailablePlayerToSpawn = TRUE;
                break;
            }
        }
    
    // if we haven't been able to find a enemy to respawn, we need to create one
    if (!foundAvailablePlayerToSpawn)
    {
        // initialize an enemy of the provided class
        BasicPlayerMonster* player =  [(BasicPlayerMonster *) [PlayerTypeClass alloc] initWithMonsterPicture];
        [playerOfType addChild:player];
        [player spawnAt:angleOfLocation];
    }
}

-(void) spawnEnemyOfType:(Class)enemyTypeClass atAngle:(float) angleOfLocation
{
    /* the 'enemies' dictionary stores an array of available enemies for each enemy type.
     We use the class of the enemy as key for the dictionary, to receive an array of all existing enimies of that type.
     We use a CCArray since it has a better performance than an NSArray. */
	CCSpriteBatchNode* enemiesOfType = [monster objectForKey:enemyTypeClass];
    BasicEnemyMonster* enemy;
    
    /* we try to reuse existing enimies, therefore we use this flag, to keep track if we found an enemy we can
     respawn or if we need to create a new one */
    BOOL foundAvailableEnemyToSpawn = FALSE;
    
    // if the enemiesOfType array exists, iterate over all already existing enemies of the provided type and check if one of them can be respawned
        CCARRAY_FOREACH([enemiesOfType children], enemy)
        {
            // find the first free enemy and respawn it
            if (enemy.visible == NO)
            {
                [enemy spawnAt:angleOfLocation];
                // remember, that we will not need to create a new enemy
                foundAvailableEnemyToSpawn = TRUE;
                break;
            }
        }
    
    
    // if we haven't been able to find a enemy to respawn, we need to create one
    if (!foundAvailableEnemyToSpawn)
    {
        // initialize an enemy of the provided class
        BasicEnemyMonster *enemy =  [(BasicEnemyMonster *) [enemyTypeClass alloc] initWithMonsterPicture];
        [enemiesOfType addChild:enemy];
        [enemy spawnAt:angleOfLocation];
    }
}
-(void) checkForCollisions
{
    CCSpriteBatchNode *enemyBatch;
    CCSpriteBatchNode *playerBatch;
    // checks the collision between enemy units and player units
	BasicEnemyMonster* enemy;
    BasicPlayerMonster* player;
    ShipBullets *bullet;
    
    //COLLISIONS FOR ENEMY UNITS
    
    // iterate over all enemies
	CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
	{
        CCARRAY_FOREACH([enemyBatch children], enemy)
        {
            // only check for collisions if the enemy is visible
            if (enemy.alive && !enemy.attacking)
            {
                enemy.attacked=FALSE;
                CGRect enemyHitZone = [enemy hitZone];
                CCARRAY_FOREACH([playerMonster children], playerBatch){
                    CCARRAY_FOREACH([playerBatch children], player){
                        //check if the enemy hitzone intersect players unit
                        if(player.alive && (!enemy.attacked||enemy.areaOfEffect)){
                            CGRect playerBoundingBox = [player boundingBox];
                            
                            if (CGRectIntersectsRect(enemyHitZone, playerBoundingBox))
                            {
                                
                                //if the enemy is not attacking, then prompt the enemy unit to attack
                                if (enemy.attacking == FALSE)
                                {
                                    enemy.attacked=TRUE;
                                    [enemy attack];
                                    [player gotHit:enemy.damage];
                                }else if(enemy.attacking && enemy.areaOfEffect){
                                    [player gotHit:enemy.areaOfEffectDamage];
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                
                //if the enemy unit still havent attacked yet, check if they are colliding with the barn
                if(!enemy.attacked||enemy.areaOfEffect){
                    
                    if(_playerBarn.visible){
                        CGRect barnBoundingBox = [_playerBarn boundingBox];
                        
                        if (CGRectIntersectsRect(enemyHitZone, barnBoundingBox))
                        {
                            //if the enemy is not attacking, then prompt the enemy unit to attack
                            if (enemy.attacking == FALSE)
                            {
                                enemy.attacked=TRUE;
                                [enemy attack];
                                [_playerBarn gotHit:enemy.damage];
                            }else if(enemy.attacking && enemy.areaOfEffect){
                                [_playerBarn gotHit:enemy.areaOfEffectDamage];
                            }
                            
                        }
                    
                    }
                }
                
                
            }
        
        //if the enemy unit didnt attack this iteration then attacked will be false, so the enemy unit should move, else it did attack and should not move while battling
        if(!enemy.attacked){
            enemy.move=TRUE;
        }else{
            enemy.move=FALSE;
        }
    }
    }
    
    
    
    //COLLISION FOR PLAYER UNITS
    
    
    // iterate over all enemies (all child nodes of this enemy batch)
    CCARRAY_FOREACH([playerMonster children], playerBatch){
        CCARRAY_FOREACH([playerBatch children], player){
            // only check for collisions if the enemy is visible
            if (player.alive && !player.attacking)
            {
                player.attacked=FALSE;
                CGRect playerHitZone = [player hitZone];
                
                CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
                {
                    CCARRAY_FOREACH([enemyBatch children], enemy)
                    {
                        if(enemy.alive && (!player.attacked || player.areaOfEffect)){
                            
                            CGRect enemyBoundingBox = [enemy boundingBox];
                            if (CGRectIntersectsRect(playerHitZone, enemyBoundingBox))
                            {
                                //if the enemy is not attacking, then prompt the enemy unit to attack
                                if (player.attacking == FALSE)
                                {
                                    player.attacked=TRUE;
                                    [player attack];
                                    [enemy gotHit:player.damage];
                                }else if(player.attacking && player.areaOfEffect){
                                    [enemy gotHit:player.areaOfEffectDamage];
                                }
                                
                                
                            }
                        }
                    }
                    
                }
                
                
                //if the player unit still havent attacked yet, check if they are colliding with the barn
                if(!player.attacked || player.areaOfEffect){
                    if(_enemyBarn.visible){
                        CGRect barnBoundingBox = [_enemyBarn boundingBox];
                        
                        if (CGRectIntersectsRect(playerHitZone, barnBoundingBox))
                        {
                            if (player.attacking == FALSE)
                            {
                                player.attacked=TRUE;
                                [player attack];
                                [_enemyBarn gotHit:player.damage];
                            }else if(player.attacking && player.areaOfEffect){
                                [_enemyBarn gotHit:player.areaOfEffectDamage];
                            }
                            
                        }
                        
                    }
                }
            }
            if(!player.attacked ){
                player.move=TRUE;
            }else{
                player.move=FALSE;
            }
        }
    }
    
    /*Collision Detection for ship bullets*/
    
    CCARRAY_FOREACH([shipBullets children], bullet){
        if (bullet.visible && !bullet.attacked) {
            CGRect bulletBoundingBox= [bullet boundingBox];
            CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
            {
                CCARRAY_FOREACH([enemyBatch children], enemy)
                {
                    if(enemy.alive && (!bullet.attacked || bullet.areaOfEffect)){
                        CGRect enemyBoundingBox = [enemy boundingBox];
                        if (CGRectIntersectsRect(enemyBoundingBox,bulletBoundingBox))
                        {
                            if(!bullet.attacked){
                                [enemy gotHit:bullet.damage];
                                bullet.attacked=TRUE;
                            }else if(bullet.areaOfEffect){
                                [enemy gotHit:bullet.areaOfEffectDamage];
                                
                            }
                        }
                    }
                }
            }
            if(bullet.attacked){
                [bullet gotHit];
            }
        }
    }
    
    CGRect barnHitZone;
    if(_enemyBarn.visible){
     barnHitZone = [_enemyBarn hitZone];
    /*Collision Detection for Barns*/
    CCARRAY_FOREACH([playerMonster children], playerBatch){
        CCARRAY_FOREACH([playerBatch children], player){
            if(player.alive && !_enemyBarn.attacking){
                CGRect enemyBoundingBox = [player boundingBox];
                if (CGRectIntersectsRect(barnHitZone,enemyBoundingBox))
                {
                    if(!_enemyBarn.attacking){
                        [_enemyBarn attack];
                        [player gotHit:_enemyBarn.damage];
                    }
                }
            }
        }
    }
    }
    
    if(_playerBarn.visible){
    barnHitZone = [_playerBarn hitZone];
    /*Collision Detection for Barns*/
    CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
    {
        CCARRAY_FOREACH([enemyBatch children], enemy)
        {
            if(enemy.alive && !_playerBarn.attacking){
                CGRect enemyBoundingBox = [enemy boundingBox];
                if (CGRectIntersectsRect(barnHitZone,enemyBoundingBox))
                {
                    if(!_playerBarn.attacking){
                        [_playerBarn attack];
                        [enemy gotHit:_playerBarn.damage];
                    }
                }
            }
        }
    }
    }
    
}


-(void) update:(ccTime)delta
{
    // only execute the block, if the game is in 'running' mode
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        updateCount++;
        
        // first we get all available monster types
        NSArray *monsterTypes = [[[GameMechanics sharedGameMechanics] spawnRatesByEnemyMonsterType] allKeys];
        
        for (Class monsterTypeClass in monsterTypes)
        {
            // we get the spawn frequency for this specific monster type
            int spawnFrequency = [[GameMechanics sharedGameMechanics] spawnRateForEnemyMonsterType:monsterTypeClass];
            // if the updateCount reached the spawnFrequency we spawn a new enemy
            if (updateCount % spawnFrequency == 0)
            {
                
                [self spawnEnemyOfType:monsterTypeClass atAngle:M_PI_2+CCRANDOM_0_1()*M_PI];
            }
        }
        
        
        [self checkForCollisions];
    }
}

@end
