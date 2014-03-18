//
//  PirateCove.h
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "Scene.h"
#import "Dialog.h"

@interface PirateCove : Scene {
    Dialog *_dialogUpdateDamage;
    Dialog *_dialogUpdateHitpoints;
    
    SPTextField *_goldTextField;
    
    int _goldDamage;
    int _goldHitpoints;
}

@end
