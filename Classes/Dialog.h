//
//  Dialog.h
//  PirateGame
//
//  Created by Johannes Stein on 12/03/14.
//
//

#import "SPSprite.h"

#define EVENT_TYPE_YES_TRIGGERED @"yesTriggered"
#define EVENT_TYPE_NO_TRIGGERED  @"noTriggered"

@interface Dialog : SPSprite {

}

@property SPTextField *content;

@end
