//
//  ConfirmScreen.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/21/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCLayer.h"

@interface ConfirmScreen : CCLayer
{
    CCLabelTTF *startNewGame;
    CCLabelTTF *newGameWarning;
    CCLabelTTF *worldSize;
    CCLabelTTF *worldSizeWarning;
    CCMenu *confirmMenu;
    CCMenu *sizeMenu;
    //buttons for the menu
    CCMenuItemFont *confirm;
    CCMenuItemFont *back;
    CCMenuItemFont *wholeWorld;
    CCMenuItemFont *halfWorld;
    CCMenuItemFont *backWorld;
    
}
@end
