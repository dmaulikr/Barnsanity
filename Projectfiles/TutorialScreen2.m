//
//  TutorialScreen2.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/21/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "TutorialScreen2.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "MonsterCache.h"
#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"


@implementation TutorialScreen2
- (id)initWithGame
{
    self = [super init];
    
    if (self)
    {
        self.contentSize = [[CCDirector sharedDirector] winSize];
        // position of screen, animate to screen
        self.position = ccp(self.contentSize.width / 2, self.contentSize.height * .5);
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:SCREEN_BG_COLOR_TRANSPARENT];
        [self addChild:colorLayer z:0];
        [[GameMechanics sharedGameMechanics]gameScene].timer.visible=FALSE;
        [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=FALSE;
        [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=FALSE;
        [[MonsterCache sharedMonsterCache] setAbleToSpawn:FALSE];
            [[[[GameMechanics sharedGameMechanics]gameScene]energy ]resetEnergy:[[GameMechanics sharedGameMechanics]game].energyMax increasedAt:0];
        [self scheduleUpdate];
        
        whatIFound=[CCSprite spriteWithFile:@"Tutorial2-1.png"];
        whatIFound.position=ccp(0,0);
        [self addChild:whatIFound];
        tapAndShoot=[CCSprite spriteWithFile:@"Tutorial2-2.png"];
        tapAndShoot.visible=FALSE;
        tapAndShoot.position=ccp(0,0);
        [self addChild:tapAndShoot];
        practice=[CCSprite spriteWithFile:@"Tutorial2-3.png"];
        practice.visible=FALSE;
        practice.position=ccp(0,0);
        [self addChild:practice];
        finish=[CCSprite spriteWithFile:@"Tutorial2-4.png"];
        finish.visible=FALSE;
        finish.position=ccp(0,0);
        [self addChild:finish];
        play=[CCSprite spriteWithFile:@"Tutorial1-7.png"];
        play.visible=FALSE;
        play.position=ccp(0,0);
[self addChild:play];
        shootDidRun=FALSE;
        monsterKilled=TRUE;
        checkIfMonsterSpawned=FALSE;
        count=0;
        [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
        checkPoint1=TRUE;
    }
    
    return self;
}

-(void)update:(ccTime)delta{
    if([[GameMechanics sharedGameMechanics] gameState]==GameStateRunning){
        count++;
        if(checkPoint1 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
            whatIFound.visible=FALSE;
            [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation+=2.5;
            if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==115){
                checkPoint1=FALSE;
                tapAndShoot.visible=TRUE;
                [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=TRUE;
            }
        }else if(checkPoint2 && count-waitCount>80){
            tapAndShoot.visible=FALSE;
            [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=FALSE;
            practice.visible=TRUE;
            checkPoint2=FALSE;
            checkPoint3=TRUE;
            waitCount=count;
        }else if(checkPoint3 &&  count-waitCount>180){
            practice.visible=FALSE;
            [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=TRUE;
            [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
            [[MonsterCache sharedMonsterCache]spawnEnemyOfType:@"Carrot" atAngle:M_PI+M_PI_4/2 ];
            checkIfMonsterSpawned=TRUE;
            checkPoint3=FALSE;
            waitCount=count;
        }else if(checkPoint4 && count-waitCount>15){
            finish.visible=TRUE;
            checkPoint4=FALSE;
            waitCount=count;
            //[[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
            checkPoint5=TRUE;
        }else if(checkPoint5 && count-waitCount>=160){
            finish.visible=FALSE;
            play.visible=TRUE;
            checkPoint5=FALSE;
            checkPoint6=TRUE;
            waitCount=count;
        }else if(checkPoint6 && count-waitCount>=90){
            [[MonsterCache sharedMonsterCache]spawnEnemyOfType:@"Carrot" atAngle:M_PI ];
            [[MonsterCache sharedMonsterCache]spawnEnemyOfType:@"Carrot" atAngle:M_PI+3*M_PI_4/4 ];
            [self exitTutorial];
        }
        
        if(!shootDidRun){
            if([[MonsterCache sharedMonsterCache]anyMonsterAliveOfType:@"Ship Bullets"]){
                shootDidRun=TRUE;
                tapAndShoot.visible=FALSE;
                checkPoint2=TRUE;
                waitCount=count;
            }
        }
        if(checkIfMonsterSpawned){
            if([[MonsterCache sharedMonsterCache]anyMonsterAliveOfType:@"Carrot"]){
                monsterKilled=FALSE;
                checkIfMonsterSpawned=FALSE;
            }
        }
        if(!monsterKilled){
            if(![[MonsterCache sharedMonsterCache]anyMonsterAliveOfType:@"Carrot"]){
                monsterKilled=TRUE;
                checkPoint4=TRUE;
                waitCount=count;
                [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=FALSE;
            }
        }
    }
}

-(void)exitTutorial{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    [[[GameMechanics sharedGameMechanics]gameScene]enableGamePlayButtons];
    [[GameMechanics sharedGameMechanics]gameScene].energy.visible=TRUE;
    [[MonsterButtonCache sharedMonsterButtonCache] showButtons];
    [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=TRUE;
    [[[[GameMechanics sharedGameMechanics]gameScene]energy ]resetEnergy:[[GameMechanics sharedGameMechanics]game].energyMax increasedAt:[[GameMechanics sharedGameMechanics]game].energyPerSec];
    [[MonsterCache sharedMonsterCache] setAbleToSpawn:TRUE];
    [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
}


@end
