//
//  GameMechanics.h
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/17/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "GameplayLayer.h"
#import "MonsterCache.h"

// define the different possible GameState types, by using constants
typedef NS_ENUM(NSInteger, GameState) {
    GameStatePaused,
    GameStateMenu,
    GameStateRunning
};

/**
 This class stores several global game parameters. It stores
 references to several entities and sets up e.g. the 'floorHeight'.
 
 This class is used by all entities in the game to access shared ressources.
 **/

@class GameplayLayer;
@interface GameMechanics : NSObject

// determines the current state the game is in. Either menu mode (scene displayed beyond main menu) or gameplay mode.
@property (nonatomic, assign) GameState gameState;
@property (nonatomic, assign) float radiusOfWorld;

// reference to the current game object
@property (nonatomic, weak) Game *game;

// reference to the GamePlay-Scene
@property (nonatomic, weak) GameplayLayer *gameScene;


// stores the individual spawn rates for all monster types
@property (nonatomic, strong, readonly) NSMutableDictionary *spawnRatesByEnemyMonsterType;
@property (nonatomic, strong, readonly) NSMutableDictionary *spawnCostByPlayerMonsterType;

// gives access to the shared instance of this class
+ (id)sharedGameMechanics;



- (void)setSpawnRate:(int)spawnRate forEnemyMonsterType:(Class)monsterType;
- (int)spawnRateForEnemyMonsterType:(Class)monsterType;
- (void)setSpawnCost:(int)spawnCost forPlayerMonsterType:(Class)monsterType;
- (int)spawnCostForPlayerMonsterType:(Class)monsterType;

// Resets the complete State of the sharedGameMechanics. Should be called whenever a new game is started.
- (void)resetGame;

@end
