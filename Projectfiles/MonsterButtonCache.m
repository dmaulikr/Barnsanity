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
        NSArray *monsterlist=[[GameMechanics sharedGameMechanics]game].playerMonsterList;
        for(int i=0;i<monsterlist.count;i++){
            SpawnMonsterButton *temp=[[SpawnMonsterButton alloc] initWithEntityImage:@"button_topdown-button.png" andMonster:monsterlist[i]];
            //            [temp pause];
            [monsterButton setObject:temp  forKey:monsterlist[i]];
        }
        buttonInUse=[[NSMutableArray alloc]initWithCapacity:MAXSPAWNBUTTONS];
    }
    
	return self;
}

-(void)placeButton{
    int row=-1;
    int col=-1;
    for(int i =0;i<MAXSPAWNBUTTONS;i++){
        if(![buttonInUse[i] isEqual:@""]){
            SpawnMonsterButton *button=[monsterButton objectForKey:buttonInUse[i]];
            //    [button start];
            [self addChild:button z:MAX_INT-1 tag:i];
            CGSize screenSize = [[CCDirector sharedDirector] winSize];
            if(i%2==0){
                row++;
                col=0;
            }else{
                col++;
            }
            button.position=ccp(screenSize.width-button.contentSize.width/5-(col * 75)-15,screenSize.height-button.contentSize.height/4-(row * 75)-10);
        }
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
        //        [monsterTypeClass pause];
    }
    [self loadButtons];
    
}

-(void)loadButtons{
    [self removeAllChildrenWithCleanup:TRUE];
    //load the buttons to be used that is saved in game class
    NSMutableArray *buttonSlot=[[GameMechanics sharedGameMechanics]game].seedsUsed;
    for(int i=0;i<MAXSPAWNBUTTONS;i++){
        buttonInUse[i]=buttonSlot[i];
    }
    [self placeButton];
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
