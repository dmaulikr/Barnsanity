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
        
        yourBarn=[CCSprite spriteWithFile:@"Tutorial1-1.png"];
        yourBarn.position=ccp(0,0);
                [self addChild:yourBarn];
        enemyBarn=[CCSprite spriteWithFile:@"Tutorial1-2.png"];
        enemyBarn.visible=FALSE;
        enemyBarn.position=ccp(0,0);
                [self addChild:enemyBarn];
        firstPlant=[CCSprite spriteWithFile:@"Tutorial1-3.png"];
        firstPlant.visible=FALSE;
        firstPlant.position=ccp(0,0);
                [self addChild:firstPlant];
        plantMore=[CCSprite spriteWithFile:@"Tutorial1-4.png"];
        plantMore.visible=FALSE;
        plantMore.position=ccp(0,0);
                [self addChild:plantMore];
        swipeToMove=[CCSprite spriteWithFile:@"Tutorial1-5.png"] ;
        swipeToMove.visible=FALSE;
        swipeToMove.position=ccp(0,0);
                [self addChild:swipeToMove];
        cantPlant=[CCSprite spriteWithFile:@"Tutorial1-6.png"];
        cantPlant.visible=FALSE;
        cantPlant.position=ccp(0,0);
                [self addChild:cantPlant];
        play=[CCSprite spriteWithFile:@"Tutorial1-7.png"];
        play.visible=FALSE;
        play.position=ccp(0,0);
        [self addChild:play];
        
        tapEnemyBarn=[CCSprite spriteWithFile:@"Tutorial1-8.png"];
        tapEnemyBarn.visible=FALSE;
        tapEnemyBarn.position=ccp(0,0);
        [self addChild:tapEnemyBarn];
        
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
            if(checkPoint3 || checkPoint8){
            float angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
            if((angleOfSpawn <=-22.5 && angleOfSpawn >= -157.5)||(angleOfSpawn >202.5 && angleOfSpawn < 337.5)){
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
                tapEnemyBarn.visible=FALSE;
                pointToButton.visible=FALSE;
                checkPoint5=FALSE;
                checkPoint6=TRUE;
                [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
            }
            
        }];
        monsterButton.position=ccp((self.contentSize.width-firstButton.contentSize.width/5)/2-15,(self.contentSize.height-firstButton.contentSize.height/4)/2-10);
        monsterButton.visible=FALSE;
        menu=[CCMenu menuWithItems:monsterButton, nil];
        menu.position=ccp(0,0);
        [self addChild:menu];
        blink=[CCBlink actionWithDuration:1.5f blinks:1];
        blinkDidRun=FALSE;
        monsterProduced=0;
        didMove=TRUE;
        count=0;
        checkPoint1=TRUE;
     [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;}
    
    return self;
}

-(void)update:(ccTime)delta{

        count++;
        if(count >30){
            if(checkPoint1 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
                yourBarn.visible=FALSE;
                [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation+=2.5;
                if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==125){
                    enemyBarn.visible=TRUE;
                    checkPoint1=FALSE;
                    checkPoint2=TRUE;
                    [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
                }
            }else if(checkPoint2 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
                enemyBarn.visible=FALSE;
                [[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation-=2.5;
                if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation==-120){
                    [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
                    firstPlant.visible=TRUE;
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
                checkPoint5=TRUE;
                [[GameMechanics sharedGameMechanics]gameScene].touchHappened=FALSE;
                didMove=FALSE;
                
            }else if(checkPoint5 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened){
                plantMore.visible=FALSE;
    
                if(!didMove){
                    swipeToMove.visible=TRUE;
                    swipe.visible=TRUE;
                    [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
                }
                if([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation>=100){
                    if(!blinkDidRun){
                        blinkDidRun=TRUE;
                        [firstButton runAction:[CCRepeatForever actionWithAction:blink]];
                        swipe.visible=FALSE;
                        [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=FALSE;
                        pointToButton.visible=TRUE;
                        tapEnemyBarn.visible=TRUE;
                    }
                }
            }else if(checkPoint6 && [[GameMechanics sharedGameMechanics]gameScene].touchHappened ){
                cantPlant.visible=FALSE;
                play.visible=TRUE;
                checkPoint6=FALSE;
                checkPoint7=TRUE;
                waitCount=count;
            }else if(checkPoint7 && count-waitCount >=70 ){
                play.visible=FALSE;
                [[GameMechanics sharedGameMechanics]gameScene].ableToRotate=TRUE;
                [[MonsterCache sharedMonsterCache] setAbleToSpawn:TRUE];
                [[[GameMechanics sharedGameMechanics]gameScene] energy].run=TRUE;
                [[[GameMechanics sharedGameMechanics]gameScene]enableGamePlayButtons];
                [[MonsterCache sharedMonsterCache]gameResumed];
                checkPoint7=FALSE;
                checkPoint8=TRUE;
            }
            
        }
    
    if(!didMove){
        if(fabsf([[GameMechanics sharedGameMechanics]gameScene].centerOfRotation.rotation +120) >3){
                        swipeToMove.visible=FALSE;
            didMove=TRUE;
            [[MonsterCache sharedMonsterCache]reset];
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
