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
#import "AstroidNode.h"
#import "EndScene.h"
#import "PauseButtonNode.h"
#import "PlayButtonNode.h"

@interface GameScene ()

//allows to control astroid spawn rate
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceAdded;
@property (nonatomic) ShipNode *ship;
@property (nonatomic) BOOL isPaused;


@end

@implementation GameScene

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
    
    AstroidNode *astroid = [AstroidNode astroidOfType:randomAstroid];
    //set restarist for where astroids spawn
    float y = self.frame.size.height;
    float x = [Utils randomWithMin:astroid.size.width / 2 max:self.frame.size.width - astroid.size.width /2];
    
    //set postion
    astroid.position = CGPointMake(x, y);
    [self addChild:astroid];
    
}

- (void)addPauseButton {
    //add [ause button
    PauseButtonNode *button = [PauseButtonNode buttonAtPosition:CGPointMake(self.size.width - 65, self.size.height - 30)];
    [self addChild:button];
}

-(void)didMoveToView:(SKView *)view {
    
    _isPaused = NO;
    //Set the background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    background.size = self.size;
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
    
    
    
}

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
        
        [self.ship pauseSFX];
        [node removeFromParent];
        
        //setup start/play button
        PlayButtonNode *play = [PlayButtonNode buttonAtPosition:node.position];
        [self addChild:play];
        
        [self performSelector:@selector(pauseGame) withObject:nil afterDelay:1/60.0];
        
        _isPaused = YES;
        
    } else if ([node.name isEqualToString:@"playButton"]) {
        
        self.scene.view.paused = NO;
        [self.ship resumeSFX];
        [node removeFromParent];
        [self addPauseButton];
        _isPaused = NO;
        
    } else {
        
        //detect if the left portion of the scene is touched
        if (location.x < self.size.width / 2) {
            //move ship to the left
            
            NSArray *actions = @[[SKAction playSoundFileNamed:@"shipMovement.caf" waitForCompletion:NO],
                                 [SKAction moveByX:-moveBy y:0.0 duration:0.0]];
            [self.ship runAction:[SKAction sequence:actions]];
            
        }
        
        //detec if the right portion of the scene is touched
        if (location.x > self.size.width / 2) {
            //move ship to the right
            
            NSArray *actions = @[[SKAction playSoundFileNamed:@"shipMovement.caf" waitForCompletion:NO],
                                 [SKAction moveByX:moveBy y:0.0 duration:0.0]];
            [self.ship runAction:[SKAction sequence:actions]];
            
        }
    }
    
    
    
    
}

-(void)pauseGame {
    self.scene.view.paused = YES;
}
- (void)animateShipExplosion {
    
    SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithImageNamed:@"explosion00"];
    explosion.position = self.ship.position; //sets the postion to that of the ship's
    explosion.size = self.ship.size; //sets the size/scale equal tot the ship's
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
        AstroidNode *asteroid = (AstroidNode *)sceondBody.node;
        
        [self animateShipExplosion];
        
        
        [self runAction:[SKAction playSoundFileNamed:@"rock.caf" waitForCompletion:NO]];
        [ship removeFromParent];
        [asteroid removeFromParent];
        [self.ship stopShipSFX];
    }
    
}




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

@end
