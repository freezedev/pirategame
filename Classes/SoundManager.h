//
//  SoundManager.h
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "AssetsDictionary.h"

@interface SoundManager : AssetsDictionary

-(SPSound *) registerSound:(NSString *)filename;

@end