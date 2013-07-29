//
//  Ship.m
//  AngryVeggie
//
//  Created by Danny on 6/25/13.
//
//

#import "Ship.h"
#import "MonsterCache.h"
#import "GameMechanics.h"

@implementation Ship
- (id)initWithMonsterPicture{
    
    // Loading the Entity's sprite using a file, is a ship for now but you can change this
    if ((self = [super initWithFile:@"cat3-topdown.png"]))
    {
        [self setScale:.5];
        
        //include updates
        [self scheduleUpdate];
        
    }
    return self;
    
}

-(void)fireBomb{
    if(!self.bombUsed){
        [[MonsterCache sharedMonsterCache] createBomb];
        self.bombUsed=TRUE;
    }
}

-(void)fireBullet{
    if(fireDelayTimer<=0){
        [[MonsterCache sharedMonsterCache] createShipBullet];
        fireDelayTimer=fireDelayInitial;
    }
}

-(void)fireSeedForMonster:(NSString*)name{
    [[MonsterCache sharedMonsterCache] createSeed:name];
}

-(void)update:(ccTime)delta{
    if(self.visible){
        if(fireDelayTimer>0){
            fireDelayTimer--;
        }
    }
}

-(void)reset{
    if([[GameMechanics sharedGameMechanics]game].maxGamePlayLevel>=10){
        self.bombUsed=FALSE;
    }else{
         self.bombUsed=TRUE;
    }
    int level=[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Ship Firerate"] integerValue];
    fireDelayInitial=[[[[[[GameMechanics sharedGameMechanics]game]gameInfo]objectForKey:@"Ship Firerate"]   objectAtIndex:level] integerValue];
}
@end
