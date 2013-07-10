//
//  GameMechanics.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/17/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "GameMechanics.h"
#import "Orange.h"
#import "Apple.h"
#import "Strawberry.h"
#import "Cherry.h"
#import "Mango.h"
#import "Banana.h"
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
#import "Pea.h"
#import "Pumpkin.h"
#import "Beet.h"
#import "Asparagus.h"
@implementation GameMechanics

@synthesize spawnRatesByEnemyMonsterType;
@synthesize spawnCostByPlayerMonsterType;
@synthesize gameState = _gameState;

+ (id)sharedGameMechanics
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

- (id)init {
    self = [super init];
    
    if (self)
    {
        spawnRatesByEnemyMonsterType = [NSMutableDictionary dictionary];
        spawnCostByPlayerMonsterType= [NSMutableDictionary dictionary];
        
    }
    
    return self;
}


- (void)setSpawnRate:(int)spawnRate forEnemyMonsterType:(Class)monsterType {
    NSNumber *spawnRateNumber = [NSNumber numberWithInt:spawnRate];
    [spawnRatesByEnemyMonsterType setObject:spawnRateNumber forKey:(id<NSCopying>)monsterType];
}

- (int)spawnRateForEnemyMonsterType:(Class)monsterType {
    return [[spawnRatesByEnemyMonsterType objectForKey:(id<NSCopying>)monsterType] intValue];
}

- (void)setSpawnCost:(int)spawnCost forPlayerMonsterType:(Class)monsterType{
    NSNumber *spawnCostNumber = [NSNumber numberWithInt:spawnCost];
    [spawnCostByPlayerMonsterType setObject:spawnCostNumber forKey:(id<NSCopying>)monsterType];
}

- (int)spawnCostForPlayerMonsterType:(Class)monsterType{
    return [[spawnCostByPlayerMonsterType objectForKey:(id<NSCopying>)monsterType] intValue];
}


- (void)resetGame
{
    
    self.gameScene = nil;
    self.gameState = GameStatePaused;
    [self.spawnRatesByEnemyMonsterType removeAllObjects];
    [self.spawnCostByPlayerMonsterType removeAllObjects];
    
    //set the spawn rates for all enemy monster
    int spawnRate;
    int level=[[[_game levelsOfEverything] objectForKey:@"Game Levels"] integerValue];
    NSDictionary *monsterInfo=[[[_game gameInfo] objectForKey:@"Game Levels"] objectAtIndex:level];
    spawnRate=[[monsterInfo objectForKey:@"Carrot"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Carrot class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Broccoli"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Broccoli class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Corn"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Corn class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Tomato"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Tomato class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Potato"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Potato class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Peapod"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[PeaPod class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Pea"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Pea class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Pumpkin"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Pumpkin class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Beet"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Beet class]];
    }
    spawnRate=[[monsterInfo objectForKey:@"Asparagus"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:[Asparagus class]];
    }
    
    //set up spawn cost for player monster
    NSDictionary *monsterLevels=[[_game levelsOfEverything] objectForKey:@"Player Monsters"];
    monsterInfo=[[_game gameInfo] objectForKey:@"Player Monsters"];
    
    level=[[monsterLevels objectForKey:@"Orange"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Orange"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Orange class]];
    }
    level=[[monsterLevels objectForKey:@"Apple"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Apple"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Apple class]];
    }
    level=[[monsterLevels objectForKey:@"Strawberry"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Strawberry"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Strawberry class]];
    }
    level=[[monsterLevels objectForKey:@"Cherry"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Cherry"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Cherry class]];
    }
    level=[[monsterLevels objectForKey:@"Mango"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Mango"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Mango class]];
    }
    level=[[monsterLevels objectForKey:@"Banana"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Banana"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Banana class]];
    }
    level=[[monsterLevels objectForKey:@"Coconut"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Coconut"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Coconut class]];
    }
    level=[[monsterLevels objectForKey:@"Grape"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Grape"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Grape class]];
    }
    level=[[monsterLevels objectForKey:@"Pineapple"] integerValue];
    if(level >0){
        spawnRate= [[[[monsterInfo objectForKey:@"Pineapple"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Pineapple class]];
    }
    level=[[monsterLevels objectForKey:@"Watermelon"] integerValue];
    if(level >=0){
        spawnRate= [[[[monsterInfo objectForKey:@"Watermelon"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:[Watermelon class]];
    }}

- (void)setGameState:(GameState)gameState
{
    // we need to add special behaviour, when entering or leaving pause mode
    
    /**
     A Notification can be used to broadcast an information to all objects of a game, that are interested in it.
     Here we broadcast the 'GamePaused' and  the'GameResumed' information. All classes that listen to this notification, will be informed, that the game paused or resumed and can react accordingly.
     **/
    
    // we are leaving the paused mode and need to resume animations
    if ((_gameState == GameStatePaused) && (gameState != GameStatePaused))
    {
        // post a notification informing all screens and entities, that game is resumed
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameResumed" object:nil];
    }
    
    // we are entering pause mode and need to pause all animations
    if ((_gameState != GameStatePaused) && (gameState == GameStatePaused))
    {
        // post a notification informing all screens and entities, that game is paused
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GamePaused" object:nil];
    }
    
    _gameState = gameState;
    
}
@end
