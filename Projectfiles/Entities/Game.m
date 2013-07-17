//
//  Game.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "Game.h"
#import "MonsterCache.h"

@implementation Game

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.playerMonsterList=[[NSArray alloc]initWithObjects:@"Orange",@"Apple",@"Strawberry",@"Cherry",@"Mango",@"Banana",@"Coconut",@"Grape",@"Pineapple",@"Watermelon",nil];
        NSString *stats = [[NSBundle mainBundle] pathForResource:@"GameInfo" ofType:@"plist"];
        self.gameInfo=[NSDictionary dictionaryWithContentsOfFile:stats];
        NSString *gameItems = [[NSBundle mainBundle] pathForResource:@"ItemDescription" ofType:@"plist"];
        self.gameItemInfo=[NSDictionary dictionaryWithContentsOfFile:gameItems];
        self.timeInSecInit=600;
        self.timeForCrazyMode=120;
        self.endLevelBonusScore=100;
        self.endLevelBonusGold=100;
        self.difficulty=HARD;
    }
    
    return self;
}

-(BOOL)loadGame{
    //    self.difficulty = [[NSUserDefaults standardUserDefaults] objectForKey:@"Difficulty"];
    self.gold = [[NSUserDefaults standardUserDefaults] objectForKey:@"Gold"];
    self.score = [[NSUserDefaults standardUserDefaults] objectForKey:@"Score"];
    self.levelsOfEverything=[[NSUserDefaults standardUserDefaults] objectForKey:@"levelsOfEverything"];
    self.seedsUsed=[[NSUserDefaults standardUserDefaults] objectForKey:@"Seeds Used"];
    self.totalEnemiesMonsterKilled=[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Enemies Killed"];
    self.totalPlayerMonsterKilled=[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Player Killed"];
    self.totalGold=[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Gold"];
    
    self.totalEnemiesMonsterKilled=[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Enemies Killed"];
    self.totalPlayerMonsterKilled=[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Player Killed"];
    self.highScoreForGold=[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Gold"];
    self.highScoreForLevel=[[NSUserDefaults standardUserDefaults] objectForKey:@"Highest Score For Level"];
    self.totalTimePlayed=[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Time Played"];
    self.totalGold=[[NSUserDefaults standardUserDefaults] objectForKey:@"Highest Gold For Level"];
    
    if(self.levelsOfEverything == nil){
        return FALSE;
    }else{
        [self reset];
        return TRUE;
    }
}

-(void)saveGame{
    [[NSUserDefaults standardUserDefaults] setObject: self.levelsOfEverything forKey:@"levelsOfEverything"];
    //    [[NSUserDefaults standardUserDefaults] setInteger: self.difficulty forKey:@"Difficulty"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.gold forKey:@"Gold"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.score forKey:@"Score"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.seedsUsed forKey:@"Seeds Used"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.totalEnemiesMonsterKilled forKey:@"Total Enemies Killed"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.totalPlayerMonsterKilled forKey:@"Total Player Killed"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.totalGold forKey:@"Total Gold"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.totalEnemiesMonsterKilled forKey:@"Total Enemies Killed"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.totalPlayerMonsterKilled forKey:@"Total Player Killed"];
    [[NSUserDefaults standardUserDefaults] setInteger:  self.totalGold forKey:@"Total Gold"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.totalTimePlayed forKey:@"Total Time Played"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.highScoreForGold forKey:@"Highest Score For Level"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.highScoreForLevel forKey:@"Highest Gold For Level"];
}

-(void)newGame{
    NSString *newGame = [[NSBundle mainBundle] pathForResource:@"NewGame_Levels" ofType:@"plist"];
    self.levelsOfEverything=[NSMutableDictionary dictionaryWithContentsOfFile:newGame];
    
    self.gold=0;
    self.score=0;
    self.totalEnemiesMonsterKilled=0;
    self.totalPlayerMonsterKilled=0;
    self.highScoreForGold=0;
    self.highScoreForLevel=0;
    self.totalTimePlayed=0;
    self.totalGold=0;
    
    //    [[NSUserDefaults standardUserDefaults] setInteger: self.difficulty forKey:@"Difficulty"];
    self.seedsUsed=[[NSMutableArray alloc]initWithCapacity:MAXSPAWNBUTTONS];
    [self.seedsUsed addObject:@"Orange"];
    for(int i=1;i<MAXSPAWNBUTTONS;i++){
        [self.seedsUsed addObject:@""];
    }
    [[NSUserDefaults standardUserDefaults] setObject: self.levelsOfEverything forKey:@"levelsOfEverything"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Score"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Gold"];
    [[NSUserDefaults standardUserDefaults] setInteger: self.seedsUsed forKey:@"Seeds Used"];
    //for stats
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Total Enemies Killed"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Total Player Killed"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Total Gold"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Total Time Played"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Highest Score For Level"];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey:@"Highest Gold For Level"];
    [self reset];
}

-(void)reset{
    //time reset
    self.timeInSec=self.timeInSecInit;
    //energy reset
    self.energy=0;
    
    //get energy regeneration for this level
    int level=[[self.levelsOfEverything  objectForKey:@"Energy Regeneration"]integerValue];
    self.energyPerSec=[[[self.gameInfo objectForKey:@"Energy Regeneration"] objectAtIndex:level]integerValue];
    //get max energy
    level=[[self.levelsOfEverything objectForKey:@"Energy Max"] integerValue];
    self.energyMax=[[[self.gameInfo  objectForKey:@"Energy Max"] objectAtIndex:level] integerValue];
    
    //level gold reset
    self.goldForLevel=0;
    level=[[self.levelsOfEverything objectForKey:@"Gold Bonus"] integerValue];
    self.goldBonusPerMonster=[[[self.gameInfo objectForKey:@"Gold Bonus"]  objectAtIndex:level] integerValue];
    
    //enemiesKilled reset
    self.enemiesMonsterKilled=0;
    self.playerMonsterKilled=0;
    
    //set max level
    self.maxGamePlayLevel=[[self.levelsOfEverything objectForKey:@"Game Levels"] integerValue];
    self.gameplayLevel=self.maxGamePlayLevel;
    
}

-(void)subtractGoldby:(NSInteger) cost{
    self.gold-=cost;
}

-(void)increaseLevel:(NSString*) category{
    int newlevel=[[self.levelsOfEverything objectForKey:category] integerValue];
    newlevel++;
    [self.levelsOfEverything  setObject:[NSNumber numberWithInt:newlevel] forKey:category];
    [self reset];
}

-(void)beatLevel{
    int multiplier=0;
    //if new level muliplier is 1 else everything is halved
    if(self.gameplayLevel == self.maxGamePlayLevel){
        multiplier=1;
    }else{
        multiplier=.5;
    }
    
    //    if(self.difficulty==HARD){
    //        multiplier=multiplier*2;
    //    }
    
    self.goldForLevel=self.goldForLevel*multiplier;
    self.scorePerLevel=self.scorePerLevel*multiplier;
    //if player kills more enemy than losing their own get endlevelbonus gold
    if(self.enemiesMonsterKilled>self.playerMonsterKilled){
        self.goldForLevel=+self.endLevelBonusGold*multiplier;
        self.scorePerLevel=+self.endLevelBonusScore*multiplier;
    }
    
    //if the enemy barn is destroyed then get bonus
    if([[MonsterButtonCache sharedMonsterButtonCache] enemyBarn].hitPoints <= 0){
        self.goldForLevel=+self.endLevelBonusGold*multiplier;
        self.scorePerLevel=+self.endLevelBonusScore*multiplier;
    }
    
    
    //check if it is the high score for gold and score
    if(self.goldForLevel>self.highScoreForGold){
        self.highScoreForGold=self.goldForLevel;
    }
    
    if(self.goldForLevel>self.highScoreForGold){
        self.highScoreForGold=self.goldForLevel;
    }
    //total the amount of enemy and player killed
    self.totalEnemiesMonsterKilled=+self.enemiesMonsterKilled;
    self.totalPlayerMonsterKilled=+self.playerMonsterKilled;
    //total time played
    self.totalTimePlayed=+(self.timeInSecInit-self.timeInSec);
    
    //add this levels gold gain to gold
    self.gold=+self.goldForLevel;
    //add this levels gold gain to total gold gained
    self.totalGold=+self.goldForLevel;
    //add this levels score to total score
    self.score=+self.scorePerLevel;
    
    //increase max level if player is playing max level
    if(self.gameplayLevel == self.maxGamePlayLevel){
        [self increaseLevel:@"Game Levels"];
    }
}

-(void)loseLevel{
    //total the amount of enemy and player killed
    self.totalEnemiesMonsterKilled=+self.enemiesMonsterKilled;
    self.totalPlayerMonsterKilled=+self.playerMonsterKilled;
    //total time played
    self.totalTimePlayed=+(self.timeInSecInit-self.timeInSec);
    
    if(self.gameplayLevel>5){
        //if you lose you lose a quater of your gold
        [self subtractGoldby:self.gold/4];
    }
}


@end
