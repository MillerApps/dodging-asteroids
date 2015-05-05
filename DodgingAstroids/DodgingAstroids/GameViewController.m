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
@import AVFoundation;



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

@interface GameViewController ()

@property (nonatomic) BOOL isVisable;
@property (nonatomic) ADBannerView *adBanner;

@end

@implementation GameViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
#ifdef DEBUG
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
#endif
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

#pragma mark - iAD

- (void)setUpAds
{
    _adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    _adBanner.delegate = self;
}

- (void)removeAds{
    [_adBanner removeFromSuperview];
    _adBanner = nil;
    _adBanner.delegate = nil;
    _isVisable = NO;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_isVisable && _adBanner != nil) {
        if (_adBanner.superview == nil) {
            [self.view addSubview:_adBanner];
        }
        
        [UIView beginAnimations:@"bannerOn" context:nil];
        
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _isVisable = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Failed to retrieve ad");
    if (_isVisable && _adBanner != nil) {
        [UIView beginAnimations:@"bannerOff" context:nil];
        
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _isVisable = NO;
    }
    
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    
    if (!willLeave) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pause" object:nil];
        
        
        
    }
    
    return YES;
    
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unPause" object:nil];
    
    
    
}


#pragma mark - NSNotifcationCenter Selectors

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:PresentAuthenticationViewController]) {
        GameKitHelper *gameKitHelper = [GameKitHelper sharedGamekitHelper];
        
        [self presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
        
    } else if ([notification.name isEqualToString:@"showCreditsView"]) {
        
        [self performSegueWithIdentifier:@"showCredits" sender:self];
        
    } else if ([notification.name isEqualToString:@"showGameCenter"]) {
        
        [[GameKitHelper sharedGamekitHelper] showGKGameCenterViewController:self];
        
    } else if ([notification.name isEqualToString:@"setUpAds"]) {
        
        
        [self setUpAds];
        
        
    } else if ([notification.name isEqualToString:@"removeAds"]) {
        
        [self removeAds];
        
    } else if ([notification.name isEqualToString:@"hideAd"]) {
        
        [UIView beginAnimations:@"bannerOff" context:nil];
        
        _adBanner.frame = CGRectOffset(_adBanner.frame, 0, _adBanner.frame.size.height);
        
        [UIView commitAnimations];
        
        
    } else if ([notification.name isEqualToString:@"showAd"]) {
        
        [UIView beginAnimations:@"bannerOn" context:nil];
        
        _adBanner.frame = CGRectOffset(_adBanner.frame, 0, -_adBanner.frame.size.height);
        
        [UIView commitAnimations];
        
    }
}

#pragma mark - NSNotificationCenter Obsevers

- (void)setupObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:PresentAuthenticationViewController object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showCreditsView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showGameCenter" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"setUpAds" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"removeAds" object:nil];
}

@end
