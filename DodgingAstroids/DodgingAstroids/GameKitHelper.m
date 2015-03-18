//
//  GameKitHelper.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/16/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "GameKitHelper.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";

@interface GameKitHelper () <GKGameCenterControllerDelegate>

@end

@implementation GameKitHelper {
    BOOL _enableGameCenter;
}

+(instancetype)sharedGamekitHelper {
    
    static GameKitHelper *sharedGameKitHelper;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    
    return sharedGameKitHelper;
}

- (id)init {
    self = [super init];
    
    if (self) {
        _enableGameCenter = YES;
    }
    
    return self;
}

- (void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        [self setLastErrror:error];
        
        if (viewController != nil) {
            [self setAuthenticationViewController:viewController];
        } else if ([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
        } else {
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController {
    
    _authenticationViewController = authenticationViewController;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
}

- (void)setLastErrror:(NSError *)LastErrror {
    
    _LastErrror = [LastErrror copy];
    
    if (_LastErrror) {
        NSLog(@"GameKitHelper ERROR: %@", [[_LastErrror userInfo]description]);
    }
    
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString *)leaderboardID {
    
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID];
    
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        [self setLastErrror:error];
    }];

}

- (void)showGKGameCenterViewController:(UIViewController *)viewController {
    
    if (!_enableGameCenter) {
        NSLog(@"Local play in not authenticated");
    }
    
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    
    gameCenterViewController.gameCenterDelegate = self;
    
    gameCenterViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    
    [viewController presentViewController:gameCenterViewController animated:YES completion:nil];
    
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
