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
#import "TutorialScreen1.h"
#import "ConfirmScreen.h"
#import "TutorialScreen2.h"

//Caches
#import "MonsterCache.h"
#import "MonsterButtonCache.h"

//units
#import "World.h"
#import "Ship.h"

#import "Orange.h"
#import "Carrot.h"
#import "STYLES.h"
#import "CCSpriteBackgroundNode.h"
#import "CCBackgroundColorNode.h"
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
        
        barnUnderAttack=[[AlertSign alloc]initWithEntityImage];
        barnUnderAttack.position= ccp(-7, 0);
        [barnUnderAttack setScale:.6];
        [self addChild:barnUnderAttack];
        barnUnderAttack.visible=FALSE;
        
        //create the ship object
        self.ship=[[Ship alloc] initWithMonsterPicture];
        self.ship.position=ccp(screenSize.width/2,screenSize.height-self.ship.contentSize.height/4);
        [self addChild:self.ship z:8 tag:0];
        
        //set the world image
        planet=[World createEntity];
        
        
        //create a node where the all mosnter sprites will rotate around
        self.centerOfRotation=[CCNode node];
        [self addChild:self.centerOfRotation z:1 tag:1];
        //include the planet into the rotation node
        [self.centerOfRotation addChild:planet z:1 tag:1];
        
        //create the game mechanic object
        [GameMechanics sharedGameMechanics];
        game = [[Game alloc] init];
        [[GameMechanics sharedGameMechanics] setGameScene:self];
        [[GameMechanics sharedGameMechanics] setGame:game];
        
        //include the node that creates and hold all monster object
        [self.centerOfRotation addChild:[MonsterCache sharedMonsterCache] z:2 tag:2];
        
        //node that contains all gameplay objects
        hudNode = [CCNode node];
        [self addChild:hudNode];
        
        //create node for monster button objects
        [hudNode addChild:[MonsterButtonCache sharedMonsterButtonCache]];
        
        //        // add scoreboard entry for points
        //        pointsDisplayNode = [[ScoreboardEntryNode alloc] initWithfontFile:@"avenir24.fnt"];
        //        pointsDisplayNode.position = ccp(10, screenSize.height -60);
        //        pointsDisplayNode.scoreStringFormat = @"Gold: %d";
        //        [pointsDisplayNode setScale:1.5];
        //        [hudNode addChild:pointsDisplayNode z:MAX_INT-1];
        //include timer
//        self.timer=[[TimerDisplayNode alloc] initWithfontFile:@"avenir24.fnt"];
//        self.timer.position = ccp(10, screenSize.height - 40);
//        [self.timer setScale:1.5];
//        [hudNode addChild:self.timer z:8];
        //include energy
        self.energy=[[EnergyDisplayNode alloc] initWithfontFile:@"avenir24.fnt"];
        self.energy.position = ccp(10, screenSize.height - 20);
        [self.energy setScale:1.5];
        [hudNode addChild:self.energy z:8];
        // set up pause button
        CCSprite *pauseButton = [CCSprite spriteWithFile:@"pause.png"];
        CCSprite *pauseButtonPressed = [CCSprite spriteWithFile:@"pause-pressed.png"];
        pauseButtonMenuItem = [CCMenuItemSprite itemWithNormalSprite:pauseButton selectedSprite:pauseButtonPressed target:self selector:@selector(pauseButtonPressed)];
        pauseButtonMenu = [CCMenu menuWithItems:pauseButtonMenuItem, nil];
        pauseButtonMenu.position = ccp(20, screenSize.height - 80);
        [hudNode addChild:pauseButtonMenu];
        sizeOfArray=5;
        touchDeltas=[[NSMutableArray alloc] initWithCapacity:sizeOfArray];
        count=0;
        
        
        
        CCSprite *white=[[CCSprite alloc]initWithFile:@"detail.jpg"];
        [white setScale:1.3];
        white.position = ccp(40, screenSize.height - 20);
        [hudNode addChild:white z:-1];
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
    barnUnderAttack.visible=FALSE;
    [[GameMechanics sharedGameMechanics] setGameState:GameStateRunning];
    if(game.gameplayLevel==0){
        [self level0Tutorial];
    }
    if(game.gameplayLevel==1){
        [self level1Tutorial];
    }
    
}

- (void)resetGame
{
    self.ableToShoot=TRUE;
    self.ableToRotate=TRUE;
    [planet reset];
    if(game.difficulty ==EASY){
        
        self.radiusOfWorld=planet.contentSize.width*1.75;
        self.centerOfRotation.position= ccp(screenSize.width/2, -self.radiusOfWorld/1.21+10);
        self.centerOfRotation.rotation=-135;
    }else{
        self.radiusOfWorld=planet.contentSize.width*1.6;
        self.centerOfRotation.position= ccp(screenSize.width/2, -self.radiusOfWorld/1.21+10);
        self.centerOfRotation.rotation=-90;
    }
    //reset all spawn rates and spawn cost for monsters
    [[GameMechanics sharedGameMechanics] resetGame];
    //reset game info for this level
    [game reset];
    //reset barn
    [[MonsterCache sharedMonsterCache]spawnBarn];
    //reset all monsters
    [[MonsterCache sharedMonsterCache]reset];
    //reset timer
    [self.timer resetTimer:game.timeInSec];
    //reset the ship
    [self.ship reset];
    //reset energy info
    [self.energy resetEnergy:game.energyMax increasedAt:game.energyPerSec];
    //reset the monster buttons and their delays
    [[MonsterButtonCache sharedMonsterButtonCache] reset];
    /* setup initial values */
    shipFireToggle=FALSE;
    shipFire=FALSE;
    rotationVelocity=0;
    
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
    [self.energy setEnergy:game.energy];
    if([[MonsterCache sharedMonsterCache] playerBarnUnderAttack]){
        barnUnderAttack.position= ccp(70, screenSize.height - 100);
    }else{
        barnUnderAttack.position= ccp(-MAX_INT, 0);
    }
    self.centerOfRotation.rotation=fmodf(self.centerOfRotation.rotation, 360);
        if(game.difficulty==EASY){
            //for rotation deceleration
            if(fabsf(rotationVelocity)>2){
                if(deltaRotation<0){
                    self.centerOfRotation.rotation-=2*rotationVelocity*delta;
                    
                }else{
                    self.centerOfRotation.rotation+=2*rotationVelocity*delta;
                }
                if(rotationVelocity>5){
                    rotationVelocity=rotationVelocity-(rotationVelocity/15);
                }else{
                    rotationVelocity=rotationVelocity-(rotationVelocity/1.2);
                }
            }
            
        }else{
            //for rotation deceleration
            if(fabsf(rotationVelocity)>2){
                if(deltaRotation<0){
                    self.centerOfRotation.rotation-=3*rotationVelocity*delta;
                    
                }else{
                    self.centerOfRotation.rotation+=3*rotationVelocity*delta;
                }
                if(rotationVelocity>5){
                    rotationVelocity=rotationVelocity-(rotationVelocity/30);
                }else{
                    rotationVelocity=rotationVelocity-(rotationVelocity/4);
                }
            }
            
        
    }
    
    //if continously fire bullets from the ship
    if(shipFire && self.ableToShoot){
        [self.ship fireBullet];
    }
    
    //make rotation stay between -360 to 360
    if(game.difficulty==EASY){
        if(self.centerOfRotation.rotation<-135){
            self.centerOfRotation.rotation=-135;
            deltaRotation=deltaRotation*-1;
            rotationVelocity=rotationVelocity-(rotationVelocity/1.2);
        }else if(self.centerOfRotation.rotation>125){
            self.centerOfRotation.rotation=125;
            deltaRotation=deltaRotation*-1;
            rotationVelocity=rotationVelocity-(rotationVelocity/1.2);
        }
    }
    
    //if player barn's hitpoint is 0 or less OR time runs out go to lose screen
    if ([[MonsterCache sharedMonsterCache] playerBarn].alive ==FALSE)
    {
        [self goToLoseScreen];
    }else if ([[MonsterCache sharedMonsterCache] enemyBarn].alive ==FALSE || (game.timeInSec <=0))
    {
        // if enemy barn's hit point is 0 or less go to win screen
        [self goToWinScreen];
    }
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    BOOL touchSpawnButtons=FALSE;
    //stop the rotation
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:[touch view]];
    //get the center of the world
    CGPoint circleCenter=self.centerOfRotation.position;
    //have the coordinate system to align
    touchPoint.y= -touchPoint.y+screenSize.height;
    
    //if the distance between the touch and the center of the circle is less than the radius then this is true
    if(self.ableToRotate && ccpLengthSQ(ccpSub(circleCenter,touchPoint)) <(self.radiusOfWorld*self.radiusOfWorld))
    {
        previousTouch= [touch locationInView:[touch view]];
        rotationVelocity=0;
        touchWorld=touch;
        count=0;
        for(int i=0;i<touchDeltas.count;i++){
            touchDeltas[i]=[NSNumber numberWithFloat:0.0];
        }
    }else{
        for(int i =0; i<MAXSPAWNBUTTONS;i++){
            if(CGRectContainsPoint([[MonsterButtonCache sharedMonsterButtonCache] getChildByTag:i ].boundingBox, touchPoint)){
                touchingworld=false;
                [[MonsterButtonCache sharedMonsterButtonCache] pressedButton:i];
                touchSpawnButtons=TRUE;
            }
        }
        
        
        if(!touchSpawnButtons){
            if(CGRectContainsPoint(self.ship.boundingBox,touchPoint)){
                [self.ship fireBomb];
                //                if(shipFireToggle==TRUE){
                //                    shipFireToggle=FALSE;
                //                }else{
                //                shipFireToggle=TRUE;
                //                }
            }else{
                shipFire=TRUE;
            }
            
        }
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *allTouches=[touches allObjects];
    for(int i=0;i<allTouches.count;i++){
        UITouch *touch =allTouches[i];
        if(touch==touchWorld){
            currentTouch = [touch locationInView: [touch view]];
            //calculate the angle for the first(previous) touch location
            CGPoint firstVector = ccpSub( previousTouch, self.centerOfRotation.position);
            CGFloat firstRotateAngle = -ccpToAngle(firstVector);
            CGFloat previousAngle = CC_RADIANS_TO_DEGREES(firstRotateAngle);
            
            //calculate the curent touch location
            CGPoint vector = ccpSub(currentTouch, self.centerOfRotation.position);
            CGFloat rotateAngle = -ccpToAngle(vector);
            CGFloat currentAngle = CC_RADIANS_TO_DEGREES(rotateAngle);
            //calculate delta angle
            deltaRotation=(currentAngle - previousAngle);
            //rotate the world
            if(game.difficulty==EASY){
                if(self.centerOfRotation.rotation>=-135 && self.centerOfRotation.rotation<=125 ){
                    self.centerOfRotation.rotation+=1.5*deltaRotation;
                }else if(self.centerOfRotation.rotation<-135){
                    self.centerOfRotation.rotation=-135;
                }else if(self.centerOfRotation.rotation>125){
                    self.centerOfRotation.rotation=125;
                }
            }else{
                self.centerOfRotation.rotation+=1.5*deltaRotation;
            }
            touchDeltas[count%sizeOfArray]=[NSNumber numberWithFloat:deltaRotation];
            count++;
            previousTouch=currentTouch;
            previousTime=event.timestamp;
            
        }
    }
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *allTouches=[touches allObjects];
    for(int i=0;i<allTouches.count;i++){
        UITouch *touch =allTouches[i];
        if(touch==touchWorld){
            currentTouch = [touch locationInView: [touch view]];
            currentTime=event.timestamp;
            //calculate the angle for the first(previous) touch location
            CGPoint firstVector = ccpSub( previousTouch, self.centerOfRotation.position);
            CGFloat firstRotateAngle = -ccpToAngle(firstVector);
            CGFloat previousAngle = CC_RADIANS_TO_DEGREES(firstRotateAngle);
            //calculate the curent touch location
            CGPoint vector = ccpSub(currentTouch, self.centerOfRotation.position);
            CGFloat rotateAngle = -ccpToAngle(vector);
            CGFloat currentAngle = CC_RADIANS_TO_DEGREES(rotateAngle);
            
            //calculate the velocity for which the world will spin after the touch ends
            deltaRotation=(currentAngle - previousAngle);
            touchDeltas[count%sizeOfArray]=[NSNumber numberWithFloat:deltaRotation];
            count++;
            float sum=0;
            for(int i=0;i<touchDeltas.count;i++){
                sum+=[touchDeltas[i] floatValue];
            }
            if(count<touchDeltas.count){
                deltaRotation=sum/count;
            }else{
                deltaRotation=sum/touchDeltas.count;
            }
            deltaTime=currentTime-previousTime;
            rotationVelocity=fabsf(deltaRotation/deltaTime);
            touchingworld = false;
        }else if(shipFire){
            shipFire=FALSE;
        }
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
    self.ship.visible=TRUE;
    self.centerOfRotation.visible=TRUE;
}

- (void)hideHUD
{
    // TODO: implement animated
    hudNode.visible = FALSE;
    self.ship.visible=FALSE;
    self.centerOfRotation.visible=FALSE;
    barnUnderAttack.position= ccp(-MAX_INT, 0);
    
}

-(void)hideInfo{
    hudNode.visible = FALSE;
    barnUnderAttack.position= ccp(-MAX_INT, 0);
}

-(void)showInfo{
    hudNode.visible = TRUE;
}



/* Pausing the game functions */

- (void)disableGameplayButtons
{
    pauseButtonMenu.enabled = FALSE;
    pauseButtonMenu.visible=FALSE;
}
- (void)enableGamePlayButtons
{
    pauseButtonMenu.enabled = TRUE;
    pauseButtonMenu.visible=TRUE;
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
    [self addChild:pauseScreen z:9];
    [pauseScreen present];
    [[GameMechanics sharedGameMechanics] setGameState:GameStatePaused];
}

/*Level Selection functions*/




- (void)goTolevelSelection
{
    [self removeChildByTag:10];
    // disable pause button while the pause menu is shown, since we want to avoid, that the pause button can be hit twice.
    [self disableGameplayButtons];
    [self hideHUD];
    SelectLevelScreen *levelSelectionScreen = [[SelectLevelScreen alloc] initWithGame];
    [self addChild:levelSelectionScreen z:9];
    [levelSelectionScreen present];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void)goToMainMenu{
     [self removeChildByTag:10];
    [self disableGameplayButtons];
    [self hideHUD];
    MainMenuLayer *mainMenuLayer = [[MainMenuLayer alloc] init];
    [self addChild:mainMenuLayer z:9];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void) goToWinScreen{
    [self removeChildByTag:10];
        [self disableGameplayButtons];
        [self hideInfo];
        [game beatLevel];
        WinScreen *winLayer=[[WinScreen alloc]initWithGame];
        [self addChild:winLayer z:9];
        [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void) goToLoseScreen{
    [self removeChildByTag:10];
        [self disableGameplayButtons];
        [self hideInfo];
        [game loseLevel];
        LoseScreen *loseLayer=[[LoseScreen alloc]initWithGame];
        [self addChild:loseLayer z:9];
        [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
    
}

-(void)goToStore{
    [self disableGameplayButtons];
    [self hideHUD];
    UpgradeScreen *upgradeLayer=[[UpgradeScreen alloc]initWithGame];
    [self addChild:upgradeLayer z:9];
    
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void)goToEquip{
    [self disableGameplayButtons];
    [self hideHUD];
    EquipScreen *equipLayer=[[EquipScreen alloc]initWithGame];
    [self addChild:equipLayer z:9];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}


-(void)gotToConfirm{
    [self disableGameplayButtons];
    [self hideHUD];
    ConfirmScreen *confirmLayer=[[ConfirmScreen alloc]init];
    [self addChild:confirmLayer z:9];
    [[GameMechanics sharedGameMechanics] setGameState:GameStateMenu];
}

-(void)level0Tutorial{
        [self disableGameplayButtons];
    TutorialScreen1 *tutoritalLayer=[[TutorialScreen1 alloc]initWithGame];
    [self addChild:tutoritalLayer z:8 tag:10];
}

-(void)level1Tutorial{
    TutorialScreen2 *tutoritalLayer=[[TutorialScreen2 alloc]initWithGame];
    [self addChild:tutoritalLayer z:8 tag:10];
}

@end
