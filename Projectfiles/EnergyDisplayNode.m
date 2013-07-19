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
        self.stringFormat = @"Energy: %d/%d";
        energyLabel = [CCLabelBMFont labelWithString:@"" fntFile:fontFile];
        energyLabel.anchorPoint = ccp(0,0.5);
        [energyLabel setColor:ccc3(255, 255, 255)];
        [self addChild:energyLabel];
        [NSTimer scheduledTimerWithTimeInterval:.75f target:self selector:@selector(updateTimer:) userInfo:nil repeats:TRUE];
    }
    
    return self;
}

-(void)resetEnergy:(int) initialEnergyMax increasedAt:(int)energyPerSec
{
    self.energyPerSec=energyPerSec;
    self.energyMax=initialEnergyMax;
    [self setEnergy:0];
}

- (void)setEnergy:(int)energy
{
    _energy = energy;
    [[GameMechanics sharedGameMechanics] game].energy=energy;
    energyLabel.string = [NSString stringWithFormat:_stringFormat, energy,self.energyMax];
}

-(void) updateTimer:(NSTimer *) theTimer{
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        if(_energy+_energyPerSec< _energyMax){
            [self setEnergy:(_energy+_energyPerSec)];
        }else{
            [self setEnergy:(_energyMax)];
        }
    }
}
@end
