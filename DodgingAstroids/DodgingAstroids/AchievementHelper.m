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
static NSString *const incrementalScoreID = @"com.miller.DodgingAsteroids.incremental";
static NSInteger const kNumberOfPoints = 200;




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

+ (GKAchievement *)takeAHitAchievement {
    
    GKAchievement *takeAHit = [[GKAchievement alloc] initWithIdentifier:takeHitID];
    takeAHit.percentComplete = 100;
    takeAHit.showsCompletionBanner = YES;
    
    return takeAHit;
}

+ (GKAchievement *)incrementalScore:(NSInteger)numberOfPoints {
    
    NSUserDefaults *hasShown = [NSUserDefaults standardUserDefaults];
    
    
    
    float percent = ((float)numberOfPoints / (float)kNumberOfPoints) *100;
    
    
    GKAchievement *incrementalScoreAchievement = [[GKAchievement alloc] initWithIdentifier:incrementalScoreID];
    incrementalScoreAchievement.percentComplete = percent;
    
    
    switch (numberOfPoints) {
        case 50:
            if (percent == 25 && ![hasShown boolForKey:@"partOne"]) {
                incrementalScoreAchievement.showsCompletionBanner = YES;
                [GKNotificationBanner showBannerWithTitle:@"Score 50, 100. and 200 points: Part 1" message:@"Obtained 50 Points" completionHandler:nil];
                [hasShown setBool:YES forKey:@"partOne"];//makes sure achievement is shown once
            }
            
            break;
        case 100:
            if (percent == 50 && ![hasShown boolForKey:@"partTwo"]) {
                incrementalScoreAchievement.showsCompletionBanner = YES;
                [GKNotificationBanner showBannerWithTitle:@"Score 50, 100. and 200 points: Part 2" message:@"Obtained 100 Points" completionHandler:nil];
                [hasShown setBool:YES forKey:@"partTwo"];//makes sure achievement is shown once
            }
            
            break;
        case 200:
            if (percent == 100 && ![hasShown boolForKey:@"partThree"]) {
                incrementalScoreAchievement.showsCompletionBanner = YES;
                [GKNotificationBanner showBannerWithTitle:@"Score 50, 100. and 200 points: Part 3" message:@"Obtained 200 Points" completionHandler:nil];
                [hasShown setBool:YES forKey:@"partThree"];//makes sure achievement is shown once
            }
            
            break;
            
        default:
            break;
    }
    
    
    
    return incrementalScoreAchievement;
}

@end
