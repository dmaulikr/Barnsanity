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
#import "Orange.h"

@implementation SpawnMonsterButton
-(id) initWithEntityImage
{
	// Loading the Entity's sprite using a file, is a ship for now but you can change this
	if ((self = [super initWithFile:@"button_topdown-button.png"]))
	{
        [self setScale:.25];
        fireDelayInitial=30;
        fireDelayTimer=0;
        //include updates
        [self scheduleUpdate];
	}
	return self;
}

-(void)pressed{
    if(fireDelayTimer<=0){
        angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
        if((angleOfSpawn <=0 && angleOfSpawn >= -180)||(angleOfSpawn >180 && angleOfSpawn < 359)){
            [[MonsterCache sharedMonsterCache] spawn:[Orange class] atAngle:angleOfSpawn];
            fireDelayTimer=fireDelayInitial;
        }
    }
    
}

-(void)update:(ccTime)delta{
    if(fireDelayTimer>0){
        fireDelayTimer--;
    }
}
@end
