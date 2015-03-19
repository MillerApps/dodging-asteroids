//
//  ScoreDetailViewController.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/19/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "ScoreDetailViewController.h"

@interface ScoreDetailViewController ()

@end

@implementation ScoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.infoLabel.text = [NSString stringWithFormat:@"Name: %@ Score: %@", self.name, self.score];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareScore:(id)sender {
    
    NSString *infoToShare = [NSString stringWithFormat:@"Check out %@'s highscore in Dodging Asteroids. Score: %@", self.name, self.score];
    
    UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:@[infoToShare] applicationActivities:nil];
    [self presentViewController:share animated:YES completion:nil];
}

@end
