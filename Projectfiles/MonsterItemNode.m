//
//  MonsterItemNode.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/12/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "MonsterItemNode.h"

@implementation MonsterItemNode
-(void)reset{
    //check level of item
    self.level=[[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything] objectForKey:@"Player Monsters" ] objectForKey:nameOfItem] integerValue];
    if(unlockingItem!=nil){
        int levelOfRequiredItem=[[[[[[GameMechanics sharedGameMechanics] game] levelsOfEverything] objectForKey:@"Player Monsters" ] objectForKey:unlockingItem] integerValue];
        if(levelOfRequiredItem >= requiredLevel){
            self.ableToBuy=TRUE;
            self.price=[[[[[[[[GameMechanics sharedGameMechanics] game] gameInfo] objectForKey:@"Upgrade Cost"]objectForKey:@"Player Monsters"] objectForKey:nameOfItem] objectAtIndex:(self.level+1)]integerValue];
        }
    }else{
            self.ableToBuy=TRUE;
            self.price=[[[[[[[[GameMechanics sharedGameMechanics] game] gameInfo] objectForKey:@"Upgrade Cost"]objectForKey:@"Player Monsters"] objectForKey:nameOfItem] objectAtIndex:(self.level+1)]integerValue];
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
        [[[GameMechanics sharedGameMechanics]game] increasePlayerMonster:nameOfItem];
        return TRUE;
    }else{
        return FALSE;
    }
    
}
@end
