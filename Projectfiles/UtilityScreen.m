//
//  UtilityScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "UtilityScreen.h"


@implementation UtilityScreen
-(void)setUpitems{
    int row=0;
    int col=0;
    //itemnode for Player Barn
    NSArray *playerMonsterList=[[NSArray alloc]initWithObjects:@"Player Barn Damage",@"Player Barn Armor",@"Player Barn Health",@"Ship Damage",@"Ship Firerate",@"Ship AreaOfEffect Damage",@"Energy Max",@"Energy Regeneration",@"Gold Bonus",nil];
    for(NSInteger i =0; i<  playerMonsterList.count;i++){
        
        [itemNodes addObject:[[ItemNode alloc] initWithImageFile:@"basicbarrell.png" unitName:playerMonsterList[i]]];
        
        
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
