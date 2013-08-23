//
//  Banana.m
//  Barnsanity
//
//  Created by Danny on 8/22/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Banana.h"

@implementation Banana
- (id)initWithMonsterPicture
{
    self = [super initWithSpriteFrameName:@"animation_knight-1.png"];
    
    if (self)
    {
        nameOfMonster=@"Banana";
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
        
        attack = [CCSequence actions:startHit,[CCDelayTime actionWithDuration:1.6] , hitAction, [CCDelayTime actionWithDuration:1.6] ,finishHit, nil];
        
        
        //****************planting animation**************
        CCFiniteTimeAction *planting = [CCCallBlock actionWithBlock:^{
            self.attacking = FALSE;
            self.move=FALSE;
            self.ableToAttack=FALSE;
            float boundAngle1=[[MonsterCache sharedMonsterCache] playerBarn].boundingZoneAngle1;
            float boundAngle2=[[MonsterCache sharedMonsterCache] playerBarn].boundingZoneAngle2;
            if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
                if(self.angle<=boundAngle1 && self.angle>= boundAngle2){
                    self.invincible=TRUE;
                }else{
                    self.invincible=FALSE;
                }
            }else{
                if((self.angle<=boundAngle1 && self.angle>=0) || (self.angle<=0 && self.angle>= boundAngle2)){
                    self.invincible=TRUE;
                }else{
                    self.invincible=FALSE;
                }
            }
            
            spawnDelayTimer=spawnDelayInitial;
            delayTimer.percentage=100;
            float newPercentage=((float)(spawnDelayTimer-1)/(float)spawnDelayInitial)*100;
            [delayTimer runAction:[CCProgressFromTo actionWithDuration:1.0f from:delayTimer.percentage to:newPercentage]];
            
        }];
        plant=[CCSequence actions:planting, nil];
        
        //*************spawning*******************
        CCFiniteTimeAction *spawning = [CCCallBlock actionWithBlock:^{
            [self stopAction:plant];
            self.attacking = FALSE;
            self.move=TRUE;
            self.ableToAttack=TRUE;
            self.invincible=FALSE;
            [self stopAction:run];
            [self runAction:run];
            
        }];
        
        spawn=[CCSequence actions:spawning, nil];
        
        //****************death*****************
        CCFiniteTimeAction *dying = [CCCallBlock actionWithBlock:^{
            [self stopAction:run];
            self.attacking = FALSE;
            self.move=FALSE;
            self.ableToAttack=FALSE;
            self.invincible=TRUE;
            [self destroy];
            
        }];
        death=[CCSequence actions:dying, nil];
        
        //**********blink************
        blink = [CCSequence actions:[CCBlink actionWithDuration:.4f blinks:2],[CCShow action], nil];
        CCSprite *delayTimerImage=[[CCSprite alloc] initWithFile:@"n2pY1.png"];
        [delayTimerImage setColor:ccc3(2, 2, 200)];
        delayTimer=[CCProgressTimer progressWithSprite:delayTimerImage];
        [delayTimer setScale:.7];
        delayTimer.type =kCCProgressTimerTypeBar;
        delayTimer.midpoint = ccp(0,0.5);
        delayTimer.barChangeRate = ccp(1, 0);
        delayTimer.percentage=0;
        delayTimer.position=ccp(delayTimerImage.contentSize.width/4,2*self.contentSize.height/2+10);
        [self addChild:delayTimer];
        
        //for the prototype
        [self setScale:.7];
        //dark orange
        [self setColor:ccc3(255,255,0)];
        [self scheduleUpdate];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:TRUE];
        [self reset];
        
        
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
