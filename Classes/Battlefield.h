//
//  Battlefield.h
//  PirateGame
//
//  Created by Johannes Stein on 20/01/14.
//
//

#import "Scene.h"
#import "Ship.h"

@interface Battlefield : Scene {
    Ship *_pirateShip;
    Ship *_enemyShip;
    
    SPImage *_background;
    
    SPButton *_buttonPause;
    SPButton *_buttonResume;
}

@end
