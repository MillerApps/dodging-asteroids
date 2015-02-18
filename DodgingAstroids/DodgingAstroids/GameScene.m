//
//  GameScene.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/5/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "GameScene.h"
#import "ShipNode.h"
#import "Utils.h"
#import "AsteroidNode.h"
#import "EndScene.h"
#import "PauseButtonNode.h"
#import "PlayButtonNode.h"


@interface GameScene ()

//allows to control astroid spawn rate
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceAdded;
@property (nonatomic) ShipNode *ship;
@property (nonatomic) PauseButtonNode *pauseBtn;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isPausedByResign;
@property (nonatomic) BOOL isShip;
@property (nonatomic) SKAction *playExpolsionSFX;
@property (nonatomic) SKAction *playShipMovementSFX;

@end

@implementation GameScene



#pragma mark - Add Nodes

- (void)addPlayerShip {
    //add spaceship to scene
    self.ship = [ShipNode shipAtPostion:CGPointMake(self.size.width/2, 100)];
    [self addChild:self.ship];
    [self.ship playShipSFXForever];
    
    
    
}

-(void)addAstroids {
    // astroids Will be added to the scene at random positions in the fully functional Game
    //add astroids to scene
    NSUInteger randomAstroid = [Utils randomWithMin:0 max:3];
    
    AsteroidNode *astroid = [AsteroidNode astroidOfType:randomAstroid];
    //set restarist for where astroids spawn
    float y = self.frame.size.height;
    float x = [Utils randomWithMin:astroid.size.width / 2 max:self.frame.size.width - astroid.size.width /2];
    
    //set postion
    astroid.position = CGPointMake(x, y);
    [self addChild:astroid];
    
}

- (void)addPauseButton {
    //add [ause button
    _pauseBtn = [PauseButtonNode buttonAtPosition:CGPointMake(self.size.width - 65, self.size.height - 30)];
    [self addChild:_pauseBtn];
}



- (void)preLoadSFX {
    //preload sound actions
    self.playExpolsionSFX = [SKAction playSoundFileNamed:@"rock.caf" waitForCompletion:NO];
    self.playShipMovementSFX = [SKAction playSoundFileNamed:@"shipMovement.caf" waitForCompletion:NO];
}

-(void)didMoveToView:(SKView *)view {
    
    [self registerAppTransitionObservers];//if this is removed the EXC_BAD_ACCESS never happens; with Zombies turned on I get this EXC_Breakpoint
    
    _isPaused = NO;
    _isShip = YES;
    //Set the background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    background.size = self.size;
    background.zPosition = 0;
    [self addChild:background];
    
    [self addPauseButton];
    
    
    //set physicsbody for scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = CollisionCatEdge;
    //physics world gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    //contact deleagte
    self.physicsWorld.contactDelegate = self;
    
    
    [self addPlayerShip];
    //called once to have astroid spawn immediately
    [self addAstroids];
    
    [self preLoadSFX];

    
    
}

#pragma mark - Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //COde for moving ship
    
    //get a UITouch object
    UITouch *touch = [touches anyObject];
    //get touch loc
    CGPoint location = [touch locationInNode:self];
    //get selected node
    SKNode *node = [self nodeAtPoint:location];
    
    float moveBy = 20.0;
    
    //checks for pause button
    if ([node.name isEqualToString:@"pauseButton"]) {
        
        
        if (_isShip) {
            [self.ship stopShipSFX];
            [node removeFromParent];
            
            //setup start/play button
            PlayButtonNode *play = [PlayButtonNode buttonAtPosition:node.position];
            [self addChild:play];
            
            
            
            [self performSelector:@selector(pauseGame) withObject:nil afterDelay:1/60.0];
            
            _isPaused = YES;
        } else {
            _isPaused = NO;
        }
        
        
        
        
    } else if ([node.name isEqualToString:@"playButton"]) {
        
        [node removeFromParent];
        
        
        
        [self addPauseButton];
        _isPaused = NO;
        
        
        if (_isShip) {
            [self.ship playShipSFXForever];//only plays sound back if ship still exists
            
            
        }
        self.scene.paused = NO;
        
    } else {
        
        //detect if the left portion of the scene is touched
        if (location.x < self.size.width / 2) {
            //move ship to the left
            
            
            [self.ship runAction:[SKAction sequence:@[self.playShipMovementSFX,
                                                      [SKAction moveByX:-moveBy y:0.0 duration:0.0]]]];
            
        }
        
        //detec if the right portion of the scene is touched
        if (location.x > self.size.width / 2) {
            //move ship to the right
            
           
            [self.ship runAction:[SKAction sequence:@[self.playShipMovementSFX,
                                                      [SKAction moveByX:moveBy y:0.0 duration:0.0]]]];
        }
    }
    
    
    
    
}


#pragma mark - Pause Game

-(void)pauseGame {
    
    if (_isShip) {
        self.scene.paused = YES;
        
        if (_isPausedByResign && !_isPaused) {
            [self.ship stopShipSFX];
            [_pauseBtn removeFromParent];
            
            //setup start/play button
            PlayButtonNode *play = [PlayButtonNode buttonAtPosition:_pauseBtn.position];
            [self addChild:play];
            
            _isPaused = YES;
            _isPausedByResign = NO;
        }
    }
    
}

#pragma mark - Contact Detection 

- (void)animateShipExplosion {
    
    SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithImageNamed:@"explosion00"];
    explosion.position = self.ship.position; //sets the postion to that of the ship's
    explosion.size = self.ship.size; //sets the size/scale equal tot the ship's
    explosion.zPosition = 1;
    [self addChild:explosion];
    
    NSArray *shipHitAnimation = @[[SKTexture textureWithImageNamed:@"explosion00"],
                                  [SKTexture textureWithImageNamed:@"explosion01"],
                                  [SKTexture textureWithImageNamed:@"explosion02"],
                                  [SKTexture textureWithImageNamed:@"explosion03"],
                                  [SKTexture textureWithImageNamed:@"explosion04"],
                                  [SKTexture textureWithImageNamed:@"explosion05"]];
    
    SKAction *animate = [SKAction animateWithTextures:shipHitAnimation timePerFrame:0.50];
    [explosion runAction:[SKAction repeatAction:animate count:2] completion:^{
        [explosion removeFromParent];
        
        //Transition to end
        EndScene *gameOver = [EndScene sceneWithSize:self.size];
        [self.view presentScene:gameOver transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
        
        
    }];
}


-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *sceondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        sceondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        sceondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == CollisionCatShip && sceondBody.categoryBitMask == CollisionCatAstroid) {
        ShipNode *ship = (ShipNode *)firstBody.node;
        AsteroidNode *asteroid = (AsteroidNode *)sceondBody.node;
        
        [self animateShipExplosion];
        
        
        [self runAction:self.playExpolsionSFX];
        [ship removeFromParent];
        [asteroid removeFromParent];
        [self.ship stopShipSFX];
        
        _isShip = NO;
    }
    
}


#pragma mark - Update Loop

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (_isPaused) {
        self.lastUpdateTimeInterval = 0;
        return;
    } else {
        
        
        
        //called for astroid spawning
        if (self.lastUpdateTimeInterval) {
            self.timeSinceAdded += currentTime - self.lastUpdateTimeInterval;
        }
        
        if (self.timeSinceAdded > 2.25) {
            [self addAstroids];
            self.timeSinceAdded = 0;
        }
        
        
        self.lastUpdateTimeInterval = currentTime;
    }
    
    
    
    
}

#pragma mark - NSNotificationCenter for Handleing pauses

-(void)registerAppTransitionObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:Nil];
    
}

-(void)applicationWillResignActive {
    _isPausedByResign = YES;
    if (!_isPaused) {
        [self pauseGame];
    }
}

-(void)applicationDidEnterBackground {
    self.view.paused = YES;
    [_ship stopShipSFX];
    
    
}

-(void)applicationWillEnterForeground {
    self.view.paused = NO;
    if (_isPaused) {
        [self pauseGame];
    }
}

@end
