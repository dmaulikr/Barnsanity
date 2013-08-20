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
#import "Entity.h"
#import "ShipBullets.h"
#import "Orange.h"
#import "Apple.h"
#import "Strawberry.h"
#import "Coconut.h"
#import "Grape.h"
#import "Pineapple.h"
#import "Watermelon.h"
#import "Carrot.h"
#import "Broccoli.h"
#import "Corn.h"
#import "Tomato.h"
#import "Potato.h"
#import "PeaPod.h"
#import "Pumpkin.h"
#import "Beet.h"
#import "Asparagus.h"
#import "Artichokes.h"
#import "Eggplant.h"
#import "Seed.h"
#import "Walls.h"
#import "Tree.h"
#import "ScareCrow.h"

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
        wallObjects=[[CCNode alloc] init];
        seeds=[[CCNode alloc] init];
        [self addChild:enemyMonsters];
        [self addChild:playerMonster];
        [self addChild:wallObjects];
        [self addChild:shipBullets];
        [self addChild:seeds];
        
        self.theBomb=[[Bomb alloc]initWithMonsterPicture];
        [self addChild:self.theBomb];
        
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
        
        //		CCSpriteBatchNode *enemyBatch = [CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        //        CCSpriteBatchNode *playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        
        [monster setObject:shipBullets forKey:@"Ship Bullets"];
        [monster setObject:seeds forKey:@"Seeds"];
        CCNode *enemyBatch=[[CCNode alloc]init];
        CCNode *playerBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:@"Carrot"];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:@"Orange"];
        
        enemyBatch=[[CCNode alloc]init];
        playerBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:@"Broccoli"];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:@"Apple"];
        
        enemyBatch=[[CCNode alloc]init];
        playerBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:@"Corn"];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:@"Strawberry"];
        
        enemyBatch=[[CCNode alloc]init];
        playerBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:@"Tomato"];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:@"Coconut"];
        
        enemyBatch=[[CCNode alloc]init];
        playerBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:@"Potato"];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:@"Grape"];
        
        enemyBatch=[[CCNode alloc]init];
        playerBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:@"Pea Pod"];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:@"Pineapple"];
        
        enemyBatch=[[CCNode alloc]init];
        playerBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        
        [monster setObject:enemyBatch forKey:@"Pumpkin"];
        [playerMonster addChild:playerBatch];
        [monster setObject:playerBatch forKey:@"Watermelon"];
        
        enemyBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        [monster setObject:enemyBatch forKey:@"Beet"];
        
        enemyBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        [monster setObject:enemyBatch forKey:@"Asparagus"];
        
        enemyBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        [monster setObject:enemyBatch forKey:@"Artichokes"];
        
        enemyBatch=[[CCNode alloc]init];
		[enemyMonsters addChild:enemyBatch];
        [monster setObject:enemyBatch forKey:@"Eggplant"];
        
        
        CCNode *treeNode=[[CCNode alloc]init];
        CCNode *crowNode=[[CCNode alloc]init];
		[wallObjects addChild:treeNode];
        [monster setObject:treeNode forKey:@"Tree"];
        [wallObjects addChild:crowNode];
        [monster setObject:crowNode forKey:@"ScareCrow"];
        
        //        playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        //        [playerMonster addChild:playerBatch];
        //        [monster setObject:playerBatch forKey:(id<NSCopying>)[Apple class]];
        //
        //        playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        //        [playerMonster addChild:playerBatch];
        //        [monster setObject:playerBatch forKey:(id<NSCopying>)[Strawberry class]];
        //
        //        playerBatch=[CCSpriteBatchNode batchNodeWithTexture:frame.texture];
        //        [playerMonster addChild:playerBatch];
        //        [monster setObject:playerBatch forKey:(id<NSCopying>)[Cherry class]];
        
        monsterClass = [[NSMutableDictionary alloc] init];
        [monsterClass setObject:[Orange class] forKey:@"Orange"];
        [monsterClass setObject: [Apple class]  forKey:@"Apple"];
        [monsterClass setObject: [Strawberry class]  forKey:@"Strawberry"];
        [monsterClass setObject: [Coconut class]  forKey:@"Coconut"];
        [monsterClass setObject: [Grape class]  forKey:@"Grape"];
        [monsterClass setObject: [Pineapple class] forKey:@"Pineapple"];
        [monsterClass setObject: [Watermelon class]  forKey:@"Watermelon"];
        
        [monsterClass setObject:[Carrot class] forKey:@"Carrot"];
        [monsterClass setObject: [Broccoli class]  forKey:@"Broccoli"];
        [monsterClass setObject: [Corn class]  forKey:@"Corn"];
        [monsterClass setObject: [Tomato class]  forKey:@"Tomato"];
        [monsterClass setObject: [Potato class]  forKey:@"Potato"];
        [monsterClass setObject: [PeaPod class]  forKey:@"Pea Pod"];
        [monsterClass setObject: [Pumpkin class]  forKey:@"Pumpkin"];
        [monsterClass setObject: [Beet class] forKey:@"Beet"];
        [monsterClass setObject: [Asparagus class]  forKey:@"Asparagus"];
        [monsterClass setObject: [Artichokes class] forKey:@"Artichokes"];
        [monsterClass setObject: [Eggplant class]  forKey:@"Eggplant"];
        [monsterClass setObject: [Tree class]  forKey:@"Tree"];
        [monsterClass setObject: [ScareCrow class]  forKey:@"ScareCrow"];
        
        wallList=[[NSMutableArray alloc]init];
        [wallList addObject:@"Tree"];
        [wallList addObject:@"ScareCrow"];
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

-(void) reset{
    self.ableToSpawn=TRUE;
    int level=[[[GameMechanics sharedGameMechanics]game]gameplayLevel];
    wallSpawnProp=[[[[[[[GameMechanics sharedGameMechanics]game] gameInfo]objectForKey:@"Game Levels"] objectAtIndex:level ] objectForKey:@"Wall Spawn"]integerValue];
    updateCount=450;
    self.enemyBarnUnderAttack=FALSE;
    self.playerBarnUnderAttack=FALSE;
    //    CCSpriteBatchNode *playerBatch;
    //    CCSpriteBatchNode *enemyBatch;
    CCNode *playerBatch;
    CCNode *enemyBatch;
    CCNode *wallBatch;
    BasicPlayerMonster* player;
    BasicEnemyMonster* enemy;
    ShipBullets *bullet;
    Seed *seed;
    Walls *wall;
    
    //reset bomb
    [self.theBomb reset];
    //resets all player mosnters
    CCARRAY_FOREACH([playerMonster children], playerBatch){
        CCARRAY_FOREACH([playerBatch children], player){
            [player reset];
        }
    }
    
    //reset all enemy monsters
    CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
	{
        CCARRAY_FOREACH([enemyBatch children], enemy)
        {
            [enemy reset];
        }
    }
    
    //reset all ship bullets
    CCARRAY_FOREACH([shipBullets children], bullet){
        [bullet reset];
    }
    
    //resets all seeds
    CCARRAY_FOREACH([seeds children], seed){
        [seed reset];
    }
    //resets al lwall units
    CCARRAY_FOREACH([wallObjects children], wallBatch)
	{
        CCARRAY_FOREACH([wallBatch children], wall)
        {
            [wall reset];
        }
    }
}

- (void)gamePaused
{
    // first pause this CCNode, then pause all monsters
    
    [self pauseSchedulerAndActions];
    
    //    CCSpriteBatchNode *enemyBatch;
    //    CCSpriteBatchNode *playerBatch;
    CCNode *playerBatch;
    CCNode *enemyBatch;
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
    
    //    CCSpriteBatchNode *enemyBatch;
    //    CCSpriteBatchNode *playerBatch;
    CCNode *playerBatch;
    CCNode *enemyBatch;
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


-(BOOL)anyMonsterAliveOfType:(NSString *) monsterName{
    //grabs the array that holds all monster with monsterName
    CCNode* monsterType = [monster objectForKey:monsterName];
    Entity *monsterToCheck;
    //check if all is alive and return true if there is one, else return false
    CCARRAY_FOREACH([monsterType children], monsterToCheck)
    {
        // find the first free enemy and respawn it
        if (monsterToCheck.alive == TRUE)
        {
            return TRUE;
        }
    }
    return FALSE;
}

-(void)spawnBarn{
    if([[GameMechanics sharedGameMechanics]game].difficulty ==EASY){
        
        [_enemyBarn constructAt:5*M_PI_4 ];
        [_playerBarn constructAt:fmodf(-M_PI_4+2*M_PI, 2*M_PI) ];
    }else{
        [_enemyBarn constructAt:M_PI ];
        [_playerBarn constructAt:0 ];
    }
}
-(void)createBomb{
    if(!self.theBomb.visible){
        [self.theBomb spawn];
    }
}

-(void)createShipBullet{
    CCNode *shipBullet= [monster objectForKey:@"Ship Bullets"];
    ShipBullets* bullet;
    
    /* we try to reuse existing enimies, therefore we use this flag, to keep track if we found an enemy we can
     respawn or if we need to create a new one */
    BOOL foundAvailablePlayerToSpawn = FALSE;
    // if the enemiesOfType array exists, iterate over all already existing enemies of the provided type and check if one of them can be respawned
    if (shipBullet != nil)
    {
        CCARRAY_FOREACH([shipBullet children], bullet)
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


-(void)createSeed:(NSString*)monsterName{
    CCNode *seedsArray= [monster objectForKey:@"Seeds"];
    Seed* seed;
    
    //iterate through the array that holds all the seed objects and try to find a non-active one
    //if we found one, foundAvailablePlayerToSpawn is true
    BOOL foundAvailablePlayerToSpawn = FALSE;

    CCARRAY_FOREACH([seedsArray children], seed)
    {
        // find the first free unit and respawn it
        if (seed.visible == NO)
        {
            [seed spawnMonster:monsterName];
            // remember, that we will not need to create a new enemy
            foundAvailablePlayerToSpawn = TRUE;
            break;
        }
    }
    
    
    // if we haven't been able to find a unit to respawn, we need to create one
    if (!foundAvailablePlayerToSpawn)
    {
        // initialize an unit of the provided class
        seed=[(Seed *) [Seed alloc] initWithMonsterPicture];
        [seeds addChild:seed];
        [seed spawnMonster:monsterName];
    }
}

-(void) spawn:(NSString*)PlayerTypeClass atAngle:(float) angleOfLocation{
    [self spawnPlayerOfType:PlayerTypeClass atAngle:(float) angleOfLocation];
    
}

-(void) spawnPlayerOfType:(NSString*)PlayerTypeClass atAngle:(float) angleOfLocation{
    //      CCSpriteBatchNode*
    CCNode* playerOfType = [monster objectForKey:PlayerTypeClass];
    BasicPlayerMonster* player;
    
    //iterate through the array that holds all the unit objects and try to find a non-active one
    //if we found one, foundAvailablePlayerToSpawn is true
    BOOL foundAvailablePlayerToSpawn = FALSE;

    CCARRAY_FOREACH([playerOfType children], player)
    {
        // find the first free enemy and respawn it
        if (player.alive == NO)
        {
            [player spawnAt:angleOfLocation];
            // remember, that we will not need to create a new unit
            foundAvailablePlayerToSpawn = TRUE;
            break;
        }
    }
    
    // if we haven't been able to find a unit to respawn, we need to create one
    if (!foundAvailablePlayerToSpawn)
    {
        // initialize an unit of the provided class
        BasicPlayerMonster* player =  [(BasicPlayerMonster *) [[monsterClass objectForKey:PlayerTypeClass] alloc] initWithMonsterPicture];
        [player spawnAt:angleOfLocation];
        [playerOfType addChild:player];
    }
}

-(void) spawnEnemyOfType:(NSString*)enemyTypeClass atAngle:(float) angleOfLocation
{
    //      CCSpriteBatchNode*
    CCNode* enemiesOfType = [monster objectForKey:enemyTypeClass];
    BasicEnemyMonster* enemy;
    
    //iterate through the array that holds all the unit objects and try to find a non-active one
    //if we found one, foundAvailablePlayerToSpawn is true
    BOOL foundAvailableEnemyToSpawn = FALSE;
    
    CCARRAY_FOREACH([enemiesOfType children], enemy)
    {
        // find the first free enemy and respawn it
        if (enemy.alive == NO)
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
        BasicEnemyMonster *enemy =  [(BasicEnemyMonster *) [[monsterClass objectForKey:enemyTypeClass] alloc] initWithMonsterPicture];
        [enemy spawnAt:angleOfLocation];
        [enemiesOfType addChild:enemy];
    }
}

-(void) spawnWall:(NSString*)wallType atAngle:(float) angleOfLocation
{
    //      CCSpriteBatchNode*
    CCNode* wallOfType = [monster objectForKey:wallType];
    Walls* wall;
    
    //iterate through the array that holds all the unit objects and try to find a non-active one
    //if we found one, foundAvailableEnemyToSpawn is true
    BOOL foundAvailableEnemyToSpawn = FALSE;

    CCARRAY_FOREACH([wallOfType children], wall)
    {
        // find the first free unit and respawn it
        if (wall.alive == NO)
        {
            [wall spawnAt:angleOfLocation];
            // remember, that we will not need to create a new unit
            foundAvailableEnemyToSpawn = TRUE;
            break;
        }
    }
    
    
    // if we haven't been able to find a unit to respawn, we need to create one
    if (!foundAvailableEnemyToSpawn)
    {
        // initialize an unit of the provided class
        Walls *wall =  [(Walls *) [[monsterClass objectForKey:wallType] alloc] initWithMonsterPicture];
        [wall spawnAt:angleOfLocation];
        [wallOfType addChild:wall];
    }
}

-(BOOL)monsterNearBarn:(Barn *)defender andMonster:(Monster *)attacker{
    int scenario;
    BOOL retval;
    
    if(attacker.hitZoneAngle2>attacker.hitZoneAngle1 && defender.alertZoneAngle2> defender.alertZoneAngle1){
        //this scenario occurs when both the attackers hitzone angles and defenders bounding angles include degree 0
        scenario=1;
    }else if(attacker.hitZoneAngle2>attacker.hitZoneAngle1){
        //this scenario occurs when only the attackers hitzone angles includes 0
        scenario=2;
    }else if(defender.alertZoneAngle2> defender.alertZoneAngle1){
        //this scenario occurs when only the defenders alert zone include 0
        scenario=3;
    }
    
    switch (scenario) {
        case 1:
            retval=TRUE;
            break;
        case 2:
            if(
               (defender.alertZoneAngle1 <=2*M_PI && defender.alertZoneAngle1 >= attacker.hitZoneAngle2) ||
               (defender.alertZoneAngle2<=attacker.hitZoneAngle1 && defender.alertZoneAngle2>=0)
               ){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
        case 3:
            if(
               (attacker.hitZoneAngle1 <=2*M_PI && attacker.hitZoneAngle1 >=defender.alertZoneAngle2) ||
                (attacker.hitZoneAngle2<=defender.alertZoneAngle1 && attacker.hitZoneAngle2>=0)
               ){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
        default:
            if(//if the first hitzone angle is within the bounding angles, checks if the end hitzone intersects the bounding
               (attacker.hitZoneAngle1<=defender.alertZoneAngle1 && attacker.hitZoneAngle1 >=defender.alertZoneAngle2) ||
               //if the second hitzone angle is within the bounding angles, checks if the beginning hitzone intersects the bounding
               (attacker.hitZoneAngle2 <=defender.alertZoneAngle1 && attacker.hitZoneAngle2 >=defender.alertZoneAngle2)||
               //if the first bounding angle is within the hit zone angles, checks if bounding angles is with the hit zone
               (defender.alertZoneAngle1<=attacker.hitZoneAngle1 && defender.alertZoneAngle1>= attacker.hitZoneAngle2)||
               (defender.alertZoneAngle2<=attacker.hitZoneAngle1 && defender.alertZoneAngle2>= attacker.hitZoneAngle2)
               ){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
    }
    
    return retval;
    
}

-(BOOL)collisionBetweenMonstersWithAngle:(Entity* )attacker andMonster:(Entity *)defender{
    int scenario;
    BOOL retval;
    if(attacker.hitZoneAngle2>attacker.hitZoneAngle1 && defender.boundingZoneAngle2> defender.boundingZoneAngle1){
        //this scenario occurs when both the attackers hitzone angles and defenders bounding angles include degree 0
        scenario=1;
    }else if(attacker.hitZoneAngle2>attacker.hitZoneAngle1){
         //this scenario occurs when only the attackers hitzone angles includes 0
        scenario=2;
    }else if(defender.boundingZoneAngle2> defender.boundingZoneAngle1){
        //this scenario occurs when only the defenders bounding zone include 0
        scenario=3;
    }
    
    switch (scenario) {
        case 1:
            retval=TRUE;
            break;
        case 2:
            if(
               (defender.boundingZoneAngle1 <=2*M_PI && defender.boundingZoneAngle1 >= attacker.hitZoneAngle2) ||
               (defender.boundingZoneAngle2<=attacker.hitZoneAngle1 && defender.boundingZoneAngle2>=0)
               ){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
        case 3:
            if(
               (attacker.hitZoneAngle1 <=2*M_PI && attacker.hitZoneAngle1 >=defender.boundingZoneAngle2) ||
               (attacker.hitZoneAngle2<=defender.boundingZoneAngle1 && attacker.hitZoneAngle2>=0)
               ){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
        default:
            if(
               (attacker.hitZoneAngle1<=defender.boundingZoneAngle1 && attacker.hitZoneAngle1 >=defender.boundingZoneAngle2) ||
               (attacker.hitZoneAngle2 <=defender.boundingZoneAngle1 && attacker.hitZoneAngle2 >=defender.boundingZoneAngle2)||
               (defender.boundingZoneAngle1<=attacker.hitZoneAngle1 && defender.boundingZoneAngle1>= attacker.hitZoneAngle2)||
               (defender.boundingZoneAngle2<=attacker.hitZoneAngle1 && defender.boundingZoneAngle2>= attacker.hitZoneAngle2)
               ){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
    }
    
    return retval;
    
    
}

-(BOOL)collisionBullets:(ShipBullets* )attacker andMonster:(Entity *)defender{
    
    int scenario;
    BOOL retval;
    if(attacker.hitZoneAngle2>attacker.hitZoneAngle1 && defender.boundingZoneAngle2> defender.boundingZoneAngle1){
        //this scenario occurs when both the attackers hitzone angles and defenders bounding angles include degree 0
        scenario=1;
    }else if(attacker.hitZoneAngle2>attacker.hitZoneAngle1){
        scenario=2;
    }else if(defender.boundingZoneAngle2> defender.boundingZoneAngle1){
        scenario=3;
    }
    
    switch (scenario) {
        case 1:
            if(attacker.distanceFromWorld-attacker.contentSize.height/9 <= defender.radiusToSpawn+defender.contentSize.height/9){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
        case 2:
            if(//if the first hitzone angle is within the bounding angles, checks if the end hitzone intersects the bounding
               ((defender.boundingZoneAngle1 <=2*M_PI && defender.boundingZoneAngle1 >= attacker.hitZoneAngle2) ||
                //if the second hitzone angle is within the bounding angles, checks if the beginning hitzone intersects the bounding
                (defender.boundingZoneAngle2<=attacker.hitZoneAngle1 && defender.boundingZoneAngle2>=0))
               && attacker.distanceFromWorld-attacker.contentSize.height/9 <= defender.radiusToSpawn+defender.contentSize.height/9){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
        case 3:
            if(//if the first hitzone angle is within the bounding angles, checks if the end hitzone intersects the bounding
               ((attacker.hitZoneAngle1 <=2*M_PI && attacker.hitZoneAngle1 >=defender.boundingZoneAngle2) ||
                //if the second hitzone angle is within the bounding angles, checks if the beginning hitzone intersects the bounding
                (attacker.hitZoneAngle2<=defender.boundingZoneAngle1 && attacker.hitZoneAngle2>=0))
               && attacker.distanceFromWorld-attacker.contentSize.height/9 <= defender.radiusToSpawn+defender.contentSize.height/9){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
        default:
            if(//if the first hitzone angle is within the bounding angles, checks if the end hitzone intersects the bounding
               ((attacker.hitZoneAngle1<=defender.boundingZoneAngle1 && attacker.hitZoneAngle1 >=defender.boundingZoneAngle2) ||
                //if the second hitzone angle is within the bounding angles, checks if the beginning hitzone intersects the bounding
                (attacker.hitZoneAngle2 <=defender.boundingZoneAngle1 && attacker.hitZoneAngle2 >=defender.boundingZoneAngle2)||
                //if the first bounding angle is within the hit zone angles, checks if bounding angles is with the hit zone
                (defender.boundingZoneAngle1<=attacker.hitZoneAngle1 && defender.boundingZoneAngle1>= attacker.hitZoneAngle2)||
                (defender.boundingZoneAngle2<=attacker.hitZoneAngle1 && defender.boundingZoneAngle2>= attacker.hitZoneAngle2))
               && attacker.distanceFromWorld-attacker.contentSize.height/9 <= defender.radiusToSpawn+defender.contentSize.height/9){
                retval=TRUE;
            }else{
                retval=FALSE;
            }
            break;
    }
    
    return retval;
    
}

-(void) checkForCollisions
{
    //    CCSpriteBatchNode *enemyBatch;
    //    CCSpriteBatchNode *playerBatch;
    CCNode *playerBatch;
    CCNode *enemyBatch;
    CCNode *wallBatch;
    // checks the collision between enemy units and player units
	BasicEnemyMonster* enemy;
    BasicPlayerMonster* player;
    ShipBullets *bullet;
    Walls *wall;
    BOOL monsterNearBarn=FALSE;
    
    //CHECK IF THE BOMB HIT
    if(self.theBomb.readyToDamage){
        //check if any monster is in the range of of bomb's hit zone
        CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
        {
            CCARRAY_FOREACH([enemyBatch children], enemy)
            {
                if(enemy.alive && !enemy.invincible){
                    if ([self collisionBetweenMonstersWithAngle:self.theBomb andMonster:enemy]){
                        [enemy gotHit:self.theBomb.damage];
                    }
                }
            }
        }
        
        //check if any walls are in range of the bomb's hit zone
        CCARRAY_FOREACH([wallObjects children], wallBatch)
        {
            CCARRAY_FOREACH([wallBatch children], wall)
            {
                if(wall.visible && !wall.invincible){
                    if ([self collisionBetweenMonstersWithAngle:player andMonster:wall]){
                        [wall gotHit:self.theBomb.damage];
                    }
                }
            }
            
        }
        
        //destroy the bomb after checking
        [self.theBomb gotHit];
    }
    
    
    
    //COLLISIONS FOR ENEMY UNITS
    
    // iterate over all enemies
    CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
    {
        CCARRAY_FOREACH([enemyBatch children], enemy)
        {
            // only check for collisions if the enemy is visible
            if (enemy.ableToAttack && enemy.alive && !enemy.attacking)
            {
                enemy.attacked=FALSE;
                CCARRAY_FOREACH([wallObjects children], wallBatch)
                {
                    CCARRAY_FOREACH([wallBatch children], wall)
                    {
                        if(wall.alive && !wall.invincible){
                            if ([self collisionBetweenMonstersWithAngle:enemy andMonster:wall]){
                                //if the enemy is not attacking, then prompt the enemy unit to attack
                                if (enemy.attacking == FALSE)
                                {
                                    enemy.attacked=TRUE;
                                    [enemy attack];
                                    [wall gotHit:enemy.damage];
                                }else if(enemy.attacking && enemy.areaOfEffect){
                                    [wall gotHit:enemy.areaOfEffectDamage];
                                }
                            }
                        }
                        
                    }
                }
                
                if(enemy.ableToAttack && (!enemy.attacked ||enemy.areaOfEffect)){
                    CCARRAY_FOREACH([playerMonster children], playerBatch){
                        CCARRAY_FOREACH([playerBatch children], player){
                            //check if the enemy hitzone intersect players unit
                            if(!player.invincible && player.alive && (!enemy.attacked||enemy.areaOfEffect)){
                                
                                if ([self collisionBetweenMonstersWithAngle:enemy andMonster:player])
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
                }
                
                //if the enemy unit still havent attacked yet, check if they are colliding with the barn
                if(enemy.ableToAttack && (!enemy.attacked ||enemy.areaOfEffect)){
                    
                    if(_playerBarn.visible){
                        if ([self collisionBetweenMonstersWithAngle:enemy andMonster:self.playerBarn])
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
                
                if(!enemy.attacked){
                    enemy.move=TRUE;
                }else{
                    enemy.move=FALSE;
                }
                
            }
            
            //if the enemy unit didnt attack this iteration then attacked will be false, so the enemy unit should move, else it did attack and should not move while battling
            
        }
    }
    
    
    
    //COLLISION FOR PLAYER UNITS
    
    
    // iterate over all enemies (all child nodes of this enemy batch)
    CCARRAY_FOREACH([playerMonster children], playerBatch){
        CCARRAY_FOREACH([playerBatch children], player){
            // only check for collisions if the enemy is visible
            if (player.ableToAttack && player.alive && !player.attacking)
            {
                player.attacked=FALSE;
                
                CCARRAY_FOREACH([wallObjects children], wallBatch)
                {
                    CCARRAY_FOREACH([wallBatch children], wall)
                    {
                        if(wall.alive && !wall.invincible){
                            if ([self collisionBetweenMonstersWithAngle:player andMonster:wall]){
                                //if the enemy is not attacking, then prompt the enemy unit to attack
                                if (player.attacking == FALSE)
                                {
                                    player.attacked=TRUE;
                                    [player attack];
                                    [wall gotHit:player.damage];
                                }else if(player.attacking && player.areaOfEffect){
                                    [wall gotHit:player.areaOfEffectDamage];
                                }
                            }
                        }
                        
                    }
                }
                
                if(player.ableToAttack && (!player.attacked || player.areaOfEffect)){
                    CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
                    {
                        CCARRAY_FOREACH([enemyBatch children], enemy)
                        {
                            if(!enemy.invincible && enemy.alive && (!player.attacked || player.areaOfEffect)){
                                if ([self collisionBetweenMonstersWithAngle:player andMonster:enemy]){
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
                }
                
                
                //if the player unit still havent attacked yet, check if they are colliding with the barn
                if(player.ableToAttack && (!player.attacked || player.areaOfEffect)){
                    if(_enemyBarn.visible){
                        if ([self collisionBetweenMonstersWithAngle:player andMonster:self.enemyBarn])
                        {
                            self.enemyBarnUnderAttack=TRUE;
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
                
                if(!player.attacked ){
                    player.move=TRUE;
                }else{
                    player.move=FALSE;
                }
            }
            
        }
    }
    
    /*Collision Detection for ship bullets*/
    CCARRAY_FOREACH([shipBullets children], bullet){
        if (bullet.alive ) {
            CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
            {
                CCARRAY_FOREACH([enemyBatch children], enemy)
                {
                    if(!enemy.invincible && enemy.alive && bullet.alive){
                        if ([self collisionBullets:bullet andMonster:enemy])
                        {
                            if(!bullet.attacked){
                                bullet.attacked=TRUE;
                                [enemy gotHit:bullet.damage];
                            }else{
                                [enemy gotHit:bullet.areaOfEffectDamage];
                            }
                        }
                    }
                }
            }
            
                CCARRAY_FOREACH([wallObjects children], wallBatch)
                {
                    CCARRAY_FOREACH([wallBatch children], wall)
                    {
                        if(wall.alive && !wall.invincible){
                            if ([self collisionBullets:bullet andMonster:wall]){
                                if(!bullet.attacked){
                                    bullet.attacked=TRUE;
                                    [wall gotHit:bullet.damage];
                                }else{
                                    [wall gotHit:bullet.areaOfEffectDamage];
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
    
    
    
    //    //COLLISION WITH ENEMY BARN WITH PLAYER
    if(_enemyBarn.visible){
        /*Collision Detection for Barns*/
        CCARRAY_FOREACH([playerMonster children], playerBatch){
            CCARRAY_FOREACH([playerBatch children], player){
                if(player.alive && !_enemyBarn.attacking){
                    if ([self collisionBetweenMonstersWithAngle:self.enemyBarn andMonster:player])
                    {
                        [_enemyBarn attack];
                        [player gotHit:_enemyBarn.damage];
                        
                    }
                }
            }
        }
    }
    
    //COLLISION WITH PLAYER BARN WITH ENEMY
    if(_playerBarn.visible){
        /*Collision Detection for Barns*/
        CCARRAY_FOREACH([enemyMonsters children], enemyBatch)
        {
            CCARRAY_FOREACH([enemyBatch children], enemy)
            {
                if(enemy.alive && !_playerBarn.attacking){
                    if ([self collisionBetweenMonstersWithAngle:self.playerBarn andMonster:enemy])
                    {
                        [_playerBarn attack];
                        [enemy gotHit:_playerBarn.damage];
                        
                        
                    }
                }
            }
        }
    }
    
    //check if enemy is approaching the player barn, if there is, flag it
    if(self.playerBarn.visible){
        monsterNearBarn=FALSE;
        CCARRAY_FOREACH([enemyMonsters children], enemyBatch){
            CCARRAY_FOREACH([enemyBatch children], enemy){
                // only check for collisions if the enemy is visible
                if (enemy.alive)
                {
                    if([self monsterNearBarn:self.playerBarn andMonster:enemy]){
                        monsterNearBarn=TRUE;
                    }
                }
                
            }
        }
        if(monsterNearBarn){
            self.playerBarnUnderAttack=TRUE;
        }else{
            self.playerBarnUnderAttack=FALSE;
        }
    }
    
    //check if player is approaching the enemy barn, if there is, flag it
    if(self.enemyBarn.visible){
        monsterNearBarn=FALSE;
        CCARRAY_FOREACH([playerMonster children], playerBatch){
            CCARRAY_FOREACH([playerBatch children], player){
                // only check for collisions if the enemy is visible
                if (player.alive)
                {
                    if([self monsterNearBarn:self.enemyBarn andMonster:player]){
                        monsterNearBarn=TRUE;
                    }
                }
            }
        }
        
        if(monsterNearBarn){
            self.enemyBarnUnderAttack=TRUE;
        }else{
            self.enemyBarnUnderAttack=FALSE;
        }
    }
    
}


-(void) update:(ccTime)delta
{
    // only execute the block, if the game is in 'running' mode
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning )
    {
        if(self.ableToSpawn)
            updateCount++;
        
        // first we get all available monster types
        NSArray *monsterTypes = [[[GameMechanics sharedGameMechanics] spawnRatesByEnemyMonsterType] allKeys];
        
        for (NSString *monsterTypeClass in monsterTypes)
        {
            // we get the spawn frequency for this specific monster type
            int spawnFrequency = [[GameMechanics sharedGameMechanics] spawnRateForEnemyMonsterType:monsterTypeClass];
            // if the updateCount reached the spawnFrequency we spawn a new enemy
            if([[GameMechanics sharedGameMechanics]game].timeInSec<=[[GameMechanics sharedGameMechanics]game].timeForCrazyMode){
                spawnFrequency=spawnFrequency/1.5;
            }
            
            if(self.enemyBarnUnderAttack && [[GameMechanics sharedGameMechanics]game].difficulty==EASY){
                spawnFrequency=spawnFrequency/.80;
            }
            
            //                if([[GameMechanics sharedGameMechanics]game].difficulty==HARD){
            //                    spawnFrequency=spawnFrequency/1.43;
            //                }
            
            if (updateCount % spawnFrequency == 0)
            {
                if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
                    if(self.enemyBarnUnderAttack){
                        [self spawnEnemyOfType:monsterTypeClass atAngle:(5*M_PI_4-self.enemyBarn.boundingZone/1.2)];
                    }else{
                        
                        [self spawnEnemyOfType:monsterTypeClass atAngle:(M_PI_2+M_PI_4/2+(CCRANDOM_0_1()*2.5*M_PI_4 ))];
                        
                    }
                }else{
                    if(self.enemyBarnUnderAttack){
                        [self spawnEnemyOfType:monsterTypeClass atAngle:M_PI+CCRANDOM_MINUS1_1()*self.enemyBarn.boundingZone/1.2];
                    }else{
                        
                        [self spawnEnemyOfType:monsterTypeClass atAngle:M_PI_2+M_PI_4/2+CCRANDOM_0_1()*3*M_PI_4];
                    }
                }
            }
        }
        
        
        if (wallSpawnProp>0 && rand() %(wallSpawnProp) == 1){
            int walltype=rand() %(wallList.count);
            if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
                [self spawnWall:wallList[walltype] atAngle:M_PI_2+CCRANDOM_MINUS1_1()*M_PI_4];
            }else{
                if(CCRANDOM_0_1() >=.5){
                    [self spawnWall:wallList[walltype] atAngle:M_PI_2+CCRANDOM_MINUS1_1()*M_PI_4/2];
                }else{
                    [self spawnWall:wallList[walltype] atAngle:3*M_PI_2+CCRANDOM_MINUS1_1()*M_PI_4/2];
                }
            }
        }
        
        
        
        [self checkForCollisions];
    }
}

@end
