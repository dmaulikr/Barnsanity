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
#import "ItemDescriptionDisplayNode.h"


@interface EquipScreen : CCLayer
{
CCBackgroundColorNode *backgroundNode;
CCMenu *menu;
CCMenuItemFont *equip;
CCMenuItemFont *unequip;
CCMenuItemFont *back;
    
    int countOfDescription;

    ItemDescriptionDisplayNode *desciption;
    WeaponNode *selectedItem;

    NSMutableArray *weaponSlot;
    
    CCMenu *weapon;
    
    NSMutableDictionary *itemNodes;
    NSMutableArray *itemButtons;
    
    int countOfEquiped;

}

- (id)initWithGame;
-(void)present;
-(void)showDescriptionOfSelectedItem:(WeaponNode*)item;
@end
