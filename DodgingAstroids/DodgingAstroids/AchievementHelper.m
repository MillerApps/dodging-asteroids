//
//  AchievementHelper.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/24/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "AchievementHelper.h"

static NSString *const collectSpacemanID = @"com.miller.DodgingAsteroids.collectspaceman";
static NSString *const takeHitID = @"com.miller.DodgingAsteroids.takehit";
static NSString *const scoreID = @"com.miller.DodgingAsteroids.score";
static NSInteger const maxHits = 3;


@implementation AchievementHelper

+ (GKAchievement *)collectSpacemanAchievement {

    GKAchievement *collectionAchievement = [[GKAchievement alloc] initWithIdentifier:collectSpacemanID];
    collectionAchievement.percentComplete = 100;
    collectionAchievement.showsCompletionBanner =  YES;
       
    
    
    
    return collectionAchievement;
    
}

+ (GKAchievement *)scoreInOneLife {
    
    GKAchievement *inOneLife = [[GKAchievement alloc] initWithIdentifier:scoreID];
    inOneLife.percentComplete = 100;
    inOneLife.showsCompletionBanner = YES;
    
    return inOneLife;
    
}

@end
