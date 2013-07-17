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
        spawnRatesByEnemyMonsterType = [NSMutableDictionary dictionary];
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
    spawnRate=[[monsterInfo objectForKey:@"Carrot"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Carrot"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Broccoli"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Broccoli"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Corn"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Corn"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Tomato"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Tomato"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Potato"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Potato"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Peapod"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Peapod"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Pea"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Pea"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Pumpkin"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Pumpkin"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Beet"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Beet"];
    }
    spawnRate=[[monsterInfo objectForKey:@"Asparagus"] integerValue];
    if(spawnRate >0){
        [self setSpawnRate:spawnRate forEnemyMonsterType:@"Asparagus"];
    }
    
    //set up spawn cost for player monster
    
    level=[[[_game levelsOfEverything] objectForKey:@"Orange"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Orange"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Orange"];
    }
    level=[[[_game levelsOfEverything]  objectForKey:@"Apple"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Apple"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Apple"];
    }
    level=[[[_game levelsOfEverything]  objectForKey:@"Strawberry"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Strawberry"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Strawberry"];
    }
    level=[[[_game levelsOfEverything] objectForKey:@"Cherry"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Cherry"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Cherry"];
    }
    level=[[[_game levelsOfEverything]  objectForKey:@"Mango"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Mango"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Mango"];
    }
    level=[[[_game levelsOfEverything]  objectForKey:@"Banana"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Banana"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Banana"];
    }
    level=[[[_game levelsOfEverything] objectForKey:@"Coconut"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Coconut"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Coconut"];
    }
    level=[[[_game levelsOfEverything]  objectForKey:@"Grape"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Grape"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Grape"];
    }
    level=[[[_game levelsOfEverything] objectForKey:@"Pineapple"] integerValue];
    if(level >0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Pineapple"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Pineapple"];
    }
    level=[[[_game levelsOfEverything]  objectForKey:@"Watermelon"] integerValue];
    if(level >=0){
        spawnRate= [[[[[_game gameInfo] objectForKey:@"Watermelon"] objectAtIndex:level] objectForKey:@"Energy Cost"]integerValue];
        [self setSpawnCost:spawnRate forPlayerMonsterType:@"Watermelon"];
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
