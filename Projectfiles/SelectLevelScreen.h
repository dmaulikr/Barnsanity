//
//  SelectLevelScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/10/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"
#import "Game.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"

//@class SelectLevelScreen;
//@protocol SelectLevelScreenDelegate <NSObject>
//
//- (void)playButtonPressed:(SelectLevelScreen *)selectLevelScreen;
//
//@end

@interface SelectLevelScreen : CCLayer
{
    CCBackgroundColorNode *backgroundNode;
    CCMenu *menu;
    
    //level
    int levelToPlay;
    int maxLevelToPlay;
    
    //for level selection
    CCMenu *levelSelection;
    CCLabelBMFont *level;
    CCMenuItemSprite *decreaseLevel;
    CCMenuItemSprite *increaseLevel;
    
    //menu buttons
    CCMenuItemFont *playLevel;
    CCMenuItemFont *equip;
    CCMenuItemFont *mainMenu;
    CCMenuItemFont *store;
    CCMenuItemSprite *volumeControl;
}

//@property (nonatomic, weak) id<SelectLevelScreenDelegate> delegate;

- (id)initWithGame;
-(void)present;
@end
