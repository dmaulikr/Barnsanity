//
//  SpawnMonsterButton.m
//  AngryVeggie
//
//  Created by Danny on 6/27/13.
//
//

#import "SpawnMonsterButton.h"
#import "MonsterCache.h"
#import "GameMechanics.h"

@implementation SpawnMonsterButton
-(id) initWithEntityImage
{
     @throw @"- (id)initWithEntityImage has to be implemented in Subclass.";

}

-(void)pressed{
        @throw @"- (void)pressed has to be implemented in Subclass.";
}

-(void)updateDelay{
    int level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:self.nameOfMonster] integerValue];
    if(level >= 0){
        fireDelayInitial=[[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:self.nameOfMonster] objectAtIndex:level]objectForKey:@"Delay"] integerValue];
    }
    fireDelayTimer=0;
delayTimer.percentage=0;
}

-(void) updateTimer:(NSTimer *) theTimer {
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        if(fireDelayTimer>0){
            fireDelayTimer--;
            float newPercentage=((float)(fireDelayTimer-1)/(float)fireDelayInitial)*100;
            [delayTimer runAction:[CCProgressFromTo actionWithDuration:1.0f from:delayTimer.percentage to:newPercentage]];

    }
    }
}



@end
