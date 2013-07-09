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
#import "MainMenuLayer.h"
#import "Mission.h"
#import "RecapScreenScene.h"
#import "Store.h"
#import "PopupProvider.h"
#import "CCControlButton.h"
#import "StyleManager.h"
#import "NotificationBox.h"
#import "PauseScreen.h"


#import "MonsterCache.h"
//buttons
#import "SpawnMonsterButton.h"
#import "Orange.h"
#import "Apple.h"
#import "Strawberry.h"
#import "Cherry.h"

#import "Carrot.h"
#import "MonsterButtonCache.h"
//units
#import "World.h"
#import "BasicEnemyMonster.h"
#import "BasicPlayerMonster.h"
#import "Barn.h"
#import "Ship.h"
#import "CCTouchDelegateProtocol.h"

static CGRect screenRect;

// defines how many update cycles run, before the missions get an update about the current game state
#define MISSION_UPDATE_FREQUENCY 10

@interface GameplayLayer()
/*
 Tells the game to display the skipAhead button for N seconds.
 After the N seconds the button will automatically dissapear.
 */
- (void)presentSkipAheadButtonWithDuration:(NSTimeInterval)duration;

/*
 called when skipAheadButton has been touched
 */
- (void)skipAheadButtonPressed;

/*
 called when pause button was pressed
 */
- (void)pauseButtonPressed;

/*
 called when the player has chosen if he wants to continue the game (for paying coins) or not
 */
- (void)goOnPopUpButtonClicked:(CCControlButton *)sender;

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
        
        
        //create node for monster button objects
        [self addChild:[MonsterButtonCache sharedMonsterButtonCache]];
        
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
                
        // setup a new gaming session
        [self resetGame];
        
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
    [[GameMechanics sharedGameMechanics] setGameState:GameStateRunning];
    [self enableGamePlayButtons];
    [self presentSkipAheadButtonWithDuration:5.f];
    
    /*
     inform all missions, that they have started
     */
    for (Mission *m in game.missions)
    {
        [m missionStart:game];
    }
}

- (void)resetGame
{
    [[GameMechanics sharedGameMechanics] resetGame];
    game = [[Game alloc] init];
    [[GameMechanics sharedGameMechanics] setGame:game];
    // add a reference to this gamePlay scene to the gameMechanics, which allows accessing the scene from other classes
    [[GameMechanics sharedGameMechanics] setGameScene:self];
    [[MonsterCache sharedMonsterCache]spawnBarn];
    [[MonsterCache sharedMonsterCache]reset];
    [timer resetTimer:game.timeInSec];
    [ship reset];
    [energy resetEnergy:game.energyMax increasedAt:game.energyPerSec];
    
        [[MonsterButtonCache sharedMonsterButtonCache] reset];
    [[MonsterButtonCache sharedMonsterButtonCache] placeButton:[Orange class] atLocation:0];
    [[MonsterButtonCache sharedMonsterButtonCache] placeButton:[Apple class] atLocation:1];
    [[MonsterButtonCache sharedMonsterButtonCache] placeButton:[Strawberry class] atLocation:2];
    [[MonsterButtonCache sharedMonsterButtonCache] placeButton:[Cherry class] atLocation:3];
    /* setup initial values */
    centerOfRotation.rotation=0;
    
    // set spwan rate for monsters
    [[GameMechanics sharedGameMechanics] setSpawnCost:2 forPlayerMonsterType:[Orange class]];
        [[GameMechanics sharedGameMechanics] setSpawnCost:2 forPlayerMonsterType:[Apple class]];
        [[GameMechanics sharedGameMechanics] setSpawnCost:2 forPlayerMonsterType:[Strawberry class]];
        [[GameMechanics sharedGameMechanics] setSpawnCost:2 forPlayerMonsterType:[Cherry class]];
    [[GameMechanics sharedGameMechanics] setSpawnRate:300 forEnemyMonsterType:[Carrot class]];
}

#pragma mark - Update & Input Events


- (void)pushGameStateToMissions
{
    for (Mission *mission in game.missions)
    {
        if (mission.successfullyCompleted)
        {
            // we skip this mission, since it succesfully completed
            continue;
        }
        
        if ([mission respondsToSelector:@selector(generalGameUpdate:)])
        {
            // inform about current game state
            [mission generalGameUpdate:game];
            
            // check if mission is now completed
            if (mission.successfullyCompleted)
            {
                NSString *missionAccomplished = [NSString stringWithFormat:@"Completed: %@", mission.missionDescription];
                [NotificationBox presentNotificationBoxOnNode:self withText:missionAccomplished duration:1.f];
            }
        }
    }
}

- (void) update:(ccTime)delta
{
    // update the amount of in-App currency in pause mode, too
    inAppCurrencyDisplayNode.score = [Store availableAmountInAppCurrency];
    
    if ([[GameMechanics sharedGameMechanics] gameState] == GameStateRunning)
    {
        [self updateRunning:delta];
        
        // check if we need to inform missions about current game state
        updateCount++;
        //        if ((updateCount % MISSION_UPDATE_FREQUENCY) == 0)
        //        {
        //            [self pushGameStateToMissions];
        //        }
    }
}

- (void)updateRunning:(ccTime)delta
{
    pointsDisplayNode.score=game.gold;
    game.timeInSec=timer.timeInSec;
    [energy setEnergy:game.energy];
    
    //for rotation deceleration
    if(rotationVelocity!=0.0){
        centerOfRotation.rotation+=rotationVelocity;
        if(rotationVelocity>0){
            rotationVelocity-=2;
            if(rotationVelocity<1){
                rotationVelocity=0;
            }
        }else{
            rotationVelocity+=2;
            if(rotationVelocity>-1){
                rotationVelocity=0;
            }
        }
    }
    
    if(shipFire){
        [ship fireBullet];
    }
    centerOfRotation.rotation=fmodf(centerOfRotation.rotation, 360);
    
    
//        if ([[MonsterCache sharedMonsterCache] playerBarn].hitPoints <= 0)
//        {
//           // knight died, present screen with option to GO ON for paying some coins
//            [self presentGoOnPopUp];
//        }else if ([[MonsterCache sharedMonsterCache] enemyBarn].hitPoints <= 0)
//        {
//            // knight died, present screen with option to GO ON for paying some coins
//            [self presentGoOnPopUp];
//        }
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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
    }else if(CGRectContainsPoint([[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:0 ].boundingBox, touchPoint)){
        touchingworld=false;
        [(SpawnMonsterButton*)[[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:0 ] pressed];
    }else if(CGRectContainsPoint([[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:1 ].boundingBox, touchPoint)){
        touchingworld=false;
        [(SpawnMonsterButton*)[[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:1 ] pressed];
    }else if(CGRectContainsPoint([[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:2 ].boundingBox, touchPoint)){
        touchingworld=false;
        [(SpawnMonsterButton*)[[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:2 ] pressed];
    }else if(CGRectContainsPoint([[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:3 ].boundingBox, touchPoint)){
        touchingworld=false;
        [(SpawnMonsterButton*)[[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:3 ] pressed];
    }else{
        touchingworld=false;
        shipFire=TRUE;
        
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
        centerOfRotation.rotation+=2.15*deltaRotation;
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
    //    // setup a gesture listener for jumping and stabbing gestures
    //    [KKInput sharedInput].gestureSwipeEnabled = TRUE;
    
    if (self.showMainMenu)
    {
        // add main menu
        MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] init];
        [self addChild:mainMenuLayer z:MAX_INT];
    } else
    {
        // start game directly
        [self showHUD:TRUE];
        [self startGame];
    }
}

- (void)onExit
{
    // very important! deactivate the gestureInput, otherwise touches on scrollviews and tableviews will be cancelled!
    [KKInput sharedInput].gestureSwipeEnabled = FALSE;
    self.accelerometerEnabled = FALSE;
}

#pragma mark - UI

- (void)presentGoOnPopUp
{
    [[GameMechanics sharedGameMechanics] setGameState:GameStatePaused];
    CCScale9Sprite *backgroundImage = [StyleManager goOnPopUpBackground];
    goOnPopUp = [PopupProvider presentPopUpWithContentString:nil backgroundImage:backgroundImage target:self selector:@selector(goOnPopUpButtonClicked:) buttonTitles:@[@"OK", @"No"]];
    [self disableGameplayButtons];
}

- (void)showHUD:(BOOL)animated
{
    // TODO: implement animated
    hudNode.visible = TRUE;
}

- (void)hideHUD:(BOOL)animated
{
    // TODO: implement animated
    hudNode.visible = FALSE;
}

- (void)presentSkipAheadButtonWithDuration:(NSTimeInterval)duration
{
    skipAheadMenu.visible = TRUE;
    skipAheadMenu.opacity = 0.f;
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.5f];
    [skipAheadMenu runAction:fadeIn];
    
    [self scheduleOnce: @selector(hideSkipAheadButton) delay:duration];
}

- (void)hideSkipAheadButton
{
    CCFiniteTimeAction *fadeOut = [CCFadeOut actionWithDuration:1.5f];
    CCCallBlock *hide = [CCCallBlock actionWithBlock:^{
        // execute this code to hide the 'Skip Ahead'-Button, once it is faded out
        skipAheadMenu.visible = FALSE;
        // enable again, so that interaction is possible as soon as the menu is visible again
        skipAheadMenu.enabled = TRUE;
    }];
    
    CCSequence *fadeOutAndHide = [CCSequence actions:fadeOut, hide, nil];
    
    [skipAheadMenu runAction:fadeOutAndHide];
}

- (void)disableGameplayButtons
{
    pauseButtonMenu.enabled = FALSE;
    skipAheadMenu.enabled = FALSE;
}
- (void)enableGamePlayButtons
{
    pauseButtonMenu.enabled = TRUE;
    skipAheadMenu.enabled = TRUE;
}

#pragma mark - Delegate Methods

/*
 This method is called, when purchases on the In-Game-Store occur.
 Then we need to update the coins display on the HUD.
 */
- (void)storeDisplayNeedsUpdate
{
    inAppCurrencyDisplayNode.score = [Store availableAmountInAppCurrency];
}

- (void)resumeButtonPressed:(PauseScreen *)pauseScreen
{
    // enable the pause button again, since the pause menu is hidden now
    [self enableGamePlayButtons];
}

#pragma mark - Button Callbacks

- (void)skipAheadButtonPressed
{
    if ([Store hasSufficientFundsForSkipAheadAction])
    {
        skipAheadMenu.enabled = FALSE;
        CCLOG(@"Skip Ahead!");
        [self startSkipAheadMode];
        
        // hide the skip ahead button, after it was pressed
        // we need to cancel the previously scheduled perform selector...
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSkipAheadButton) object:nil];
        
        // ... in order to execute it directly
        [self hideSkipAheadButton];
    } else
    {
        // pause the game, to allow the player to buy coins
        [[GameMechanics sharedGameMechanics] setGameState:GameStatePaused];
        [self presentMoreCoinsPopUpWithTarget:self selector:@selector(returnedFromMoreCoinsScreenFromSkipAheadAction)];
    }
}

- (void)goOnPopUpButtonClicked:(CCControlButton *)sender
{
    CCLOG(@"Button clicked.");
    if (sender.tag == 0)
    {
        if ([Store hasSufficientFundsForGoOnAction])
        {
            // OK button selected
            [goOnPopUp dismiss];
            [self executeGoOnAction];
            [self enableGamePlayButtons];
        } else
        {
            // game is paused in this state already, we only need to present the more coins screen
            // dismiss the popup; presented again when we return from the 'Buy More Coins'-Screen
            [goOnPopUp dismiss];
            [self presentMoreCoinsPopUpWithTarget:self selector:@selector(returnedFromMoreCoinsScreenFromGoOnAction)];
        }
    } else if (sender.tag == 1)
    {
        // Cancel button selected
        [goOnPopUp dismiss];
        game.gold ++;
        
        // IMPORTANT: set game state to 'GameStateMenu', otherwise menu animations will no be played
        [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
        
        RecapScreenScene *recap = [[RecapScreenScene alloc] initWithGame:game];
        [[CCDirector sharedDirector] replaceScene:recap];
    }
}

- (void)pauseButtonPressed
{
    CCLOG(@"Pause");
    // disable pause button while the pause menu is shown, since we want to avoid, that the pause button can be hit twice.
    [self disableGameplayButtons];
    
    PauseScreen *pauseScreen = [[PauseScreen alloc] initWithGame:game];
    pauseScreen.delegate = self;
    [self addChild:pauseScreen z:10];
    [pauseScreen present];
    [[GameMechanics sharedGameMechanics] setGameState:GameStatePaused];
}

#pragma mark - Game Logic

- (void)executeGoOnAction
{
    [Store purchaseGoOnAction];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateRunning];
    [NotificationBox presentNotificationBoxOnNode:self withText:@"Going on!" duration:1.f];
}

- (void)startSkipAheadMode
{
    BOOL successful = [Store purchaseSkipAheadAction];
    
    /*
     Only enter the skip ahead mode if the purchase was successful (player had enough coins).
     This is checked previously, but we want to got sure that the player can never access this item
     without paying.
     */
    if (successful)
    {
        [self scheduleOnce: @selector(endSkipAheadMode) delay:5.f];
        
        // present a notification, to inform the user, that he is in skip ahead mode
        [NotificationBox presentNotificationBoxOnNode:self withText:@"Skip Ahead Mode!" duration:4.5f];
    }
}

- (void)endSkipAheadMode
{
    
}

- (void)presentMoreCoinsPopUpWithTarget:(id)target selector:(SEL)selector
{
    CCLOG(@"You need more coins!");
    NSArray *inGameStoreItems = [Store inGameStoreStoreItems];
    
    /*
     The inGameStore is initialized with a callback method, which is called,
     once the closebutton is pressed.
     */
    inGameStore = [[InGameStore alloc] initWithStoreItems:inGameStoreItems backgroundImage:@"InGameStore_background.png" closeButtonImage:@"InGameStore_close.png" target:target selector:selector];
    /* The delegate adds a further callback, called when Items are purchased on the store, and we need to update our coin display */
    inGameStore.delegate = self;
    
    inGameStore.position = ccp(self.contentSize.width / 2, self.contentSize.height + 0.5 * inGameStore.contentSize.height);
    CGPoint targetPosition = ccp(self.contentSize.width / 2, self.contentSize.height /2);
    
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:1.f position:targetPosition];
    [self addChild:inGameStore z:MAX_INT];
    
    [inGameStore runAction:moveTo];
}


/* called when the 'More Coins Screen' has been closed, after previously beeing opened by
 attempting to buy a 'Skip Ahead' action */
- (void)returnedFromMoreCoinsScreenFromSkipAheadAction
{
    // hide store and resume game
    [inGameStore removeFromParent];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateRunning];
    [self enableGamePlayButtons];
}

- (void)returnedFromMoreCoinsScreenFromGoOnAction
{
    [inGameStore removeFromParent];
    [self presentGoOnPopUp];
}

@end
