//
//  BananaMonsterButton.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "BananaMonsterButton.h"
#import "Banana.h"
@implementation BananaMonsterButton
-(id) initWithEntityImage
{
    // Loading the Entity's sprite using a file, is a ship for now but you can change this
    if ((self = [super initWithFile:@"button_topdown-button.png"]))
    {
        nameOfMonster=@"Banana";
        [self setScale:.25];
        //include updates
        [self performSelector:@selector(updateTimer:) withObject:nil afterDelay:1.0];
                [self setColor:ccc3(200, 200, 200)];
    }
    return self;
}

-(void)pressed{
    if(fireDelayTimer<=0){
        angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
        if((angleOfSpawn <=0 && angleOfSpawn >= -180)||(angleOfSpawn >180 && angleOfSpawn < 359)){
            [[MonsterCache sharedMonsterCache] spawn:[Banana class] atAngle:angleOfSpawn];
            fireDelayTimer=fireDelayInitial;
        }
    }
    
}
@end