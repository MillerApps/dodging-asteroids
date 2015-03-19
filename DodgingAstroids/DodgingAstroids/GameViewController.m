//
//  GameViewController.m
//  DodgingAstroids
//
//  Created by Tyler Miller on 2/5/15.
//  Copyright (c) 2015 Tyler Miller. All rights reserved.
//

#import "GameViewController.h"
#import "TitleScene.h"
#import "GameKitHelper.h"
#import "Utils.h"


@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController



- (void)viewDidLoad
{
    [super viewDidLoad];


    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    TitleScene *scene = [TitleScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    

    // Present the scene.
    [skView presentScene:scene];
    
    [self setupObservers];
    
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - AlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *alertText = [alertView textFieldAtIndex:0];
    //Save name to NSUserDefaults as the Alert will only be presented if no name is stored
    NSUserDefaults *playerName = [NSUserDefaults standardUserDefaults];
    [playerName setValue:alertText.text forKey:@"playerName"];
    NSLog(@"%@", alertText.text);
}


#pragma mark - NSNotifcationCenter Selectors

- (void)showAuthenticationViewController {
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGamekitHelper];
    
    [self presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showGameCenter {
    [[GameKitHelper sharedGamekitHelper] showGKGameCenterViewController:self];
}

- (void)showAlertWithTextField {
    
    UIAlertView *textPopUp = [[UIAlertView alloc] initWithTitle:@"Enter your name" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
    textPopUp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [textPopUp show];

}

- (void)showLeaderBoard {
    [self performSegueWithIdentifier:@"showBoards" sender:self];
}

-(void)showCreditsView {
    [self performSegueWithIdentifier:@"showCredits" sender:self];
    NSLog(@"Credits");
}

#pragma mark - NSNotificationCenter Obsevers

- (void)setupObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    [[GameKitHelper sharedGamekitHelper] authenticateLocalPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreditsView) name:@"showCreditsView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGameCenter) name:@"showGameCenter" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertWithTextField) name:@"showPopUp" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeaderBoard) name:@"showLeaderBoard" object:nil];
}

@end
