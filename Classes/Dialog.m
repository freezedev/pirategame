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
        
        _buttonYes = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_yes"]                                                                                                                                                     text:@"Yes"];
        
        _buttonNo = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_no"]                                                                                                                                                     text:@"No"];
        
        _buttonYes.x = 24.0f;
        _buttonYes.y = background.height - _buttonYes.height - 40.0f;
        
        _buttonNo.x = _buttonYes.x + _buttonYes.width - 20.0f;
        _buttonNo.y = _buttonYes.y;
        
        _content = [SPTextField textFieldWithWidth:background.width - 96.0f height:background.height - 150.0f text:@"Dialog default text"];
        _content.x = 52.0f;
        _content.y = 66.0f;
        
        _title = [SPTextField textFieldWithWidth:background.width * 0.6 height:30.0f text:@"Dialog"];
        _title.fontName = @"PirateFont";
        _title.color = SP_WHITE;
        
        _title.x = 36.0f;
        _title.y = 26.0f;
        
        [_buttonYes addEventListener:@selector(onButtonYes:) atObject:self
                            forType:SP_EVENT_TYPE_TRIGGERED];
        
        [_buttonNo addEventListener:@selector(onButtonNo:) atObject:self
                           forType:SP_EVENT_TYPE_TRIGGERED];
        
        [self addChild:background];
        [self addChild:_buttonYes];
        [self addChild:_buttonNo];
        [self addChild:_content];
        [self addChild:_title];
    }
    
    return self;
}

- (void)onButtonYes:(SPEvent *)event
{
    self.visible = NO;
    SPEvent *localEvent = [SPEvent eventWithType:EVENT_TYPE_YES_TRIGGERED];
    [self dispatchEvent:localEvent];
}

- (void)onButtonNo:(SPEvent *)event
{
    self.visible = NO;
    SPEvent *localEvent = [SPEvent eventWithType:EVENT_TYPE_NO_TRIGGERED];
    [self dispatchEvent:localEvent];
}

@end
