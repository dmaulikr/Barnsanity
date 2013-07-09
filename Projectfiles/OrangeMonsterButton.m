//
//  OrangeMonsterButton.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "OrangeMonsterButton.h"
#import "Orange.h"
#import "MonsterCache.h"
#import "GameMechanics.h"

@implementation OrangeMonsterButton
-(id) initWithEntityImage
{
    self = [super initWithFile:@"button_topdown-button.png"];
    	// Loading the Entity's sprite using a file, is a ship for now but you can change this
    	if (self)
    	{
            nameOfMonster=@"Orange";
            [self setScale:.25];
            delayTimer=[CCProgressTimer progressWithSprite:self];
            delayTimer.type =kCCProgressTimerTypeRadial;
            delayTimer.percentage=100;
            //include updates
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:TRUE];
    	}
    return self;
}

-(void)pressed{
        if(fireDelayTimer<=0){
            angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
            if((angleOfSpawn <=0 && angleOfSpawn >= -180)||(angleOfSpawn >180 && angleOfSpawn < 359)){
                [[MonsterCache sharedMonsterCache] spawn:[Orange class] atAngle:angleOfSpawn];
                fireDelayTimer=fireDelayInitial;
                delayTimer.percentage=100;
            }
        }
    
}



@end
