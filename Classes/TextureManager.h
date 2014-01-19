//
//  TextureManager.h
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "AssetsDictionary.h"

@interface TextureManager : AssetsDictionary

-(SPTexture *) registerTexture:(NSString *) filename;

@end
