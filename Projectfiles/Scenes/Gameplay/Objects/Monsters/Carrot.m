//
//  Carrot.m
//  Veg_V_Fruit
//
//  Created by Danny on 7/1/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Carrot.h"

@implementation Carrot
- (id)initWithMonsterPicture
{
    self = [super initWithSpriteFrameName:@"animation_knight-1.png"];
    
    if (self)
    {
        nameOfMonster=@"Carrot";
        
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
        
//        // run the animation
//        [self runAction:run];
        
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
//            [self stopAction:run];
                [self runAction:run];
            
        }];
        
        attack = [CCSequence actions:startHit,[CCDelayTime actionWithDuration:.5] , hitAction, [CCDelayTime actionWithDuration:.5] ,finishHit, nil];
        
        //get the radius of the world
        radiusToSpawn=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
        
        [self setScale:.5];
        
        blink = [CCBlink actionWithDuration:.4f blinks:2];
        //for the prototype
        [self setColor:ccc3(255, 0, 0)];
        //include update
        [self scheduleUpdate];
        
        NSDictionary *monsterInfo=[[[[[GameMechanics sharedGameMechanics]game]gameInfo] objectForKey:@"Enemy Monsters"]objectForKey:nameOfMonster ];
        self.hitPointsInit=[[monsterInfo objectForKey:@"Health"] integerValue];
        self.damage=[[monsterInfo objectForKey:@"Damage"]integerValue];
        speedAngle=[[monsterInfo objectForKey:@"Move Speed"] doubleValue] * (M_PI/1860);
        self.areaOfEffect=[[monsterInfo objectForKey:@"AreaOfEffect"] boolValue];
        self.areaOfEffectDamage=[[monsterInfo objectForKey:@"AreaOfEffect Damage"]integerValue];
        reward=[[monsterInfo objectForKey:@"Gold Reward"] integerValue];
        
        self.boundingAngle=atanf((self.contentSize.width/2)/(radiusToSpawn+self.contentSize.height/2));
        self.hitZoneAngle=atanf((self.contentSize.width/2)/(radiusToSpawn+self.contentSize.height/2));
        
    }
    
    return self;
}

- (void)update:(ccTime)delta
{
    if(self.move && self.alive){
        [self updateRunningMode:delta];
    }
}

- (void)updateRunningMode:(ccTime)delta
{
            [self changePosition];
    // calculate a hit zone
    CGPoint monsterCenter = ccp(self.position.x + self.contentSize.width / 2, self.position.y + self.contentSize.height / 2);
    CGSize hitZoneSize = CGSizeMake(self.contentSize.width/2, self.contentSize.height/2);
    self.hitZone = CGRectMake(monsterCenter.x - 0.5 * hitZoneSize.width, monsterCenter.y - 0.5 * hitZoneSize.width, hitZoneSize.width, hitZoneSize.height);
    
}


@end
