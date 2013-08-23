//
//  Beet.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Beet.h"

@implementation Beet
- (id)initWithMonsterPicture
{
    self = [super initWithSpriteFrameName:@"animation_knight-1.png"];
    
    if (self)
    {
        nameOfMonster=@"Beet";
        
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
        //dark violet
        [self setColor:ccc3(148,0,211)];
        [self setScale:.67];
        //include update
        [self scheduleUpdate];
        [self setStats];
        
        
    }
    
    return self;
}

//- (void)spawnAt:(float) angleOfLocation
//{
//    //start update and run action
//    [self stopAllActions];
//    //get the radius of the world
//    radiusOfWorld=[[GameMechanics sharedGameMechanics] gameScene].radiusOfWorld;
//    //calculate where to spawn
//    self.radiusToSpawn=radiusOfWorld+CCRANDOM_MINUS1_1()*self.radiusToSpawnDelta-5;
//    radiusOfPosition= self.radiusToSpawn;
//    ceiling=self.radiusToSpawn+80;
//    floor=self.radiusToSpawn+60;
//    //calculate the boudzone and hit zone of the monster
//    self.boundingZone= atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2.5;
//    self.hitZone=CCRANDOM_MINUS1_1()*(M_PI/550)+self.range*atanf((self.contentSize.width/2)/(radiusOfWorld+self.contentSize.height/2))/2;
//    
//    //base on where you spawn, set the zorder of the monster
//    [self setZOrder:(NSInteger)((2*radiusOfWorld)-self.radiusToSpawn)];
//    
//    
//    //set up spawn locaiton
//    //angle of the spawn
//    self.angle=angleOfLocation;
//    self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
//    // Select a spawn location
//    float xPos=  self.radiusToSpawn*cos(self.angle);
//    float yPos=  self.radiusToSpawn*sin(self.angle);
//    //set the location
//    self.position = CGPointMake(xPos, yPos);
//    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
//    //set up the hit zone angles according to the direction they are moving towards
//    if([[GameMechanics sharedGameMechanics]game].difficulty==EASY){
//        self.flipX=0;
//        self.moveDirection=right;
//        self.hitZoneAngle1=self.angle;
//        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
//        self.hitZoneAngle2=self.angle-self.hitZone;
//        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
//    }else{
//        
//        if(self.angle<=M_PI){
//            self.flipX=0;
//            self.moveDirection=right;
//            self.hitZoneAngle1=self.angle;
//            self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
//            self.hitZoneAngle2=self.angle-self.hitZone;
//            self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
//        }else{
//            self.moveDirection=left;
//            self.flipX=180;
//            self.hitZoneAngle1=self.angle+self.hitZone;
//            self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
//            self.hitZoneAngle2=self.angle;
//            self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
//        }
//    }
//    self.boundingZoneAngle1=self.angle+self.boundingZone;
//    self.boundingZoneAngle1=fmodf(self.boundingZoneAngle1+2*M_PI, 2*M_PI);
//    self.boundingZoneAngle2=self.angle-self.boundingZone;
//    self.boundingZoneAngle2=fmodf(self.boundingZoneAngle2+2*M_PI, 2*M_PI);
//    
//    
//    
//    //set health point
//    self.hitPoints=self.hitPointsInit;
//    self.damage+=CCRANDOM_MINUS1_1()*self.damageDelta;
//	// Finally set yourself to be visible, this also flag the enemy as "in use"
//	self.visible = YES;
//    self.alive=TRUE;
//    self.attacked=FALSE;
//    self.attacking=FALSE;
//    self.hitDidRun=FALSE;
//    blinkDidRun=FALSE;
//    deltaRadius=1;
//    [self runAction:plant];
//	
//}
//
//-(void)changePosition{
//    //move the monster M_PI/480 in a direction
//    float deltaSpeed;
//    if([[GameMechanics sharedGameMechanics]game].difficulty==HARD){
//        deltaSpeed=(M_PI/5850);
//    }else{
//        deltaSpeed=(M_PI/5000);
//    }
//    if(self.moveDirection==left){
//        self.angle+=speed* deltaSpeed;
//        self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
//        self.hitZoneAngle1=self.angle+self.hitZone;
//        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
//        self.hitZoneAngle2=self.angle;
//        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
//    }else{
//        self.angle-=speed* deltaSpeed;
//        self.angle=fmodf(self.angle+2*M_PI, 2*M_PI);
//        self.hitZoneAngle1=self.angle;
//        self.hitZoneAngle1=fmodf(self.hitZoneAngle1+2*M_PI, 2*M_PI);
//        self.hitZoneAngle2=self.angle-self.hitZone;
//        self.hitZoneAngle2=fmodf(self.hitZoneAngle2+2*M_PI, 2*M_PI);
//    }
//    
//    self.boundingZoneAngle1=self.angle+self.boundingZone;
//    self.boundingZoneAngle1=fmodf(self.boundingZoneAngle1+2*M_PI, 2*M_PI);
//    self.boundingZoneAngle2=self.angle-self.boundingZone;
//    self.boundingZoneAngle2=fmodf(self.boundingZoneAngle2+2*M_PI, 2*M_PI);
//    
//    radiusOfPosition=radiusOfPosition+deltaRadius;
//    if(deltaRadius>0){
//        if(radiusOfPosition>=ceiling){
//            deltaRadius=-.35;
//        }
//    }else{
//        if(radiusOfPosition<floor){
//            deltaRadius=.35;
//        }
//    }
//    
//    float deltaX=radiusOfPosition*cos(self.angle);
//    float deltaY=radiusOfPosition*sin(self.angle);
//    CGPoint newPosition = ccp(deltaX, deltaY);
//    
//    
//    self.rotation=CC_RADIANS_TO_DEGREES(-self.angle+M_PI_2);
//    
//    [self setPosition:newPosition];
//}


- (void)update:(ccTime)delta
{
    if(self.move && self.alive){
        [self changePosition];
    }
}

@end
