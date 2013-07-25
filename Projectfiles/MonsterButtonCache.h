//
//  MonsterButtonCache.h
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "CCNode.h"
#import "SpawnMonsterButton.h"
#define MAXSPAWNBUTTONS 4
@interface MonsterButtonCache : CCNode
{
    //a dictionary to hold the array of different monster units
    NSMutableDictionary* monsterButton;
}
//one instance
+ (id)sharedMonsterButtonCache;
//place the button on screen
-(void)placeButton:(Class)buttonClass atLocation:(int) place;
//notice the button that they are pressed
-(void)pressedButton:(int) place;
//return an array that holds the buttons used to save
-(NSMutableArray*)returnButtonsUsed;
-(void)loadButtons;
-(void)hideButtons;
-(void)showButtons;
-(void)deleteButtons;
-(SpawnMonsterButton*)getButton:(NSString *)monsterName;
@end
