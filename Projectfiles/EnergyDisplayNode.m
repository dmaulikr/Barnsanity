//
//  EnergyDisplayNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/5/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "EnergyDisplayNode.h"
#import "GameMechanics.h"
@implementation EnergyDisplayNode

- (id)initWithfontFile:(NSString *)fontFile
{
    self = [super init];
    
    if (self)
    {
        self.stringFormat = @"Seeds: %d/%d";
        energyLabel = [CCLabelBMFont labelWithString:@"" fntFile:fontFile];
        energyLabel.anchorPoint = ccp(0,0.5);
        [energyLabel setColor:ccc3(0, 0, 0)];
            [NSTimer scheduledTimerWithTimeInterval:.9 target:self selector:@selector(updateTimer:) userInfo:nil repeats:TRUE];
        [self addChild:energyLabel];
    }
    
    return self;
}

-(void)resetEnergy:(int) initialEnergyMax increasedAt:(int)energyPerSec
{
    self.energyPerSec=energyPerSec;
    self.energyMax=initialEnergyMax;
    self.run=TRUE;
    [self setEnergy:5];
}

- (void)setEnergy:(int)energy
{
    _energy = energy;
    [[GameMechanics sharedGameMechanics] game].energy=energy;
    energyLabel.string = [NSString stringWithFormat:_stringFormat, energy,self.energyMax];
}


-(void) updateTimer:(NSTimer *) theTimer{
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning && self.run)
    {
        if(_energy+_energyPerSec< _energyMax){
            [self setEnergy:(_energy+_energyPerSec)];
        }else{
            [self setEnergy:(_energyMax)];
        }
    }
}
@end
