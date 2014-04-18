//
//  AppScaffoldAppDelegate.m
//  AppScaffold
//

#import "AppDelegate.h"
#import "Game.h"
#import "World.h"

#import <UbertestersSDK/Ubertesters.h>
#import <GameKit/GameKit.h>

@implementation AppDelegate
{
    SPViewController *_viewController;
    UIWindow *_window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    _window = [[UIWindow alloc] initWithFrame:screenBounds];
    
    _viewController = [[SPViewController alloc] init];
    
    // Enable some common settings here:
    //
    // _viewController.showStats = YES;
    // _viewController.multitouchEnabled = YES;
    // _viewController.preferredFramesPerSecond = 60;
    
    [Ubertesters initialize];
    
    [_viewController startWithRoot:[Game class] supportHighResolutions:YES doubleOnPad:YES];
    
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if ([GKLocalPlayer localPlayer].authenticated) {
            NSLog(@"Already authenticated");
        } else if(viewController) {
            [[Sparrow currentController] presentViewController:viewController animated:YES completion:nil];//present the login form
        } else {
            NSLog(@"Problem while authenticating");
        } 
    };
    
    [_window setRootViewController:_viewController];
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActiveNotification:(NSNotification*)notification
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[World serialize] forKey:@"game"];
    [userDefaults synchronize];
}


@end
