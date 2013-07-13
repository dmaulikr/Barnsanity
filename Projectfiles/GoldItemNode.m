//
//  GoldItemNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/12/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "GoldItemNode.h"

@implementation GoldItemNode
-(void)reset{
        self.ableToBuy=TRUE;
    //check level of item
    self.level=[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything] objectForKey:@"Gold Bonus" ]integerValue];
    if(unlockingItem!=nil){
        self.ableToBuy=TRUE;
        self.price=[[[[[[[GameMechanics sharedGameMechanics] game] gameInfo] objectForKey:@"Upgrade Cost"]objectForKey:@"Gold Bonus"] objectAtIndex:(self.level+1)]integerValue];
    }
    if(self.level>=0){
        self.bought=TRUE;
    }
}

-(BOOL)upgrade
{
    int totalGold=[[GameMechanics sharedGameMechanics]game].gold;
    if(totalGold >= self.price){
        [[[GameMechanics sharedGameMechanics]game] subtractGoldby:self.price];
        [[[GameMechanics sharedGameMechanics]game] increaseGoldBonus];
        return TRUE;
    }else{
        return FALSE;
    }
    
}
@end
