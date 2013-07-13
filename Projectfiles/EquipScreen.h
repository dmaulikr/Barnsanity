//
//  EquipScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
#import "WeaponNode.h"



@interface EquipScreen : CCLayer
{
CCBackgroundColorNode *backgroundNode;
CCMenu *menu;
CCMenuItemFont *equip;
CCMenuItemFont *unequip;
CCMenuItemFont *back;

    
    WeaponNode *selectedItem;

    NSMutableArray *weaponSlot;
    
    CCMenu *weapon;
    
    NSMutableArray *itemNodes;
    NSMutableArray *itemButtons;

}

- (id)initWithGame;
-(void)present;
-(void)showDescriptionOfSelectedItem:(WeaponNode*)item;
@end
