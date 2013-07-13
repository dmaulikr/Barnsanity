//
//  UtilityScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "UtilityScreen.h"
#import "EnergyItemNode.h"
#import "GoldItemNode.h"
#import "ShipItemNode.h"
#import "PlayerBarnItemNode.h"

@implementation UtilityScreen
-(void)setUpitems{
    //itemnode for Player Barn
    NSArray *playerMonsterList=[[NSArray alloc]initWithObjects:@"Damage",@"Armor",@"Health",nil];
    for(NSInteger i =0; i<  playerMonsterList.count;i++){
        
        [itemNodes addObject:[[PlayerBarnItemNode alloc] initWithImageFile:@"basicbarrell.png" unitName:playerMonsterList[i] unlockingItemName:nil withRequiredLevel:0]];
    }
    
    //itemnode for ship
    playerMonsterList=[[NSArray alloc]initWithObjects:@"Damage",@"Firerate",@"AreaOfEffect Damage",nil];
    for(NSInteger i =0; i<  playerMonsterList.count;i++){
        
        [itemNodes addObject:[[ShipItemNode alloc] initWithImageFile:@"basicbarrell.png" unitName:playerMonsterList[i] unlockingItemName:nil withRequiredLevel:0]];
    }
    
    
    //itemnode for energy
    playerMonsterList=[[NSArray alloc]initWithObjects:@"Max Energy",@"Energy Regeneration",nil];
    for(NSInteger i =0; i<  playerMonsterList.count;i++){
        
        [itemNodes addObject:[[EnergyItemNode alloc] initWithImageFile:@"basicbarrell.png" unitName:playerMonsterList[i] unlockingItemName:nil withRequiredLevel:0]];
    }
    
    //itemnode for gold bonus
    [itemNodes addObject:[[GoldItemNode alloc] initWithImageFile:@"basicbarrell.png" unitName:@"Gold Bonus" unlockingItemName:nil withRequiredLevel:0]];
    
    
    int row=0;
    int col=0;
    CCSprite *tempImage=[[CCSprite alloc] initWithFile:@"button_topdown-button.png"];
    for(int i=0;i<itemNodes.count;i++){
        
        CCMenuItemSprite *temp=[CCMenuItemSprite itemWithNormalSprite:itemNodes[i] selectedSprite:nil block:^(id sender) {
            [self selectItem:itemNodes[i]];
        }];
        temp.position=ccp(-100+col*(50+40),80-row*(50+10));
        [itemButtons addObject:temp];
        col++;
        if(col%3 ==0){
            row++;
            col=0;
        }
    }
}
@end
