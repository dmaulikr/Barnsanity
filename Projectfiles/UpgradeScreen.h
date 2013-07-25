//
//  UpgradeScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/11/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
#import "ItemNode.h"
#import "SeedScreen.h"
#import "UtilityScreen.h"
#import "StoreItemPage.h"
#import "ScoreboardEntryNode.h"
#import "ItemDescriptionDisplayNode.h"

@interface UpgradeScreen : CCLayer
{
    CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    
    //buttons to go between pages
    CCMenuItemSprite *previousPage;
    CCMenuItemSprite *nextPage;
     CCMenu *page;
    
    //to display the gold
    ScoreboardEntryNode *goldDisplay;
    
    //buttons for upgrade or go back
    CCMenuItemFont *upgrade;
    CCMenuItemFont *back;
    
    //the item nodes that was selected
    ItemNode *selectedItem;
    
    //all the pages of items
    NSMutableArray *upgradePages;
    //the current page that is on the screen
    StoreItemPage *currentPage;
    int currentPageNumber;
    
    //shows the description of the selected items
    ItemDescriptionDisplayNode *desciption;
    //number of description to show
    int countOfDescription;
    
}

- (id)initWithGame;
-(void)present;
-(void)showSelectedItem:(ItemNode*)item;
@end
