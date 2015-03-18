//
//  GameKitHelper.h
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/16/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *LastErrror;

+ (instancetype)sharedGamekitHelper;
- (void)authenticateLocalPlayer;
- (void)reportScore:(int64_t)score forLeaderboardID:(NSString *)leaderboardID;
- (void)showGKGameCenterViewController:(UIViewController *)viewController;

@end
