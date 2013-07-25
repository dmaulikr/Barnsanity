//
//  TutorialScreen2.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/21/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
#import "SpawnMonsterButton.h"

@interface TutorialScreen2 : CCLayer
{
    
    CCMenu *menu;
    CCMenuItemSprite *whatIFound;
    CCSprite *tapAndShoot;
    CCMenuItemSprite *finish;
    CCMenuItemSprite *practice;
    CCMenuItemSprite *play;
    int count;
     int waitCount;
    BOOL shootDidRun;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
    BOOL checkPoint4;
    BOOL monsterKilled;
    BOOL checkIfMonsterSpawned;
}

- (id)initWithGame;

@end
