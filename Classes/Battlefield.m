//
//  Battlefield.m
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "Battlefield.h"
#import "Assets.h"
#import "World.h"
#import "GameOver.h"

#import "SceneDirector.h"

@implementation Battlefield

-(void) setPaused:(BOOL)paused
{
    _paused = paused;
    
    _buttonResume.visible = _paused;
    _buttonPause.visible = !_paused;
    
    _background.touchable = !_paused;
    
    _pirateShip.paused = _paused;
    
    for (int i = 0; i < [_enemyShip count]; i++) {
        ((Ship *) _enemyShip[i]).paused = _paused;
    }
}

-(BOOL) getPaused
{
    return _paused;
}


-(void) onBackgroundTouch:(SPTouchEvent*) event
{
    SPTouch *touch = [[event touchesWithTarget:self] anyObject];
    
    if (touch) {
        [_pirateShip moveToX:touch.globalX andY:touch.globalY];
    }
}

-(void) onShipTap:(SPTouchEvent*) event
{
    SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
    
    if (touch) {
        if (touch.tapCount == 1) {
            [_pirateShip stop];
        } else if (touch.tapCount == 2) {
            [_pirateShip shoot];
        }
    }
}

-(void) onButtonPause:(SPTouchEvent *)event
{
    self.paused = YES;
}

-(void) onButtonResume:(SPTouchEvent *)event
{
    self.paused = NO;
}

-(void) checkShipCollision: (Ship *) ship1 againstShip: (Ship *) ship2
{
    SPRectangle *enemyShipBounds = [ship1 boundsInSpace:self];
    SPRectangle *ball1 = [ship2.cannonBallLeft boundsInSpace:self];
    SPRectangle *ball2 = [ship2.cannonBallRight boundsInSpace:self];
    
    if ([enemyShipBounds intersectsRectangle:ball1] || [enemyShipBounds intersectsRectangle:ball2]) {
        if (ship2.cannonBallLeft.visible || ship2.cannonBallRight.visible) {
            [ship2 abortShooting];
            if (ship1.type == ShipPirate) {
                [ship1 hit: World.damage];
            } else {
                [ship1 hit:[(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"damage"] intValue]];
            }
        }
    }
}

-(void) onEnterFrame:(SPEnterFrameEvent *)event
{
    if (!self.paused) {
        double passedTime = event.passedTime;
        
        int deadCount = 0;
        
        for (int i = 0; i < World.level; i++) {
            [self checkShipCollision:_pirateShip againstShip:_enemyShip[i]];
            [self checkShipCollision:_enemyShip[i] againstShip:_pirateShip];
            
            [_enemyShip[i] advanceTime:passedTime];
            if (((Ship *) _enemyShip[i]).isDead) {
                deadCount++;
            }
        }
        
        if (deadCount == World.level) {
            if (World.level == World.levelMax) {
                [(SceneDirector *) self.director showScene:@"gameover"];
                ((GameOver *) ((SceneDirector *) self.director).currentScene).gameWon = YES;
            } else {
                World.gold = World.gold + (250 * World.level);
                World.level++;
                self.paused = YES;
                [((SceneDirector *) self.director) showScene:@"piratecove"];
            }
        }
        
        
        [_pirateShip advanceTime:passedTime];
        
        [_juggler advanceTime:passedTime];
    }
}

-(void) onDialogAbortYes:(SPEvent *)event
{
    [((SceneDirector *) self.director) showScene:@"piratecove"];
}

-(void) onDialogAbortNo:(SPEvent *)event
{
    self.paused = NO;
    _dialogAbort.visible = NO;
}

-(NSDictionary *) randomPos
{
    return @{
        @"x": [NSNumber numberWithFloat:((arc4random() % (int) (Sparrow.stage.width - 80.0f)) + 40.0f)],
        @"y": [NSNumber numberWithFloat:((arc4random() % (int) (Sparrow.stage.height - 80.0f)) + 40.0f)]
    };
}

-(float) fuzzyValue: (NSString *) value
{
    __block float result = 0.0f;
    
    NSDictionary *fuzzyDict = @{
        @"Very near": ^{
            result = (float) (arc4random() % 40) + 40.0f;
        },
        @"Quite near": ^{
            result = (float) (arc4random() % 30) + 70.0f;
        },
        @"Near": ^{
            result = (float) (arc4random() % 50) + 150.0f;
        }
    };
    
    [fuzzyDict[value] invoke];
    return result;
}

-(void) updateAI: (Ship *)ship withState: (AIState) aiState
{
    switch (aiState) {
        case StateWanderAround: {
            NSDictionary *rndPos = [self randomPos];
            [ship moveToX:[rndPos[@"x"] floatValue] andY:[rndPos[@"y"] floatValue] withBlock:^{
                if ([ship checkDistanceToShip:_pirateShip] < [self fuzzyValue:@"Near"]) {
                    if ([ship checkDistanceToShip:_pirateShip] < [self fuzzyValue:@"Very near"]) {
                        // Attack directly
                        [self updateAI:ship withState:StateAttack];
                    } else {
                        //In sight
                        [self updateAI:ship withState:StateMoveToPlayer];
                    }
                } else {
                    //Not in sight
                    [self updateAI:ship withState:aiState];
                }
            }];
        }
            break;
        case StateMoveToPlayer: {
            [ship moveToShip:_pirateShip WithBlock:^{
                if ([ship checkDistanceToShip:_pirateShip] < [self fuzzyValue:@"Quite near"]) {
                    // Attack
                    [self updateAI:ship withState:StateAttack];
                } else {
                    //Not in sight
                    [self updateAI:ship withState:StateWanderAround];
                }
            }];
        }
            break;
        case StateAttack: {
            [ship shootWithBlock:^{
                [self updateAI:ship withState:StateRecuperate];
            }];
        }
        case StateRecuperate: {
            [ship.juggler delayInvocationByTime:0.3f block:^{
                [self updateAI:ship withState:StateWanderAround];
            }];
        }
        default:
            break;
    }
}

-(id) init
{
    if ((self = [super init])) {
        self.paused = YES;
        _aiState = StateWanderAround;
        
        _background = [SPImage imageWithTexture:[Assets texture:@"water.png"]];
        _background.x = (Sparrow.stage.width - _background.width) / 2;
        _background.y = (Sparrow.stage.height - _background.height) / 2;
        
        _pirateShip = [[Ship alloc] initWithType:ShipPirate];
        
        _enemyShip = [NSMutableArray array];
        for (int i = 0; i < World.levelMax; i++) {
            [_enemyShip addObject:[[Ship alloc] init]];
        }
        
        _buttonPause = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_pause"]];
        _buttonResume = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_play"]];
        
        _buttonPause.x = Sparrow.stage.width - _buttonPause.width - 4.0f;
        _buttonPause.y = 4.0f;
        
        _buttonResume.x = _buttonPause.x;
        _buttonResume.y = _buttonPause.y;
        
        _buttonResume.visible = NO;
        
        SPButton *buttonAbort = [SPButton buttonWithUpState:[[Assets textureAtlas:@"ui.xml"] textureByName:@"button_abort"]];
        buttonAbort.x = Sparrow.stage.width - buttonAbort.width - 4.0f;
        buttonAbort.y = Sparrow.stage.height - buttonAbort.height - 4.0f;
        
        [_buttonPause addEventListener:@selector(onButtonPause:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [_buttonResume addEventListener:@selector(onButtonResume:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        _dialogAbort = [[Dialog alloc] init];
        
        _dialogAbort.title.text = @"Abort this fight?";
        _dialogAbort.content.text = @"Would you like to abort the current fight?";
        
        _dialogAbort.x = (Sparrow.stage.width - _dialogAbort.width) / 2;
        _dialogAbort.y = (Sparrow.stage.height - _dialogAbort.height) / 2;
        
        _dialogAbort.visible = NO;
        
        [_dialogAbort addEventListener:@selector(onDialogAbortYes:) atObject:self forType:EVENT_TYPE_YES_TRIGGERED];
        [_dialogAbort addEventListener:@selector(onDialogAbortNo:) atObject:self forType:EVENT_TYPE_NO_TRIGGERED];
        
        [buttonAbort addEventListenerForType:SP_EVENT_TYPE_TOUCH block:^(SPEvent *event)
        {
            self.paused = YES;
            _dialogAbort.visible = YES;
        }];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        _pirateShip.onDead = ^{
            [(SceneDirector *) weakSelf.director showScene:@"gameover"];
            ((GameOver *) ((SceneDirector *) weakSelf.director).currentScene).gameWon = NO;
        };
        
        [_background addEventListener:@selector(onBackgroundTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [_pirateShip addEventListener:@selector(onShipTap:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        
        [self addChild:_background];
        
        for (int i = 0; i < [_enemyShip count]; i++) {
            ((Ship *) _enemyShip[i]).visible = NO;
            [self addChild:_enemyShip[i]];
        }
        [self addChild:_pirateShip];
        
        [self addChild:_buttonPause];
        [self addChild:_buttonResume];
        [self addChild:buttonAbort];
        
        [self addChild:_dialogAbort];
    }
    
    return self;
}

-(void) reset
{
    self.paused = NO;
    
    _pirateShip.x = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"pirate"][@"x"] floatValue];
    _pirateShip.y = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"pirate"][@"y"] floatValue];
    
    [_pirateShip reset];
    _pirateShip.visible = YES;
    
    for (int i = 0; i < [_enemyShip count]; i++) {
        ((Ship *) _enemyShip[i]).x = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"enemy"][i][@"x"] floatValue];
        ((Ship *) _enemyShip[i]).y = [(NSNumber *) [Assets dictionaryFromJSON:@"gameplay.json"][@"battlefield"][@"enemy"][i][@"y"] floatValue];
        [((Ship *) _enemyShip[i]) reset];
        ((Ship *) _enemyShip[i]).visible = NO;
    }
    
    for (int i = 0; i < World.level; i++) {
        ((Ship *) _enemyShip[i]).visible = YES;
        [self updateAI:_enemyShip[i] withState:_aiState];
    }
}

@end
