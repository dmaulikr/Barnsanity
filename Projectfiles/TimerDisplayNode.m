//
//  TimerDisplayNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/5/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "TimerDisplayNode.h"
@implementation TimerDisplayNode

 
 - (id)initWithfontFile:(NSString *)fontFile
{
    self = [super init];
    
    if (self)
    {
        self.stringFormat = @"Time: %02d:%02d";
        timeLabel = [CCLabelBMFont labelWithString:@"" fntFile:fontFile];
        timeLabel.anchorPoint = ccp(0,0.5);
        [timeLabel setColor:ccc3(0, 0, 0)];
        [self addChild:timeLabel];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:TRUE];

    }
    
    return self;
}

-(void)resetTimer:(int) initialTime
{
    [self setTime:initialTime];
}

 - (void)setTime:(int)time
{
    _timeInSec = time;
    [[[GameMechanics sharedGameMechanics]game] setTimeInSec:time];
    timeLabel.string = [NSString stringWithFormat:_stringFormat, time/60, time%60];
}

-(void) updateTimer:(NSTimer *) theTimer{
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        [self setTime:(_timeInSec+1)];
        //after 15 min increase spawn rate every 1 min
        if(_timeInSec>=900){
            if([[GameMechanics sharedGameMechanics]game].timeInSec%60 == 0){
                [[MonsterCache sharedMonsterCache]increaseSpawnRate];
            }
        }
    }
}
@end
