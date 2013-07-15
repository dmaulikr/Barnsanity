//
//  GameplayScene.m
//  _MGWU-SideScroller-Template_
//
//  Created by Benjamin Encz on 5/15/13.
//  Copyright (c) 2013 MakeGamesWithUs Inc. Free to use for all purposes.
//

#import "GameplayLayer.h"
#import "Game.h"
#import "GameMechanics.h"
#import "PopupProvider.h"
#import "CCControlButton.h"
#import "StyleManager.h"
#import "NotificationBox.h"
#import "CCTouchDelegateProtocol.h"

//Screnes
#import "PauseScreen.h"
#import "SelectLevelScreen.h"
#import "WinScreen.h"
#import "LoseScreen.h"
#import "UpgradeScreen.h"
#import "EquipScreen.h"
#import "MainMenuLayer.h"

//Caches
#import "MonsterCache.h"
#import "MonsterButtonCache.h"

//units
#import "World.h"
#import "Ship.h"

#import "Orange.h"
#import "Carrot.h"

static CGRect screenRect;

// defines how many update cycles run, before the missions get an update about the current game state
#define MISSION_UPDATE_FREQUENCY 10

@interface GameplayLayer()

/*
 called when pause button was pressed
 */
- (void)pauseButtonPressed;

@end



@implementation GameplayLayer

+ (id)scene
{
    CCScene *scene = [CCScene node];
    GameplayLayer* layer = [GameplayLayer node];
    
    // By default we want to show the main menu
    layer.showMainMenu = TRUE;
    
    [scene addChild:layer];
    return scene;
}

+ (id)noMenuScene
{
    CCScene *scene = [CCScene node];
    GameplayLayer* layer = [GameplayLayer node];
    
    // By default we want to show the main menu
    layer.showMainMenu = FALSE;
    
    [scene addChild:layer];
    return scene;
}

#pragma mark - Initialization

- (void)dealloc
{
    /*
     When our object is removed, we need to unregister from all notifications.
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.isTouchEnabled = YES;
        //get the rectangle that describes the edges of the screen
        screenSize = [[CCDirector sharedDirector] winSize];
        screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
        
        //        // preload particle effects
        //        // To preload the textures, play each effect once off-screen
        //        CCParticleSystem* system = [CCParticleSystemQuad particleWithFile:@"fx-explosion.plist"];
        //        system.positionType = kCCPositionTypeFree;
        //        system.autoRemoveOnFinish = YES;
        //        system.position = ccp(MAX_INT, MAX_INT);
        //        // adding it as child lets the particle effect play
        //        [self addChild:system];
        
        //set inital values
        rotationVelocity=0;
        touchingworld=false;
        shipFire=FALSE;
        
        //background image
        CCSprite *background=[[CCSprite alloc] initWithFile:@"sky_background_by_09shootingstar90-d4oq6xw.png"];
        [self addChild:background z:0];
        
        
        //create the ship object
        ship=[[Ship alloc] initWithMonsterPicture];
        ship.position=ccp(screenSize.width/2,screenSize.height-ship.contentSize.height/4);
        [self addChild:ship z:MAX_INT-1 tag:0];
        
        //set the world image
        World *planet=[World createEntity];
        self.radiusOfWorld=planet.contentSize.width/2;
        
        //create a node where the all mosnter sprites will rotate around
        centerOfRotation=[CCNode node];
        centerOfRotation.position= ccp(screenSize.width/2, -planet.contentSize.height/3);
        [self addChild:centerOfRotation z:1 tag:1];
        //include the planet into the rotation node
        [centerOfRotation addChild:planet z:1 tag:1];
        
        //create the game mechanic object
        [GameMechanics sharedGameMechanics];
        //include the node that creates and hold all monster object
        [centerOfRotation addChild:[MonsterCache sharedMonsterCache] z:2 tag:2];
        
        //node that contains all gameplay objects
        hudNode = [CCNode node];
        [self addChild:hudNode];
        
        //create node for monster button objects
        [hudNode addChild:[MonsterButtonCache sharedMonsterButtonCache]];
        
        // add scoreboard entry for points
        pointsDisplayNode = [[ScoreboardEntryNode alloc] initWithfontFile:@"avenir24.fnt"];
        pointsDisplayNode.position = ccp(10, screenSize.height - 50);
        pointsDisplayNode.scoreStringFormat = @"Gold: %d";
        [hudNode addChild:pointsDisplayNode z:MAX_INT-1];
        //include timer
        timer=[[TimerDisplayNode alloc] initWithfontFile:@"avenir24.fnt"];
        timer.position = ccp(10, screenSize.height - 30);
        [hudNode addChild:timer z:MAX_INT-1];
        //include energy
        energy=[[EnergyDisplayNode alloc] initWithfontFile:@"avenir24.fnt"];
        energy.position = ccp(10, screenSize.height - 40);
        [hudNode addChild:energy z:MAX_INT-1];
        // set up pause button
        CCSprite *pauseButton = [CCSprite spriteWithFile:@"pause.png"];
        CCSprite *pauseButtonPressed = [CCSprite spriteWithFile:@"pause-pressed.png"];
        pauseButtonMenuItem = [CCMenuItemSprite itemWithNormalSprite:pauseButton selectedSprite:pauseButtonPressed target:self selector:@selector(pauseButtonPressed)];
        pauseButtonMenu = [CCMenu menuWithItems:pauseButtonMenuItem, nil];
        pauseButtonMenu.position = ccp(20, screenSize.height - 70);
        [hudNode addChild:pauseButtonMenu];
        
        game = [[Game alloc] init];
        [[GameMechanics sharedGameMechanics] setGameScene:self];
        [[GameMechanics sharedGameMechanics] setGame:game];
        
        [self scheduleUpdate];
        
        /**
         A Notification can be used to broadcast an information to all objects of a game, that are interested in it.
         Here we sign up for the 'GamePaused' and 'GameResumed' information, that is broadcasted by the GameMechanics class. Whenever the game pauses or resumes, we get informed and can react accordingly.
         **/
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamePaused) name:@"GamePaused" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameResumed) name:@"GameResumed" object:nil];
    }
    
    return self;
}

- (void)gamePaused
{
    [self pauseSchedulerAndActions];
}

- (void)gameResumed
{
    [self resumeSchedulerAndActions];
}

#pragma mark - Reset Game

- (void)startGame
{
    [self resetGame];
    [self enableGamePlayButtons];
    [self showHUD];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateRunning];
}

- (void)resetGame
{
    //reset all spawn rates and spawn cost for monsters
    [[GameMechanics sharedGameMechanics] resetGame];
    //reset game info for this level
    [game reset];
    //reset barn
    [[MonsterCache sharedMonsterCache]spawnBarn];
    //reset all monsters
    [[MonsterCache sharedMonsterCache]reset];
    //reset timer
    [timer resetTimer:game.timeInSec];
    //reset the ship
    [ship reset];
    //reset energy info
    [energy resetEnergy:game.energyMax increasedAt:game.energyPerSec];
    //reset the monster buttons and their delays
    [[MonsterButtonCache sharedMonsterButtonCache] reset];
    /* setup initial values */
    centerOfRotation.rotation=0;
//    
//    Orange *test1=[[Orange alloc]initWithMonsterPicture];
//    Carrot *test2=[[Carrot alloc]initWithMonsterPicture];
//    [centerOfRotation addChild:test1 z:MAX_INT];
//    [centerOfRotation addChild:test2 z:MAX_INT];
//    [test1 spawnAt:M_PI+1];
//    [test2 spawnAt:M_PI];
//    
//    Orange *test12=[[Orange alloc]initWithMonsterPicture];
//    Carrot *test22=[[Carrot alloc]initWithMonsterPicture];
//    [centerOfRotation addChild:test12 z:MAX_INT];
//    [centerOfRotation addChild:test22 z:MAX_INT];
//    [test12 spawnAt:-M_PI];
//    [test22 spawnAt:-M_PI+1];
}


- (void) update:(ccTime)delta
{
    
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        [self updateRunning:delta];
        
    }
}

- (void)updateRunning:(ccTime)delta
{
    //update
    pointsDisplayNode.score=game.goldForLevel;
    [energy setEnergy:game.energy];
    
    if(game.difficulty==EASY){
        if(centerOfRotation.rotation>=-200 && centerOfRotation.rotation<=200 ){
            //for rotation deceleration
            if(rotationVelocity!=0.0){
                centerOfRotation.rotation+=rotationVelocity;
                if(rotationVelocity>0){
                    rotationVelocity-=1;
                    if(rotationVelocity<1){
                        rotationVelocity=0;
                    }
                }else{
                    rotationVelocity+=1;
                    if(rotationVelocity>-1){
                        rotationVelocity=0;
                    }
                }
            }
        }
    }else{
        //for rotation deceleration
        if(rotationVelocity!=0.0){
            centerOfRotation.rotation+=rotationVelocity;
            if(rotationVelocity>0){
                rotationVelocity-=1;
                if(rotationVelocity<1){
                    rotationVelocity=0;
                }
            }else{
                rotationVelocity+=1;
                if(rotationVelocity>-1){
                    rotationVelocity=0;
                }
            }
        }
        
        //if continously fire bullets from the ship
        if(shipFire){
            [ship fireBullet];
        }
        
        //make rotation stay between -360 to 360
        centerOfRotation.rotation=fmodf(centerOfRotation.rotation, 360);
        
        //if player barn's hitpoint is 0 or less OR time runs out go to lose screen
        if ([[MonsterCache sharedMonsterCache] playerBarn].hitPoints <= 0)
        {
            [self goToLoseScreen];
        }else if ([[MonsterCache sharedMonsterCache] enemyBarn].hitPoints <= 0 || (game.timeInSec <=0))
        {
            // if enemy barn's hit point is 0 or less go to win screen
            [self goToWinScreen];
        }
    }
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    BOOL touchSpawnButtons=FALSE;
    //stop the rotation
    rotationVelocity=0;
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    previousTouch=touchPoint;
    //get the center of the world
    CGPoint circleCenter=centerOfRotation.position;
    //have the coordinate system to align
    touchPoint.y= -touchPoint.y+screenSize.height;
    
    //if the distance between the touch and the center of the circle is less than the radius then this is true
    if(ccpLengthSQ(ccpSub(circleCenter,touchPoint)) <([centerOfRotation getChildByTag:1].contentSize.height/2*[centerOfRotation getChildByTag:1 ].contentSize.height/2) )
    {
        touchingworld=true;
    }else{
        for(int i =0; i<MAXSPAWNBUTTONS;i++){
            if(CGRectContainsPoint([[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:i ].boundingBox, touchPoint)){
                touchingworld=false;
                [[MonsterButtonCache sharedMonsterButtonCache] pressedButton:i];
                touchSpawnButtons=TRUE;
            }
        }
        
        
        if(!touchSpawnButtons){
            touchingworld=false;
            shipFire=TRUE;
            
        }
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(touchingworld){
        UITouch *touch = [[event allTouches] anyObject];
        currentTouch = [touch locationInView: [touch view]];
        
        //calculate the angle for the first(previous) touch location
        CGPoint firstVector = ccpSub( previousTouch, centerOfRotation.position);
        CGFloat firstRotateAngle = -ccpToAngle(firstVector);
        CGFloat previousAngle = CC_RADIANS_TO_DEGREES(firstRotateAngle);
        
        //calculate the curent touch location
        CGPoint vector = ccpSub(currentTouch, centerOfRotation.position);
        CGFloat rotateAngle = -ccpToAngle(vector);
        CGFloat currentAngle = CC_RADIANS_TO_DEGREES(rotateAngle);
        //calculate delta angle
        deltaRotation=(currentAngle - previousAngle);
        //rotate the world
        if(game.difficulty==EASY){
            if(centerOfRotation.rotation>=-200 && centerOfRotation.rotation<=200 ){
                centerOfRotation.rotation+=2.15*deltaRotation;
            }
        }else{
            centerOfRotation.rotation+=2.15*deltaRotation;
        }
        
        previousTouch=currentTouch;
    }
    
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    currentTouch = [touch locationInView: [touch view]];
    
    if(touchingworld){
        //calculate the angle for the first(previous) touch location
        CGPoint firstVector = ccpSub( previousTouch, centerOfRotation.position);
        CGFloat firstRotateAngle = -ccpToAngle(firstVector);
        CGFloat previousAngle = CC_RADIANS_TO_DEGREES(firstRotateAngle);
        //calculate the curent touch location
        CGPoint vector = ccpSub(currentTouch, centerOfRotation.position);
        CGFloat rotateAngle = -ccpToAngle(vector);
        CGFloat currentAngle = CC_RADIANS_TO_DEGREES(rotateAngle);
        //calculate the velocity for which the world will spin after the touch ends
        rotationVelocity=3*(currentAngle - previousAngle);
        
        touchingworld = false;
    }else if(shipFire){
        shipFire=FALSE;
    }
}


#pragma mark - Scene Lifecycle

- (void)onEnterTransitionDidFinish
{
    if (self.showMainMenu)
    {
        // add main menu
        [self goToMainMenu];
        
    } else
    {
        // start game directly
        [self showHUD];
        [self startGame];
    }
}

- (void)onExit
{
    // very important! deactivate the gestureInput, otherwise touches on scrollviews and tableviews will be cancelled!
    [KKInput sharedInput].gestureSwipeEnabled = FALSE;
    self.accelerometerEnabled = FALSE;
}



- (void)showHUD
{
    // TODO: implement animated
    hudNode.visible = TRUE;
    ship.visible=TRUE;
    centerOfRotation.visible=TRUE;
}

- (void)hideHUD
{
    // TODO: implement animated
    hudNode.visible = FALSE;
    ship.visible=FALSE;
    centerOfRotation.visible=FALSE;
}



/* Pausing the game functions */

- (void)disableGameplayButtons
{
    pauseButtonMenu.enabled = FALSE;
}
- (void)enableGamePlayButtons
{
    pauseButtonMenu.enabled = TRUE;
}

- (void)resumeButtonPressed:(PauseScreen *)pauseScreen
{
    // enable the pause button again, since the pause menu is hidden now
    [self enableGamePlayButtons];
    [self showHUD];
}


- (void)pauseButtonPressed
{
    // disable pause button while the pause menu is shown, since we want to avoid, that the pause button can be hit twice.
    [self disableGameplayButtons];
    [self hideHUD];
    PauseScreen *pauseScreen = [[PauseScreen alloc] initWithGame];
    pauseScreen.delegate = self;
    [self addChild:pauseScreen z:10];
    [pauseScreen present];
    [[GameMechanics sharedGameMechanics] setGameState:GameStatePaused];
}

/*Level Selection functions*/




- (void)goTolevelSelection
{
    // disable pause button while the pause menu is shown, since we want to avoid, that the pause button can be hit twice.
    [self disableGameplayButtons];
    [self hideHUD];
    SelectLevelScreen *levelSelectionScreen = [[SelectLevelScreen alloc] initWithGame];
    [self addChild:levelSelectionScreen z:MAX_INT];
    [levelSelectionScreen present];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void)goToMainMenu{
    [self disableGameplayButtons];
    [self hideHUD];
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] init];
    [self addChild:mainMenuLayer z:MAX_INT];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void) goToWinScreen{
    [self disableGameplayButtons];
    [self hideHUD];
    [game beatLevel];
    [game saveGame];
    WinScreen *winLayer=[[WinScreen alloc]initWithGame];
    [self addChild:winLayer z:MAX_INT];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void) goToLoseScreen{
    [self disableGameplayButtons];
    [self hideHUD];
    [game loseLevel];
    [game saveGame];
    LoseScreen *loseLayer=[[LoseScreen alloc]initWithGame];
    [self addChild:loseLayer z:MAX_INT];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void)goToStore{
    [self disableGameplayButtons];
    [self hideHUD];
    UpgradeScreen *upgradeLayer=[[UpgradeScreen alloc]initWithGame];
    [self addChild:upgradeLayer z:MAX_INT];
    
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void)goToEquip{
    [self disableGameplayButtons];
    [self hideHUD];
    EquipScreen *equipLayer=[[EquipScreen alloc]initWithGame];
    [self addChild:equipLayer z:MAX_INT];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}


@end
