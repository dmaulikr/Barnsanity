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
    

    CCSprite *whatIFound;
    CCSprite *tapAndShoot;
    CCSprite *finish;
    CCSprite *practice;
    CCSprite *play;
    int count;
     int waitCount;
    BOOL shootDidRun;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
    BOOL checkPoint4;
    BOOL checkPoint5;
    BOOL checkPoint6;
    BOOL monsterKilled;
    BOOL checkIfMonsterSpawned;
}

- (id)initWithGame;

@end
