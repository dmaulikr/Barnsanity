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
@interface Game : NSObject

@property (nonatomic, assign) NSInteger meters;

@property (nonatomic, assign) NSInteger difficulty;
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
@property (nonatomic, strong) NSMutableArray *playerMonsterList;

-(BOOL)loadGame;
-(void)saveGame;
-(void)newGame;
-(void)reset;
-(void)subtractGoldby:(NSInteger) cost;
-(void)increaseLevel:(NSString*) category;
-(void)beatLevel;
-(void)loseLevel;

@end
