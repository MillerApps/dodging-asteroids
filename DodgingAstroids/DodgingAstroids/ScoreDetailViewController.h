//
//  ScoreDetailViewController.h
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/19/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *score;

@end
