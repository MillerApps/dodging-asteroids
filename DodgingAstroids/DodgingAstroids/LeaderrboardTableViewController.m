//
//  LeaderrboardTableViewController.m
//  DodgingAsteroids
//
//  Created by Tyler Miller on 3/18/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "LeaderrboardTableViewController.h"
#import "ScoreDetailViewController.h"

@interface LeaderrboardTableViewController ()

@property (nonatomic) NSMutableArray *highScoresArray;
@property (nonatomic)  NSUserDefaults *scores;

@end

@implementation LeaderrboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //get array from NSUSerDefaults
    _scores = [NSUserDefaults standardUserDefaults];
    _highScoresArray = [[NSMutableArray alloc] initWithArray:[_scores objectForKey:@"highScoreArray"]];
    
    //sort array
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [_highScoresArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [_highScoresArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    // Configure the cell...
    cell.textLabel.text = [_scores valueForKey:@"playerName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_highScoresArray objectAtIndex:indexPath.row]];
    
    return cell;
}




 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"showDetails"]) {
         NSIndexPath *path = [self.ScoresTableView indexPathForCell:sender];
         ScoreDetailViewController *vc = segue.destinationViewController;
         
         vc.name = [_scores valueForKey:@"playerName"];
         vc.score = [NSString stringWithFormat:@"%@", [_highScoresArray objectAtIndex:path.row]];
     }
    
 }
 

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)filterTableViewData:(id)sender {
    
    switch (self.segmentedControll.selectedSegmentIndex) {
        case 0:
        {
            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            [_highScoresArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
            [self.ScoresTableView reloadData];
        }
            
            break;
            
        case 1:
        {
            NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
            [_highScoresArray sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];
            [self.ScoresTableView reloadData];
            
        }
            
        default:
            break;
    }
}

@end
