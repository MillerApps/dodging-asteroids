//
//  LeaderrboardTableViewController.h
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/18/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderrboardTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ScoresTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;

@end
