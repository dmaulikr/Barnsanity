//
//  TimerDisplayNode.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/5/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCNode.h"
#import "GameMechanics.h"

@interface TimerDisplayNode : CCNode
{
    CCLabelBMFont *timeLabel;
}

- (id)initWithfontFile:(NSString *)fontFile;
-(void)resetTimer:(int) initialTime;
@property (nonatomic, assign) int timeInSec;
@property (nonatomic, strong) NSString *stringFormat;

@end
