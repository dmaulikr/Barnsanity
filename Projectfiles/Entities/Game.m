//
//  Game.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/14/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "Game.h"
#import "MonsterCache.h"
#import "GameMechanics.h"

@implementation Game

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //the name of all player's monster
        self.playerMonsterList=[[NSArray alloc]initWithObjects:@"Orange",@"Apple",@"Strawberry",@"Coconut",@"Grape",@"Pineapple",@"Watermelon",nil];
        //name of all enemy monsters
        self.enemyMonsterList=[[NSArray alloc]initWithObjects:@"Carrot",@"Broccoli",@"Corn",@"Tomato",@"Potato",@"PeaPod",@"Pumpkin",@"Beet",@"Asparagus",@"Artichokes",@"Eggplant",nil];
        //name of all util upgrades
        self.utilUpgradeList=[[NSArray alloc]initWithObjects:@"Player Barn Damage",@"Player Barn Armor",@"Player Barn Health",@"Ship Damage",@"Ship Firerate",@"Energy Max",@"Energy Regeneration",@"Gold Bonus",@"Bomb Damage",nil];
        //all information of the game
        NSString *stats = [[NSBundle mainBundle] pathForResource:@"GameInfo" ofType:@"plist"];
        self.gameInfo=[NSDictionary dictionaryWithContentsOfFile:stats];
        //all information of item for upgrades
        NSString *gameItems = [[NSBundle mainBundle] pathForResource:@"ItemDescription" ofType:@"plist"];
        self.gameItemInfo=[NSDictionary dictionaryWithContentsOfFile:gameItems];
//        //crazy mode begins at 2 min
//        self.timeForCrazyMode=120;
        self.gameSlot=1;
        self.seedsUsed=[[NSMutableArray alloc]initWithCapacity:MAXSPAWNBUTTONS];
        for(int i=0;i<MAXSPAWNBUTTONS;i++){
            [self.seedsUsed addObject:@""];
        }
    }
    
    return self;
}

-(void)loadGame{
    //if there is a game loaded in the slot
    BOOL loadGame =[[[NSUserDefaults standardUserDefaults] objectForKey:@"Game Exist"]boolValue];
    if(loadGame){
        //load all the data
    self.difficulty = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Difficulty"]integerValue];
    self.gold = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Gold"]integerValue];
    self.score = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Score"]integerValue];
    self.levelsOfEverything=[[NSUserDefaults standardUserDefaults] objectForKey:@"levelsOfEverything"];
    self.seedsUsed=[[NSUserDefaults standardUserDefaults] objectForKey:@"Seeds Used"];
//    self.totalEnemiesMonsterKilled=[[data objectForKey:@"Total Enemies Killed"]integerValue];
//    self.totalPlayerMonsterKilled=[[data objectForKey:@"Total Player Killed" ]integerValue];
    self.totalGold=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Gold"]integerValue];
    self.highScoreForGold=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Gold"]integerValue];
    self.highScoreForLevel=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Highest Score For Level"]integerValue];
    self.totalTimePlayed=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Total Time Played"]integerValue];
    self.totalGold=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Highest Gold For Level"]integerValue];
    
    [self reset];
    }else{
        [self newGame];
    }
}

-(void)saveGame{

    [[NSUserDefaults standardUserDefaults] setObject: self.levelsOfEverything forKey:@"levelsOfEverything"];
    //save all the data into the slot
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:self.difficulty] forKey:@"Difficulty"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.gold] forKey:@"Gold"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.score] forKey:@"Score"];
    [[NSUserDefaults standardUserDefaults] setObject:self.seedsUsed forKey:@"Seeds Used"];
//    [data setObject:[NSNumber numberWithInt:self.totalEnemiesMonsterKilled] forKey:@"Total Enemies Killed"];
//    [data setObject:[NSNumber numberWithInt:self.totalPlayerMonsterKilled] forKey:@"Total Player Killed"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.totalGold] forKey:@"Total Gold"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.totalTimePlayed] forKey:@"Total Time Played"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.highScoreForGold] forKey:@"Highest Score For Level"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.highScoreForLevel] forKey:@"Highest Gold For Level"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1]forKey:@"Game Exist"];
}

-(void)newGame{
    //load new game levels
    NSString *newGame = [[NSBundle mainBundle] pathForResource:@"NewGame_Levels" ofType:@"plist"];
    self.levelsOfEverything=[NSMutableDictionary dictionaryWithContentsOfFile:newGame];
    
    //set start info
    self.gold=2000;
    self.score=0;
    self.totalEnemiesMonsterKilled=0;
    self.totalPlayerMonsterKilled=0;
    self.highScoreForGold=0;
    self.highScoreForLevel=0;
    self.totalTimePlayed=0;
    self.totalGold=0;
    self.difficulty=EASY;
    
    //save the game into the slot
    for(int i=0;i<MAXSPAWNBUTTONS;i++){
        self.seedsUsed[i]=@"";
    }
    self.seedsUsed[0]=@"Orange";
    [[MonsterButtonCache sharedMonsterButtonCache]reset];
//    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:self.difficulty] forKey:@"Difficulty"];
//    [[NSUserDefaults standardUserDefaults] setObject: self.levelsOfEverything forKey:@"levelsOfEverything"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]forKey:@"Score"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"Gold"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.seedsUsed forKey:@"Seeds Used"];
//    //for stats
////    [data setObject:[NSNumber numberWithInt:0] forKey:@"Total Enemies Killed"];
////    [data setObject:[NSNumber numberWithInt:0] forKey:@"Total Player Killed"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"Total Gold"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"Total Time Played"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]forKey:@"Highest Score For Level"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]forKey:@"Highest Gold For Level"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1]forKey:@"Game Exist"];
    [self saveGame];
    [self reset];
}

-(void)reset{
    
    if(self.difficulty==EASY){
    //the initial time in sec for all levels
        self.timeInSecInit=540;
    }else{
        //the initial time in sec for all levels
        self.timeInSecInit=660;
    }
    //end level bonus for score
    self.endLevelBonusScore=50;
    //end level bonus for gold
    self.endLevelBonusGold=150;
    
    //time reset
    self.timeInSec=self.timeInSecInit;
    //energy reset
    self.energy=0;
    
    //get energy regeneration for this level
    int level=[[self.levelsOfEverything  objectForKey:@"Energy Regeneration"]integerValue];
    self.energyPerSec=[[[self.gameInfo objectForKey:@"Energy Regeneration"] objectAtIndex:level]integerValue];
    if(self.difficulty==HARD){
        self.energyPerSec=self.energyPerSec*2;
    }
    //get max energy
    level=[[self.levelsOfEverything objectForKey:@"Energy Max"] integerValue];
    self.energyMax=[[[self.gameInfo  objectForKey:@"Energy Max"] objectAtIndex:level] integerValue];
    
    //level gold reset
    self.goldForLevel=0;
    level=[[self.levelsOfEverything objectForKey:@"Gold Bonus"] integerValue];
    self.goldBonusPerMonster=[[[self.gameInfo objectForKey:@"Gold Bonus"]  objectAtIndex:level] integerValue];
    
//    //enemiesKilled reset
//    self.enemiesMonsterKilled=0;
//    self.playerMonsterKilled=0;
    
    //set max level
    self.maxGamePlayLevel=[[self.levelsOfEverything objectForKey:@"Game Levels"] integerValue];
    
}

-(void)subtractGoldby:(NSInteger) cost{
    self.gold=self.gold-cost;
}

-(void)increaseLevel:(NSString*) category{
    int newlevel=[[self.levelsOfEverything objectForKey:category] integerValue];
    newlevel++;
    [self.levelsOfEverything  setObject:[NSNumber numberWithInt:newlevel] forKey:category];
    [self reset];
}

-(void)beatLevel{
    float multiplier=0;
    //if new level muliplier is 1 else everything is halved
    if(self.gameplayLevel == self.maxGamePlayLevel){
        multiplier=1;
    }else{
        multiplier=.4;
    }
    
    if(self.difficulty==HARD){
        multiplier=multiplier*1.35;
    }
    
    self.goldForLevel=self.goldForLevel*multiplier;
    self.scorePerLevel=self.scorePerLevel*multiplier;
    
    //for beating level
    if(self.gameplayLevel == self.maxGamePlayLevel){
        self.goldForLevel=self.goldForLevel+self.endLevelBonusGold;
    }
    //if player kills more enemy than losing their own get endlevelbonus gold
    if(![[GameMechanics sharedGameMechanics]gameScene].ship.bombUsed && self.maxGamePlayLevel>=10){
        self.goldForLevel=self.goldForLevel+self.endLevelBonusGold*.75*multiplier;
        self.scorePerLevel=self.scorePerLevel+self.endLevelBonusScore*.75*multiplier;
    }
    
    //if the enemy barn is destroyed then get bonus
    if([[MonsterCache sharedMonsterCache] enemyBarn].hitPoints <= 0){
        self.goldForLevel=self.goldForLevel+self.endLevelBonusGold*multiplier;
        self.scorePerLevel=self.scorePerLevel+self.endLevelBonusScore*multiplier;
    }
    if(self.gameplayLevel == self.maxGamePlayLevel){
        self.scorePerLevel=self.scorePerLevel+self.timeInSec*.25;
    }
    
    //check if it is the high score for gold and score
    if(self.goldForLevel>self.highScoreForGold){
        self.highScoreForGold=self.goldForLevel;
    }
    
    if(self.goldForLevel>self.highScoreForGold){
        self.highScoreForGold=self.goldForLevel;
    }
//    //total the amount of enemy and player killed
//    self.totalEnemiesMonsterKilled=self.totalEnemiesMonsterKilled+self.enemiesMonsterKilled;
//    self.totalPlayerMonsterKilled=self.totalPlayerMonsterKilled+self.playerMonsterKilled;
    //total time played
    self.totalTimePlayed=self.totalTimePlayed+(self.timeInSecInit-self.timeInSec);
    
    //add this levels gold gain to gold
    self.gold=self.gold+self.goldForLevel;
    //add this levels gold gain to total gold gained
    self.totalGold=self.totalGold+self.goldForLevel;
    //add this levels score to total score
    self.score=self.score+self.scorePerLevel;
    
    //increase max level if player is playing max level
    if(self.gameplayLevel == self.maxGamePlayLevel){
        int newlevel=[[self.levelsOfEverything objectForKey:@"Game Levels"] integerValue];
        newlevel++;
        [self.levelsOfEverything  setObject:[NSNumber numberWithInt:newlevel] forKey:@"Game Levels"];
        self.maxGamePlayLevel=newlevel;
        if(newlevel==5){
            self.activateStoreTutorial=TRUE;
        }
        if(newlevel==10){
            [self increaseLevel:@"Bomb Damage"];
        }
        if(newlevel==20){
            self.difficulty=HARD;
        }
    }
    
    [self saveGame];
}

-(void)loseLevel{
    //total the amount of enemy and player killed
    self.totalEnemiesMonsterKilled=self.totalEnemiesMonsterKilled+self.enemiesMonsterKilled;
    self.totalPlayerMonsterKilled=self.totalPlayerMonsterKilled+self.playerMonsterKilled;
    //total time played
    self.totalTimePlayed=+(self.timeInSecInit-self.timeInSec);
    [self saveGame];
}


@end
