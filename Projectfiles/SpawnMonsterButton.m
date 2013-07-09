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
    int level=[[[[[[GameMechanics sharedGameMechanics]game]levelsOfEverything] objectForKey:@"Player Monsters"] objectForKey:nameOfMonster] integerValue];
    if(level >= 0){
        fireDelayInitial=[[[[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Player Monsters"] objectForKey:nameOfMonster] objectAtIndex:level]objectForKey:@"Delay"] integerValue];
    }
}

-(void) updateTimer:(NSTimer *) theTimer {
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        if(fireDelayTimer>0){
            fireDelayTimer--;
            delayTimer.percentage=((fireDelayTimer/fireDelayInitial)*100);

    }
    }
}

//-(CGRect)boundingBox{
//    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
//    return CGRectApplyAffineTransform(rect, [self nodeToParentTransform]);
//}

-(void)draw{
        ccColor4F rectColor = ccc4f(0.5, 0.5, 0.5, 1.0);
        ccDrawSolidRect(ccp(0,0), ccp(self.contentSize.width, self.contentSize.height), rectColor);
    [super draw];
}

@end
