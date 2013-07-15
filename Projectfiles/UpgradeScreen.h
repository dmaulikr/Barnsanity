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
    
    CCMenuItemSprite *previousPage;
    CCMenuItemSprite *nextPage;
     CCMenu *page;
    
    ScoreboardEntryNode *goldDisplay;
    
    CCMenuItemFont *upgrade;
    CCMenuItemFont *back;
    
    ItemNode *selectedItem;
    
    NSMutableArray *upgradePages;
    StoreItemPage *currentPage;
    int currentPageNumber;
    
    ItemDescriptionDisplayNode *desciption;
    int countOfDescription;
    
}

- (id)initWithGame;
-(void)present;
-(void)showSelectedItem:(ItemNode*)item;
@end
