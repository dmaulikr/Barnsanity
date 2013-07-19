//
//  Tree.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/18/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "Tree.h"

@implementation Tree
- (id)initWithMonsterPicture{
    self = [super initWithFile:@"palmtree.png"];
    
    if (self)
    {
        nameOfMonster=@"Tree";
        
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
