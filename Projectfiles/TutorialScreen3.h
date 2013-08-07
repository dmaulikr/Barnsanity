//
//  TutorialScreen3.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/25/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
#import "ItemNode.h"
#import "ScoreboardEntryNode.h"
#import "ItemDescriptionDisplayNode.h"
@interface TutorialScreen3 : CCLayer

{
    CCSprite *hereIsStore;
    CCSprite *hereIsSeedSection;
    CCSprite *finishPurchase;
    CCSprite *goShop;
     CCMenu *tutorialMenu;
    CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    
    //buttons to go between pages
    CCMenuItemSprite *previousPage;
    CCMenuItemSprite *nextPage;
    CCMenu *page;
    
    //to display the gold
    ScoreboardEntryNode *goldDisplay;
    //to display the gold
    ScoreboardEntryNode *seedSlots;
    
    //buttons for upgrade or go back
    CCMenuItemFont *upgrade;
    CCMenuItemFont *back;
    
    //buttons for equip
    CCMenuItemFont *equip;
    CCMenuItemFont *unequip;
    
    //the item nodes that was selected
    ItemNode *selectedItem;
    
    //weapon slot
    NSMutableArray *weaponSlot;
    //all the pages of items
    NSMutableArray *upgradePages;
    int currentPageNumber;
    NSMutableDictionary *currentItemNodes;
    
    //shows the description of the selected items
    ItemDescriptionDisplayNode *desciption;
    //number of description to show
    int itemPage;
    int countOfDescription;
    int countOfEquiped;
    BOOL tutorialOn;
    BOOL disableNext;
    BOOL disablePrevious;
    BOOL disableUpgrade;
    BOOL disableSelect;
    BOOL disableEquip;
    BOOL disableUnequip;
    BOOL disableBack;
    BOOL checkPoint1;
    BOOL checkPoint2;
    BOOL checkPoint3;
    BOOL checkPoint4;
    BOOL buttonPress;
    
}

- (id)initWithGame;
-(void)present;
-(void)showSelectedItem:(ItemNode*)item;
@end

