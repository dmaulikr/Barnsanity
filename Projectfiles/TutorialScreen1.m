//
//  TutorialScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/19/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "TutorialScreen1.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "MonsterCache.h"
#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"

@implementation TutorialScreen1
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
        [[GameMechanics sharedGameMechanics]gameScene].energy.visible=FALSE;
        [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=FALSE;
        [[GameMechanics sharedGameMechanics]gameScene].ableToShoot=FALSE;
        [[MonsterCache sharedMonsterCache] setAbleToSpawn:FALSE];
        [[MonsterButtonCache sharedMonsterButtonCache] hideButtons];
        [self scheduleUpdate];
        yourBarn=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-1.png"] selectedSprite:nil block:^(id sender) {
            checkPoint1=TRUE;
            yourBarn.visible=FALSE;
        }];
        yourBarn.position=ccp(0,0);
        
        enemyBarn=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-2.png"] selectedSprite:nil block:^(id sender) {
            checkPoint2=TRUE;
            enemyBarn.visible=FALSE;
        }];
        enemyBarn.visible=FALSE;
        enemyBarn.position=ccp(0,0);
        
        firstPlant=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-3.png"] selectedSprite:nil block:^(id sender) {
        }];
        firstPlant.visible=FALSE;
        firstPlant.position=ccp(0,0);
        
        plantMore=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-4.png"] selectedSprite:nil block:^(id sender) {
            didMove=FALSE;
            checkPoint5=TRUE;
            plantMore.visible=FALSE;
            swipeToMove.visible=TRUE;
            [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
            swipe.visible=TRUE;
        }];
        plantMore.visible=FALSE;
        plantMore.position=ccp(0,0);
        
        swipeToMove=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-5.png"] selectedSprite:nil block:^(id sender) {
        }];
        swipeToMove.visible=FALSE;
        swipeToMove.position=ccp(0,0);
        
        cantPlant=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-6.png"] selectedSprite:nil block:^(id sender) {
            cantPlant.visible=FALSE;
            play.visible=TRUE;
            checkPoint6=TRUE;
            waitCount=count;
        }];
        cantPlant.visible=FALSE;
        cantPlant.position=ccp(0,0);
        
        play=[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"Tutorial1-7.png"] selectedSprite:nil block:^(id sender) {
            
        }];
        play.visible=FALSE;
        play.position=ccp(0,0);
        
        pointToSeed=[CCSprite spriteWithFile:@"pointToEnergy.png"];
        pointToSeed.visible=FALSE;
        pointToSeed.position=ccp(-self.contentSize.width/5,self.contentSize.height/2-10);
        [self addChild:pointToSeed];
        pointToButton=[CCSprite spriteWithFile:@"pointToButton.png"];
        pointToButton.visible=FALSE;
        pointToButton.position=ccp(self.contentSize.width/4+10,(self.contentSize.height-firstButton.contentSize.height/4)/2-30);
        [self addChild:pointToButton];
        swipe=[CCSprite spriteWithFile:@"swipe.png"];
        swipe.visible=FALSE;
        swipe.position=ccp(0,-(self.contentSize.height)/2+40);
        [self addChild:swipe];
        
        //button to spawn plant
        firstButton=[CCSprite spriteWithFile:@"OrangeButton.png"];
        [firstButton setScale:.7];
        monsterButton=[CCMenuItemSprite itemWithNormalSprite:firstButton selectedSprite:nil block:^(id sender) {
            if(checkPoint3 || checkPoint7){
            float angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
            if((angleOfSpawn <=0 && angleOfSpawn >= -180)||(angleOfSpawn >180 && angleOfSpawn < 359)){
                if(10<=[[GameMechanics sharedGameMechanics]game].energy){
                    [[GameMechanics sharedGameMechanics]game].energy-=10;
                    [[[[GameMechanics sharedGameMechanics]gameScene]ship]fireSeedForMonster:@"Orange"];
                    if(checkPoint3){
                        [firstButton stopAllActions];
                        firstPlant.visible=FALSE;
                        pointToButton.visible=FALSE;
                        pointToSeed.visible=FALSE;
                        waitCount=count;
                        checkPoint3=FALSE;
                        checkPoint4=TRUE;
                        blinkDidRun=FALSE;
                    }
                }
            }
            }
            if(checkPoint5 && blinkDidRun){
                [firstButton stopAllActions];
                cantPlant.visible=TRUE;
                pointToButton.visible=FALSE;
                checkPoint5=FALSE;
            }
            
        }];
        monsterButton.position=ccp((self.contentSize.width-firstButton.contentSize.width/5)/2-15,(self.contentSize.height-firstButton.contentSize.height/4)/2-10);
        menu=[CCMenu menuWithItems:yourBarn, enemyBarn, firstPlant, plantMore,swipeToMove,cantPlant, monsterButton, play,nil];
        menu.position=ccp(0,0);
        [self addChild:menu];
        monsterButton.visible=FALSE;
        blink=[CCBlink actionWithDuration:1.5f blinks:1];
        blinkDidRun=FALSE;
        monsterProduced=0;
        didMove=TRUE;
        count=0;    }
    
    return self;
}

-(void)update:(ccTime)delta{

        count++;
        if(count >30){
            if(checkPoint1){
                [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation+=2.5;
                if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==125){
                    enemyBarn.visible=TRUE;
                    checkPoint1=FALSE;
                }
            }else if(checkPoint2){
                [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation-=2.5;
                if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==-120){
                    checkPoint2=FALSE;
                    checkPoint3=TRUE;
                    waitCount=count;
                }
            }else if(checkPoint3 && count-waitCount>=20){
                if(!blinkDidRun){
                    blinkDidRun=TRUE;
                    monsterButton.visible=TRUE;
                    [firstButton runAction:[CCRepeatForever actionWithAction:blink]];
                    firstPlant.visible=TRUE;
                    [[GameMechanics sharedGameMechanics]gameScene].energy.visible=TRUE;
                                        [[[[GameMechanics sharedGameMechanics]gameScene]energy ]resetEnergy:[[GameMechanics sharedGameMechanics]game].energyMax increasedAt:[[GameMechanics sharedGameMechanics]game].energyPerSec];
                    pointToButton.visible=TRUE;
                    pointToSeed.visible=TRUE;
                    
                }
                
            }else if(checkPoint4 && count-waitCount>50){
                plantMore.visible=TRUE;
                [[[GameMechanics sharedGameMechanics]gameScene] energy].run=FALSE;
                [[MonsterCache sharedMonsterCache]gamePaused];
                checkPoint4=FALSE;
            }else if(checkPoint5){
                if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation>=30){
                    if(!blinkDidRun){
                        blinkDidRun=TRUE;
                        [firstButton runAction:[CCRepeatForever actionWithAction:blink]];
                        swipe.visible=FALSE;
                        [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=FALSE;
                        pointToButton.visible=TRUE;
                    }
                }
            }else if(checkPoint6 && count-waitCount >=70){
                play.visible=FALSE;
                [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
//                [[MonsterCache sharedMonsterCache]spawnEnemyOfType:@"Carrot" atAngle:M_PI+M_PI_4/2];
                [[MonsterCache sharedMonsterCache] setAbleToSpawn:TRUE];
                [[[GameMechanics sharedGameMechanics]gameScene] energy].run=TRUE;
                [[[GameMechanics sharedGameMechanics]gameScene]enableGamePlayButtons];
                [[MonsterCache sharedMonsterCache]gameResumed];
                checkPoint6=FALSE;
                checkPoint7=TRUE;
            }
            
        }
    
    if(!didMove){
        if(fabsf([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation +120) >3){
                        swipeToMove.visible=FALSE;
            didMove=TRUE;
        }
    }
        
    
}


-(void)exitTutorial{
    //remove this layer before going to the level selection layer
    self.visible = FALSE;
    [self removeFromParentAndCleanup:TRUE];
    [[[GameMechanics sharedGameMechanics]gameScene]enableGamePlayButtons];
    [[[GameMechanics sharedGameMechanics]gameScene]goTolevelSelection];
    
}




@end
