//
//  MangoMonsterButton.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "MangoMonsterButton.h"
#import "Mango.h"
@implementation MangoMonsterButton
-(id) initWithEntityImage
{
    // Loading the Entity's sprite using a file, is a ship for now but you can change this
    if ((self = [super initWithFile:@"button_topdown-button.png"]))
    {
        self.nameOfMonster=@"Mango";
        [self setScale:.25];
        //include updates
        [self performSelector:@selector(updateTimer:) withObject:nil afterDelay:1.0];
                [self setColor:ccc3(255, 80, 70)];
    }
    return self;
}

-(void)pressed{
    if(fireDelayTimer<=0){
        angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
        if((angleOfSpawn <=0 && angleOfSpawn >= -180)||(angleOfSpawn >180 && angleOfSpawn < 359)){
            [[MonsterCache sharedMonsterCache] spawn:self.nameOfMonster atAngle:angleOfSpawn];
            fireDelayTimer=fireDelayInitial;
        }
    }
    
}
@end
