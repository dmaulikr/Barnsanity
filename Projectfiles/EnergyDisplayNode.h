//
//  EnergyDisplayNode.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/5/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCNode.h"

@interface EnergyDisplayNode : CCNode
{
    CCLabelBMFont *energyLabel;
}

- (id)initWithfontFile:(NSString *)fontFile;
-(void)resetEnergy:(int) initialEnergyMax increasedAt:(int)energyPerSec;
-(void)deductEnergyBy:(int)cost;
@property (nonatomic, assign) int energy;
@property (nonatomic, assign) int energyPerSec;
@property (nonatomic, assign) int energyMax;
@property (nonatomic, strong) NSString *stringFormat;
@property (nonatomic, assign) BOOL run;
@end
