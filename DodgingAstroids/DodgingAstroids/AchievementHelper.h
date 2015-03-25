//
//  AchievementHelper.h
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/24/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

@interface AchievementHelper : NSObject

+ (GKAchievement *)collectSpacemanAchievement;
+ (GKAchievement *)scoreInOneLife;


@end
