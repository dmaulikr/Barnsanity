//
//  SeedScreen.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "SeedScreen.h"
#import "GameMechanics.h"
#import "STYLES.h"
#import "UpgradeScreen.h"
#import "MonsterItemNode.h"

@implementation SeedScreen


-(void)setUpitems{
    NSString *previous=nil;
    NSArray *playerMonsterList=[[NSArray alloc]initWithObjects:@"Orange",@"Apple",@"Strawberry",@"Cherry",@"Mango",@"Banana",@"Coconut",@"Grape",@"Pineapple",@"Watermelon",nil];
    for(NSInteger i =0; i<  playerMonsterList.count;i++){
        
        [itemNodes addObject:[[MonsterItemNode alloc] initWithImageFile:@"basicbarrell.png" unitName:playerMonsterList[i] unlockingItemName:previous withRequiredLevel:0]];
        previous=playerMonsterList[i];
    }
    int row=0;
    int col=0;
    CCSprite *tempImage=[[CCSprite alloc] initWithFile:@"button_topdown-button.png"];
    for(int i=0;i<itemNodes.count;i++){

       CCMenuItemSprite *temp=[CCMenuItemSprite itemWithNormalSprite:itemNodes[i] selectedSprite:nil block:^(id sender) {
           [self selectItem:itemNodes[i]];
        }];
        temp.position=ccp(-130+col*(50+40),80-row*(50+10));
        [itemButtons addObject:temp];
            col++;
        if(col%4 ==0){
            row++;
            col=0;
        }
    }
}

@end
