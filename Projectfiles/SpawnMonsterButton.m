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
-(id) initWithEntityImage:(NSString*)fileName andMonster:(NSString *)monsterName
{
    self = [super initWithFile:fileName];
    // Loading the Entity's sprite using a file, is a ship for now but you can change this
    if (self)
    {
        self.nameOfMonster=monsterName;
        [self setScale:.7];
        CCSprite *delayTimerImage=[[CCSprite alloc] initWithFile:fileName];
        [delayTimerImage setColor:ccc3(2, 2, 200)];
        delayTimer=[CCProgressTimer progressWithSprite:delayTimerImage];
        delayTimer.type =kCCProgressTimerTypeRadial;
        delayTimer.barChangeRate = ccp(1, 0);
        delayTimer.percentage=0;
        [self addChild:delayTimer];
        [delayTimer setPosition:ccp(self.position.x+self.contentSize.width/2, self.position.y+self.contentSize.height/2)];
        //include updates
        [NSTimer scheduledTimerWithTimeInterval:(1.0/100.0) target:self selector:@selector(updateTimer:) userInfo:nil repeats:TRUE];
        [self pauseSchedulerAndActions];
        
        scoreLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"avenir24.fnt"];
        scoreLabel.anchorPoint = ccp(0,0.5);
        
        [scoreLabel setScale:3.0f];
        [scoreLabel setPosition:ccp(self.position.x+self.contentSize.width/4, self.position.y+self.contentSize.height/2)];
        [self addChild:scoreLabel];
        fireDelayInitial=53;
        
    }
    return self;
}

-(void)pressed{
    if(fireDelayTimer<=0){
        angleOfSpawn = fmodf([[[GameMechanics sharedGameMechanics] gameScene]  getChildByTag:1].rotation, 360);
       if((angleOfSpawn <=-22.5 && angleOfSpawn >= -157.5)||(angleOfSpawn >202.5 && angleOfSpawn < 337.5)){
           if(self.cost<=[[GameMechanics sharedGameMechanics]game].energy){
               [[[[GameMechanics sharedGameMechanics]gameScene]energy]deductEnergyBy:self.cost];
               [[[[GameMechanics sharedGameMechanics]gameScene]ship]fireSeedForMonster:self.nameOfMonster];
                fireDelayTimer=fireDelayInitial;
                delayTimer.percentage=100;
//                float newPercentage=((float)(fireDelayTimer-1)/(float)fireDelayInitial)*100;
                [delayTimer runAction:[CCProgressFromTo actionWithDuration:.53f from:delayTimer.percentage to:0]];
//                [self resumeSchedulerAndActions];
            }
        }
    }
    
}

-(void)start{
    [self resumeSchedulerAndActions];
}

-(void )pause{
    [self pauseSchedulerAndActions];
}
-(void)updateDelay{
    self.cost= [[GameMechanics sharedGameMechanics] spawnCostForPlayerMonsterType:self.nameOfMonster];
    fireDelayTimer=0;
    delayTimer.percentage=0;
    scoreLabel.string = [NSString stringWithFormat:@"%d",self.cost];
}

-(void) updateTimer:(NSTimer *) theTimer {
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        if(fireDelayTimer>0){
            fireDelayTimer--;

    }
    }
}



@end
