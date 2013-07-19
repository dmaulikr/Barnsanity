//
//  ScareCrow.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/18/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "ScareCrow.h"

@implementation ScareCrow
- (id)initWithMonsterPicture{
    self = [super initWithFile:@"mailbox.png"];
    
    if (self)
    {
        nameOfMonster=@"ScareCrow";
        
        //get the radius of the world
        blink = [CCBlink actionWithDuration:.4f blinks:2];
        
        //for the prototype
        [self setScale:.5];
        [self reset];
        
        self.radiusToSpawnDelta=15;
    }
    
    return self;
}
@end
