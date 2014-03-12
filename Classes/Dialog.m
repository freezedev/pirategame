//
//  Dialog.m
//  PirateGame
//
//  Created by Johannes Stein on 12/03/14.
//
//

#import "Dialog.h"
#import "Assets.h"

@implementation Dialog

-(id) init
{
    if ((self = [super init])) {
        SPImage *background = [SPImage imageWithTexture:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog"]];
        
        SPButton *buttonYes = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_yes"]                                                                                                                                                     text:@"Yes"];
        
        SPButton *buttonNo = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_no"]                                                                                                                                                     text:@"No"];
        
        buttonYes.x = 24.0f;
        buttonYes.y = background.height - buttonYes.height - 40.0f;
        
        buttonNo.x = buttonYes.x + buttonYes.width - 20.0f;
        buttonNo.y = buttonYes.y;
        
        [self addChild:background];
        [self addChild:buttonYes];
        [self addChild:buttonNo];
    }
    
    return self;
}

@end
