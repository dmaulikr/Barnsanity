//
//  GameMechanics.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/17/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "GameMechanics.h"

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
        //dictionary that holds the spawn rate of enemy monsters for a level
        spawnRatesByEnemyMonsterType = [NSMutableDictionary dictionary];
        //dictionary that holds the spawn cost of player monsters at their current level
        spawnCostByPlayerMonsterType= [NSMutableDictionary dictionary];
        
    }
    
    return self;
}


- (void)setSpawnRate:(int)spawnRate forEnemyMonsterType:(NSString *)monsterType {
    NSNumber *spawnRateNumber = [NSNumber numberWithInt:spawnRate];
    [spawnRatesByEnemyMonsterType setObject:spawnRateNumber forKey:monsterType];
}

- (int)spawnRateForEnemyMonsterType:(NSString *)monsterType {
    return [[spawnRatesByEnemyMonsterType objectForKey:monsterType] intValue];
}

- (void)setSpawnCost:(int)spawnCost forPlayerMonsterType:(NSString *)monsterType{
    NSNumber *spawnCostNumber = [NSNumber numberWithInt:spawnCost];
    [spawnCostByPlayerMonsterType setObject:spawnCostNumber forKey:monsterType];
}

- (int)spawnCostForPlayerMonsterType:(NSString *)monsterType{
    return [[spawnCostByPlayerMonsterType objectForKey:monsterType] intValue];
}


- (void)resetGame
{
    self.gameState = GameStatePaused;
    [self.spawnRatesByEnemyMonsterType removeAllObjects];
    [self.spawnCostByPlayerMonsterType removeAllObjects];
    
    //set the spawn rates for all enemy monster
    int spawnRate;
    int level=_game.gameplayLevel ;
    NSDictionary *monsterInfo=[[[_game gameInfo] objectForKey:@"Game Levels"] objectAtIndex:level];
    NSArray *list=self.game.enemyMonsterList;
    NSString *monster;
    for(int i=0;i<list.count;i++){
        monster=list[i];
    spawnRate=[[monsterInfo objectForKey:monster] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:monster];
    }
    }


    
    //set up spawn cost for player monster
    list=[[GameMechanics sharedGameMechanics]game].playerMonsterList;
    for(int i=0;i<list.count;i++){
        monster=list[i];
    level=[[[_game levelsOfEverything] objectForKey:monster] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:monster] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:monster];
    }
    }
    }

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
