//
//  Game.h
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import <Foundation/Foundation.h>
#import "MonsterButtonCache.h"
/**
 Encapuslates one game session. All information related to one
 game session is stored with this object.
 */
#define HARD 1
#define EASY 0
#define numSlot 3
@interface Game : NSObject

//is true if it is the first time playing
@property (nonatomic, assign) BOOL activateStoreTutorial;
//is true if it is the first time playing
@property (nonatomic, assign) BOOL activateLevel0Tutorial;
//is true if it is the first time playing
@property (nonatomic, assign) BOOL activateLevel1Tutorial;
//is true if it is the first time playing
@property (nonatomic, assign) BOOL activateLevel8Tutorial;
//is true if it is the first time playing
@property (nonatomic, assign) BOOL activateLevel10Tutorial;
//is true if it is the first time playing
@property (nonatomic, assign) BOOL activateLevel25Tutorial;

@property (nonatomic, assign) BOOL showCredits;
//indicates the difficulty level of the game
@property (nonatomic, assign) NSInteger difficulty;

//which game slot to use
@property (nonatomic, assign) NSInteger gameSlot;

//increase difficulty
@property (nonatomic, assign) float difficultyFactor;
//scores
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger scorePerLevel;
@property (nonatomic, assign) NSInteger highScoreForLevel;
@property (nonatomic, assign) NSInteger endLevelBonusScore;

//monster killed
@property (nonatomic, assign) NSInteger enemiesMonsterKilled;
@property (nonatomic, assign) NSInteger playerMonsterKilled;
@property (nonatomic, assign) NSInteger totalEnemiesMonsterKilled;
@property (nonatomic, assign) NSInteger totalPlayerMonsterKilled;

//levels
@property (nonatomic, assign) NSInteger maxGamePlayLevel;
@property (nonatomic, assign) NSInteger gameplayLevel;

//gold
@property (nonatomic, assign) NSInteger totalGold;
@property (nonatomic, assign) NSInteger gold;
@property (nonatomic, assign) NSInteger goldForLevel;
@property (nonatomic, assign) NSInteger goldBonusPerMonster;
@property (nonatomic, assign) NSInteger endLevelBonusGold;
@property (nonatomic, assign) NSInteger highScoreForGold;

//energy
@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) NSInteger energyMax;
@property (nonatomic, assign) NSInteger energyPerSec;

//time
@property (nonatomic, assign) NSInteger timeForCrazyMode;
@property (nonatomic, assign) NSInteger timeInSec;
@property (nonatomic, assign) NSInteger timeInSecInit;
@property (nonatomic, assign) NSInteger totalTimePlayed;

//game info
@property (nonatomic, strong) NSMutableDictionary *levelsOfEverything;
@property (nonatomic, strong) NSMutableDictionary *gameInfo;
@property (nonatomic, strong) NSMutableDictionary *gameItemInfo;

//seeds in slot
@property (nonatomic, strong) NSMutableArray *seedsUsed;

//names of all monsters and upgrades
@property (nonatomic, strong) NSMutableArray *playerMonsterList;
@property (nonatomic, strong) NSMutableArray *enemyMonsterList;
@property (nonatomic, strong) NSMutableArray *utilUpgradeList;

//loads the game
-(void)loadGame;
//saves the game
-(void)saveGame;
//when there is a new game
-(void)newGame;
-(void)reset;
//subtract gold
-(void)subtractGoldby:(NSInteger) cost;
//increase level of the given category
-(void)increaseLevel:(NSString*) category;
//calculates the scores
-(void)beatLevel;
//calculates the loses
-(void)loseLevel;

@end
