//
//  StrawberryMonsterButton.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "StrawberryMonsterButton.h"
#import "Strawberry.h"
@implementation StrawberryMonsterButton
-(id) initWithEntityImage
{
    // Loading the Entity's sprite using a file, is a ship for now but you can change this
    if ((self = [super initWithFile:@"button_topdown-button.png"]))
    {
        self.nameOfMonster=@"Strawberry";
        [self setScale:.25];
        //include updates
        CCSprite *delayTimerImage=[[CCSprite alloc] initWithFile:@"button_topdown-button.png"];
        [delayTimerImage setColor:ccc3(2, 2, 200)];
        delayTimer=[CCProgressTimer progressWithSprite:delayTimerImage];
        delayTimer.type =kCCProgressTimerTypeRadial;
        delayTimer.barChangeRate = ccp(1, 0);
        delayTimer.percentage=0;
        [self addChild:delayTimer];
        [delayTimer setPosition:ccp(self.position.x+self.contentSize.width/2, self.position.y+self.contentSize.height/2)];
        //include updates
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:TRUE];
        [self pauseSchedulerAndActions];
                [self setColor:ccc3(0, 50, 50)];
        CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"avenir24.fnt"];
        scoreLabel.anchorPoint = ccp(0,0.5);
        scoreLabel.string = [NSString stringWithFormat:@"15"];
        [scoreLabel setScale:5.0f];
        [scoreLabel setPosition:ccp(self.position.x+self.contentSize.width/4, self.position.y+self.contentSize.height/2)];
        [self addChild:scoreLabel];
    }
    return self;
}

-(void)pressed{
    if(fireDelayTimer<=0){
        int cost = [[GameMechanics sharedGameMechanics] spawnCostForPlayerMonsterType:[Strawberry class]];
        if(cost<=[[GameMechanics sharedGameMechanics]game].energy){
            [[GameMechanics sharedGameMechanics]game].energy-=cost;

        angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
        if((angleOfSpawn <=0 && angleOfSpawn >= -180)||(angleOfSpawn >180 && angleOfSpawn < 359)){
            [[MonsterCache sharedMonsterCache] spawn:[Strawberry class] atAngle:angleOfSpawn];
            fireDelayTimer=fireDelayInitial;
            delayTimer.percentage=100;
            float newPercentage=((float)(fireDelayTimer-1)/(float)fireDelayInitial)*100;
            [delayTimer runAction:[CCProgressFromTo actionWithDuration:1.0f from:delayTimer.percentage to:newPercentage]];
            [self resumeSchedulerAndActions];
        }
        }
    }
    
}
@end
