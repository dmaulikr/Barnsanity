//
//  Game.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "Game.h"


@implementation Game

- (id)init
{
    self = [super init];
    
    if (self)
    {

        NSString *stats = [[NSBundle mainBundle] pathForResource:@"GameInfo" ofType:@"plist"];
        self.gameInfo=[NSDictionary dictionaryWithContentsOfFile:stats];

        self.timeInSecInit=900;
    }
    
    return self;
}

-(BOOL)loadGame{
    self.gold = [[NSUserDefaults standardUserDefaults] objectForKey:@"Gold"];
    self.score = [[NSUserDefaults standardUserDefaults] objectForKey:@"Score"];
    self.levelsOfEverything=[[NSUserDefaults standardUserDefaults] objectForKey:@"levelsOfEverything"];
    if(self.levelsOfEverything == nil){
        return FALSE;
    }else{
        [self reset];
        return TRUE;
    }
}

-(void)saveGame{
    [[NSUserDefaults standardUserDefaults] setObject: self.levelsOfEverything forKey:@"levelsOfEverything"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.gold forKey:@"Gold"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.score forKey:@"Score"];
}

-(void)newGame{
    NSString *newGame = [[NSBundle mainBundle] pathForResource:@"NewGame_Levels" ofType:@"plist"];
    self.levelsOfEverything=[NSMutableDictionary dictionaryWithContentsOfFile:newGame];
    [[NSUserDefaults standardUserDefaults] setObject: self.levelsOfEverything forKey:@"levelsOfEverything"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Gold"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Score"];
    [self reset];
}

-(void)reset{
    //time reset
    self.timeInSec=self.timeInSecInit;
    //energy reset
    self.energy=0;
    
    int level=[[[self.levelsOfEverything objectForKey:@"Energy"] objectForKey:@"Energy Regeneration"]integerValue];
    self.energyPerSec=[[[[self.gameInfo objectForKey:@"Energy"] objectForKey:@"Energy Regeneration"] objectAtIndex:level]integerValue];
    
    level=[[[self.levelsOfEverything objectForKey:@"Energy"] objectForKey:@"Max Energy"] integerValue];
    self.energyMax=[[[[self.gameInfo objectForKey:@"Energy"] objectForKey:@"Max Energy"] objectAtIndex:level] integerValue];

    //level gold reset
    self.goldForLevel=0;
    level=[[self.levelsOfEverything objectForKey:@"Gold Bonus"] integerValue];
    self.goldBonusPerMonster=[[[self.gameInfo objectForKey:@"Gold Bonus"]  objectAtIndex:level] integerValue];
    
    //enemiesKilled reset
    self.enemiesKilled=0;
    
    //set max level
    self.maxGamePlayLevel=[[self.levelsOfEverything objectForKey:@"Game Levels"] integerValue];
    self.gameplayLevel=self.maxGamePlayLevel;
    
}

-(void)subtractGoldby:(NSInteger) cost{
    self.gold-=cost;
}

-(void)increasePlayerBarn:(NSString*) category{
    int level=[[[self.levelsOfEverything objectForKey:@"Player Barn"] objectForKey:category] integerValue];
    level++;
    [[self.levelsOfEverything objectForKey:@"Player Barn"] setObject:[NSNumber numberWithInt:level] forKey:category];
}
-(void)increaseEnergy:(NSString*) category{
    int level=[[[self.levelsOfEverything objectForKey:@"Energy"] objectForKey:category] integerValue];
    level++;
    [[self.levelsOfEverything objectForKey:@"Energy" ]setObject:[NSNumber numberWithInt:level] forKey:category];
}
-(void)increaseShip:(NSString*) category{
    int level=[[[self.levelsOfEverything objectForKey:@"Ship"] objectForKey:category] integerValue];
    level++;
    [[self.levelsOfEverything objectForKey:@"Ship" ] setObject:[NSNumber numberWithInt:level] forKey:category];
}
-(void)increasePlayerMonster:(NSString*) category{
    int level=[[[self.levelsOfEverything objectForKey:@"Player Monsters"] objectForKey:category] integerValue];
    level++;
    [[self.levelsOfEverything objectForKey:@"Player Monsters" ] setObject:[NSNumber numberWithInt:level] forKey:category];
}
-(void)increaseGoldBonus{
    int level=[[self.levelsOfEverything objectForKey:@"Gold Bonus"]  integerValue];
    level++;
    [[self.levelsOfEverything objectForKey:@"Gold Bonus" ] setObject:[NSNumber numberWithInt:level] forKey:@"Gold Bonus"];
}
-(void)increaseGameLevel{
    int level=[[self.levelsOfEverything objectForKey:@"Game Levels"] integerValue];
    level++;
    [self.levelsOfEverything  setObject:[NSNumber numberWithInt:level] forKey:@"Game Levels"] ;
    self.maxGamePlayLevel=[[self.levelsOfEverything objectForKey:@"Game Levels"] integerValue];
    self.gameplayLevel=self.maxGamePlayLevel;
}


@end
