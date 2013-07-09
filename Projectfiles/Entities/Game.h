//
//  Game.h
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import <Foundation/Foundation.h>

/**
 Encapuslates one game session. All information related to one
 game session is stored with this object.
 */

@interface Game : NSObject
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger meters;
@property (nonatomic, assign) NSInteger enemiesKilled;

@property (nonatomic, assign) NSInteger gameplayLevel;
@property (nonatomic, assign) NSInteger gold;
@property (nonatomic, assign) NSInteger goldBonusPerMonster;
@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) NSInteger energyMax;
@property (nonatomic, assign) NSInteger energyPerSec;
@property (nonatomic, assign) NSInteger timeInSec;
@property (nonatomic, strong) NSMutableDictionary *levelsOfEverything;
@property (nonatomic, strong) NSMutableDictionary *gameInfo;

// currently active missions
@property (nonatomic, strong) NSMutableArray *missions;
// all available missions
@property (nonatomic, strong) NSArray *allMissions;

// tells the game, to replace completed missions with new ones
- (void)replaceCompletedMission;

@end
