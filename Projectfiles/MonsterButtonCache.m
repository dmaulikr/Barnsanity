//
//  MonsterButtonCache.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"
#import "GameMechanics.h"

@implementation MonsterButtonCache

+ (id)sharedMonsterButtonCache
{
    static dispatch_once_t once;
    static id sharedInstance;
    /*  Uses GCD (Grand Central Dispatch) to restrict this piece of code to only be executed once
     This code doesn't need to be touched by the game developer.
     */
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(id) cache
{
	id cache = [[self alloc] init];
	return cache;
}

- (void)dealloc
{
    /*
     When our object is removed, we need to unregister from all notifications.
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id) init
{
	if ((self = [super init]))
	{
        //a dictionary to hold all the instance of the buttons
        monsterButton = [[NSMutableDictionary alloc] init];
        [monsterButton setObject: [[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:@"Orange"] forKey:@"Orange"];
        [monsterButton setObject: [[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:@"Apple"] forKey:@"Apple"];
        [monsterButton setObject: [[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:@"Strawberry"]forKey:@"Strawberry"];
        [monsterButton setObject:[[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:@"Coconut"] forKey:@"Coconut"];
        [monsterButton setObject: [[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:@"Grape"] forKey:@"Grape"];
        [monsterButton setObject: [[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:@"Pineapple"] forKey:@"Pineapple"];
        [monsterButton setObject: [[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:@"Watermelon"] forKey:@"Watermelon"];
        
    }
    
	return self;
}

-(void)placeButton:(NSString *)buttonClass atLocation:(int) place{
    //if the spot is open, place the button in the slot
    if(buttonClass == nil){
        [self removeChildByTag:place];
    }else{
        //if it is not open, remove the button that was there and place the new one there
    if([self getChildByTag:place] != nil){
        [self removeChildByTag:place];
    }
    SpawnMonsterButton *button=[monsterButton objectForKey:buttonClass];
    [self addChild:button z:MAX_INT-1 tag:place];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    button.position=ccp(screenSize.width-button.contentSize.width/5-15,screenSize.height-button.contentSize.height/4-(place * 60)-10);
    }
}

-(void)pressedButton:(int)place{
    //notify the button that it is pressed
    [(SpawnMonsterButton*)[self getChildByTag:place] pressed];
}

-(NSMutableArray*)returnButtonsUsed{
    NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:MAXSPAWNBUTTONS];
    for(int i=0;i<MAXSPAWNBUTTONS;i++){
        SpawnMonsterButton *temp=[self getChildByTag:i];
        //if the button slot is open, return @"", else return the name of the button's monster
        if(temp==nil){
            [returnArray addObject:@""];
        }else{
            [returnArray addObject:temp.nameOfMonster];
        }
    }

}

-(void)reset{
    //update the delay on all monster
    NSArray *monsterTypes = [monsterButton allValues];
    for (SpawnMonsterButton *monsterTypeClass in monsterTypes)
    {
        [monsterTypeClass updateDelay];
    }
    [self loadButtons];

}

-(void)loadButtons{
    //load the buttons to be used that is saved in game class
    NSMutableArray *buttonSlot=[[GameMechanics sharedGameMechanics]game].seedsUsed;
    for(int i=0;i<MAXSPAWNBUTTONS;i++){
        if(!([buttonSlot[i] isEqual:@""])){
            [self placeButton:buttonSlot[i] atLocation:i];
        }
    }
}
-(void)deleteButtons{
    for(int i=0;i<MAXSPAWNBUTTONS;i++){
        [self removeChildByTag:i];
    }
}

-(void)hideButtons{
    self.visible=FALSE;
}
-(void)showButtons{
     self.visible=TRUE;
}
-(SpawnMonsterButton*)getButton:(NSString *)monsterName{
    return [monsterButton objectForKey:monsterName];
}


@end
