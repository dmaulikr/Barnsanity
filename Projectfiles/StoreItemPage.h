//
//  StoreItemPage.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/12/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
#import "ItemNode.h"


@interface StoreItemPage : CCLayer
{
    CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    
    //the item node that was selected
    ItemNode *selectedItem;
    //array of all the itemnodes
    NSMutableArray *itemNodes;
    //array of all the buttons made from the itemnodes
    NSMutableArray *itemButtons;
    
}

- (id)initWithGame;
-(void)present;
-(BOOL)upgradeSelectedItem;
-(void)selectItem:(ItemNode *)itemSelected;
-(void)removePage;
@end
