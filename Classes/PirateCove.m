//
//  PirateCove.m
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "PirateCove.h"
#import "Assets.h"
#import "Dialog.h"
#import "World.h"
#import "SceneDirector.h"
#import "World.h"

@implementation PirateCove

-(id) init
{
    if ((self = [super init])) {
        SPSound *sound = [Assets sound:@"music_cove.aifc"];
        backgroundMusic = [sound createChannel];
        backgroundMusic.loop = YES;
        
        
        SPImage *background = [SPImage imageWithTexture:[Assets texture:@"cove.png"]];
        background.x = (Sparrow.stage.width - background.width) / 2;
        background.y = (Sparrow.stage.height - background.height) / 2;
        
        SPImage *pirateShip = [SPImage imageWithTexture:[Assets texture:@"ship_pirate.png"]];
        pirateShip.x = Sparrow.stage.width - pirateShip.width - 120;
        pirateShip.y = Sparrow.stage.height - pirateShip.height - 10;
        
        SPImage *house = [SPImage imageWithTexture:[Assets texture:@"house.png"]];
        house.x = 100;
        house.y = 100;
        
        SPImage *tavern = [SPImage imageWithTexture:[Assets texture:@"tavern.png"]];
        tavern.x = 220;
        tavern.y = 40;
        
        SPImage *weaponsmith = [SPImage imageWithTexture:[Assets texture:@"weaponsmith.png"]];
        weaponsmith.x = 350;
        weaponsmith.y = 130;
        
        _dialogUpdateDamage = [[Dialog alloc] init];
        
        _dialogUpdateDamage.title.text = @"Update damage?";
        
        _dialogUpdateDamage.x = (Sparrow.stage.width - _dialogUpdateDamage.width) / 2;
        _dialogUpdateDamage.y = (Sparrow.stage.height - _dialogUpdateDamage.height) / 2;
        
        _dialogUpdateDamage.visible = NO;
        
        [weaponsmith addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(SPEvent *event){
            if (World.gold < _goldDamage) {
                _dialogUpdateDamage.buttonYes.enabled = NO;
            }
            
            _dialogUpdateDamage.visible = YES;
        }];
        
        [_dialogUpdateDamage addEventListener:@selector(onUpdateDamage:) atObject:self forType:EVENT_TYPE_YES_TRIGGERED];
        
        
        _dialogUpdateHitpoints = [[Dialog alloc] init];
        
        _dialogUpdateHitpoints.title.text = @"Update hitpoints?";
        
        _dialogUpdateHitpoints.x = (Sparrow.stage.width - _dialogUpdateDamage.width) / 2;
        _dialogUpdateHitpoints.y = (Sparrow.stage.height - _dialogUpdateDamage.height) / 2;
        
        _dialogUpdateHitpoints.visible = NO;
        
        [tavern addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(SPEvent *event){
            if (World.gold < _goldHitpoints) {
                _dialogUpdateHitpoints.buttonYes.enabled = NO;
            }
            
            _dialogUpdateHitpoints.visible = YES;
        }];
        
        [_dialogUpdateHitpoints addEventListener:@selector(onUpdateHitpoints:) atObject:self forType:EVENT_TYPE_YES_TRIGGERED];
        
        
        SPButton *buttonBattle = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"dialog_yes"]                                                                                                                                                     text:@"Begin battle"];
        
        buttonBattle.y = Sparrow.stage.height - buttonBattle.height - 8.0f;
        buttonBattle.x = (Sparrow.stage.width - buttonBattle.width) / 2;
        
        [buttonBattle addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(SPEvent *event){
            [((SceneDirector *) self.director) showScene:@"battlefield"];
        }];
        
        _goldTextField = [SPTextField textFieldWithWidth:Sparrow.stage.width - 16.0f height:30.0f text:@"Gold"];
        _goldTextField.fontName = @"PirateFont";
        _goldTextField.color = SP_WHITE;
        
        _goldTextField.x = 8.0f;
        _goldTextField.y = 8.0f;
        
        [self addChild:background];
        [self addChild:pirateShip];
        [self addChild:house];
        [self addChild:tavern];
        [self addChild:weaponsmith];
        [self addChild:buttonBattle];
        [self addChild:weaponsmith];
        
        [self addChild:_dialogUpdateDamage];
        [self addChild:_dialogUpdateHitpoints];
        [self addChild:_goldTextField];
    }
    
    return self;
}

-(void) onUpdateDamage: (SPEvent *) event
{
    World.damage = World.damage + (int) (World.damage / 10);
    World.gold = World.gold - _goldDamage;
    [self updateGoldTextField];
}

-(void) onUpdateHitpoints: (SPEvent *) event
{
    World.hitpoints = World.hitpoints + (int) (World.hitpoints / 5);
    World.gold = World.gold - _goldHitpoints;
    [self updateGoldTextField];
}

-(void) updateGoldTextField
{
    _goldTextField.text = [NSString stringWithFormat:@"Gold: %d", World.gold];
}

-(void) reset
{
    [backgroundMusic play];
    
    _goldDamage = (150 + (50 * (World.level - 1)));
    _dialogUpdateDamage.content.text = [NSString stringWithFormat:@"Increasing damage costs %d gold. Do you wish to proceed?", _goldDamage];
    
    _goldHitpoints = (200 + (75 * (World.level - 1)));
    _dialogUpdateHitpoints.content.text = [NSString stringWithFormat:@"Increasing hitpoints costs %d gold. Do you wish to proceed?", _goldHitpoints];
    
    [self updateGoldTextField];
}

-(void) stop
{
    [backgroundMusic stop];
}

@end
