//
//  Battlefield.h
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "Scene.h"
#import "Ship.h"
#import "Dialog.h"

typedef NS_ENUM(NSInteger, AIState) {
    StateWanderAround,
    StateMoveToPlayer,
    StateAttack,
    StateRecuperate
};

@interface Battlefield : Scene {
    Ship *_pirateShip;
    NSMutableArray *_enemyShip;
    
    SPImage *_background;
    
    SPButton *_buttonPause;
    SPButton *_buttonResume;
    
    SPJuggler *_juggler;
    
    Dialog *_dialogAbort;
    
    AIState _aiState;
    
    BOOL _paused;
}

@property (nonatomic) BOOL paused;

@end
