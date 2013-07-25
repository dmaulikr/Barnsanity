//
//  PeaPod.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "PeaPod.h"

@implementation PeaPod
- (id)initWithMonsterPicture
{
    self = [super initWithSpriteFrameName:@"animation_knight-1.png"];
    
    if (self)
    {
        nameOfMonster=@"PeaPod";
        
		//self.velocity = CGPointMake(-30, 0);
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"animation_knight.plist"];
        
        // ************* RUNNING ANIMATION ********************
        
        animationFramesRunning = [NSMutableArray array];
        
        for(int i = 1; i <= 4; ++i)
        {
            [animationFramesRunning addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"animation_knight-%d.png", i]]];
        }
        
        //Create an animation from the set of frames you created earlier
        CCAnimation *running = [CCAnimation animationWithSpriteFrames: animationFramesRunning delay:0.1f];
        
        //Create an action with the animation that can then be assigned to a sprite
        run = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:running]];
        
        
        //Create an action with the animation that can then be assigned to a sprite
        run = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:running]];
        
        
        // ************* STABBING ANIMATION ********************
        
        animationFramesAttack = [NSMutableArray array];
        
        for (int i = 1; i <= 2; i++)
        {
            [animationFramesAttack addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"animation_knight-stab-%d.png", i]]];
        }
        
        CCAnimation *hitting = [CCAnimation animationWithSpriteFrames:animationFramesAttack delay:.5f];
        
        CCAction *hitAction = [CCCallBlock actionWithBlock:^{
            [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:hitting] times:1];
        }];
        
        CCFiniteTimeAction *startHit = [CCCallBlock actionWithBlock:^{
            // stop running animation
            self.attacking = TRUE;
            [self stopAction:run];
        }];
        
        CCFiniteTimeAction *finishHit = [CCCallBlock actionWithBlock:^{
            self.attacking = FALSE;
            // restart running animation
            [self stopAction:run];
            [self runAction:run];
            
        }];
        
        attack = [CCSequence actions:startHit,[CCDelayTime actionWithDuration:.5] , hitAction, [CCDelayTime actionWithDuration:.5] ,finishHit, nil];
        
        //*********Plant animation**********
        CCFiniteTimeAction *planting = [CCCallBlock actionWithBlock:^{
            
            self.attacking = FALSE;
            self.move=FALSE;
            self.ableToAttack=FALSE;
            float boundAngle1=[[MonsterCache sharedMonsterCache] enemyBarn].boundingZoneAngle1;
            float boundAngle2=[[MonsterCache sharedMonsterCache] enemyBarn].boundingZoneAngle2;
            if(self.angle<=boundAngle1 && self.angle>= boundAngle2){
                self.invincible=TRUE;
            }else{
                self.invincible=FALSE;
            }
        }];
        
        //************Spawn animation
        CCFiniteTimeAction *spawning = [CCCallBlock actionWithBlock:^{
            //            [self stopAction:plant];
            
            self.attacking = FALSE;
            self.move=TRUE;
            self.ableToAttack=TRUE;
            self.invincible=FALSE;
            [self stopAction:run];
            [self runAction:run];
        }];
        
        plant=[CCSequence actions:planting,[CCDelayTime actionWithDuration:1],spawning, nil];
        
        //*********Death************
        CCFiniteTimeAction *dying = [CCCallBlock actionWithBlock:^{
            [self stopAction:run];
            self.attacking = FALSE;
            self.move=FALSE;
            self.ableToAttack=FALSE;
            self.invincible=TRUE;
            [self destroy];
            
        }];
        death=[CCSequence actions:dying, nil];
        
        
        //*************blink***************
        blink = [CCBlink actionWithDuration:.4f blinks:2];
        
        //for the prototype
        //honeydew
        [self setColor:ccc3(240,255,240)];
        [self setScale:.5];
        //include update
        [self scheduleUpdate];
        [self setStats];
        
        
    }
    
    return self;
}

- (void)update:(ccTime)delta
{
    if(self.move && self.alive){
        [self changePosition];
    }
}

@end
