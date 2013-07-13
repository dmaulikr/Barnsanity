//
//  PlayerBarnItemNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/12/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "PlayerBarnItemNode.h"

@implementation PlayerBarnItemNode
-(void)reset{
        self.ableToBuy=TRUE;
    //check level of item
    self.level=[[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything] objectForKey:@"Player Barn" ] objectForKey:nameOfItem] integerValue];
    if(unlockingItem!=nil){
        self.ableToBuy=TRUE;
        self.price=[[[[[[[[GameMechanics sharedGameMechanics] game] gameInfo] objectForKey:@"Upgrade Cost"]objectForKey:@"Player Barn"] objectForKey:nameOfItem] objectAtIndex:(self.level+1)]integerValue];
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
        [[[GameMechanics sharedGameMechanics]game] increasePlayerBarn:nameOfItem];
        return TRUE;
    }else{
        return FALSE;
    }
    
}
@end
