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
        
        _content = [SPTextField textFieldWithWidth:background.width - 48.0f height:background.height - 150.0f text:@"Dialog default text"];
        _content.x = 24.0f;
        _content.y = 50.0f;
        
        [buttonYes addEventListener:@selector(onButtonYes:) atObject:self
                            forType:SP_EVENT_TYPE_TRIGGERED];
        
        [buttonNo addEventListener:@selector(onButtonNo:) atObject:self
                           forType:SP_EVENT_TYPE_TRIGGERED];
        
        [self addChild:background];
        [self addChild:buttonYes];
        [self addChild:buttonNo];
        [self addChild:_content];
    }
    
    return self;
}

- (void)onButtonYes:(SPEvent *)event
{
    SPEvent *localEvent = [SPEvent eventWithType:EVENT_TYPE_YES_TRIGGERED];
    [self dispatchEvent:localEvent];
}

- (void)onButtonNo:(SPEvent *)event
{
    SPEvent *localEvent = [SPEvent eventWithType:EVENT_TYPE_NO_TRIGGERED];
    [self dispatchEvent:localEvent];
}

@end
