//
//  MonsterButtonCache.m
//  Veggy_V_Fruit
//
//  Created by Danny on 7/8/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. All rights reserved.
//

#import "MonsterButtonCache.h"
#import "SpawnMonsterButton.h"
#import "OrangeMonsterButton.h"
#import "AppleMonsterButton.h"
#import "StrawberryMonsterButton.h"
#import "CherryMonsterButton.h"
#import "MangoMonsterButton.h"
#import "BananaMonsterButton.h"
#import "CoconutMonsterButton.h"
#import "GrapeMonsterButton.h"
#import "WatermelonMonsterButton.h"
#import "PineappleMonsterButton.h"
#import "Orange.h"
#import "Apple.h"
#import "Strawberry.h"
#import "Cherry.h"
#import "Mango.h"
#import "Banana.h"
#import "Coconut.h"
#import "Grape.h"
#import "Pineapple.h"
#import "Watermelon.h"

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
        monsterButton = [[NSMutableDictionary alloc] init];
        [monsterButton setObject: [[OrangeMonsterButton alloc] initWithEntityImage] forKey:@"Orange"];
        [monsterButton setObject: [[AppleMonsterButton alloc] initWithEntityImage] forKey:@"Apple"];
        [monsterButton setObject: [[StrawberryMonsterButton alloc] initWithEntityImage] forKey:@"Strawberry"];
        [monsterButton setObject: [[CherryMonsterButton alloc] initWithEntityImage] forKey:@"Cherry"];
        [monsterButton setObject: [[MangoMonsterButton alloc] initWithEntityImage] forKey:@"Mango"];
        [monsterButton setObject: [[BananaMonsterButton alloc] initWithEntityImage] forKey:@"Banana"];
        [monsterButton setObject: [[CoconutMonsterButton alloc] initWithEntityImage] forKey:@"Coconut"];
        [monsterButton setObject: [[GrapeMonsterButton alloc] initWithEntityImage] forKey:@"Grape"];
        [monsterButton setObject: [[PineappleMonsterButton alloc] initWithEntityImage] forKey:@"Pineapple"];
        [monsterButton setObject: [[WatermelonMonsterButton alloc] initWithEntityImage] forKey:@"Watermelon"];
        
    }
    
	return self;
}

-(void)placeButton:(NSString *)buttonClass atLocation:(int) place{
    if(buttonClass == nil){
        [self removeChildByTag:place];
    }else{
    if([self getChildByTag:place] != nil){
        [self removeChildByTag:place];
    }
    SpawnMonsterButton *button=[monsterButton objectForKey:buttonClass];
    [self addChild:button z:MAX_INT-1 tag:place];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    button.position=ccp(screenSize.width-button.contentSize.width/5-5,screenSize.height-button.contentSize.height/4-(place * 50));
    }
}

-(void)pressedButton:(int)place{
    [(SpawnMonsterButton*)[self getChildByTag:place] pressed];
}

-(NSMutableArray*)returnButtonsUsed{
    NSMutableArray *returnArray=[[NSMutableArray alloc]initWithCapacity:MAXSPAWNBUTTONS];
    for(int i=0;i<MAXSPAWNBUTTONS;i++){
        SpawnMonsterButton *temp=[self getChildByTag:i];
        if(temp==nil){
            [returnArray addObject:@""];
        }else{
            [returnArray addObject:temp.nameOfMonster];
        }
    }

}

-(void)reset{
    NSArray *monsterTypes = [monsterButton allValues];
    for (SpawnMonsterButton *monsterTypeClass in monsterTypes)
    {
        [monsterTypeClass updateDelay];
    }
    [self loadButtons];

}

-(void)loadButtons{
    NSMutableArray *buttonSlot=[[GameMechanics sharedGameMechanics]game].seedsUsed;
    for(int i=0;i<MAXSPAWNBUTTONS;i++){
        if(!([buttonSlot[i] isEqual:@""])){
            [self placeButton:buttonSlot[i] atLocation:i];
        }
    }
}



@end
