//
//  TextureManager.m
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "TextureManager.h"

@implementation TextureManager

-(SPTexture *) registerTexture:(NSString *)filename
{
    return (SPTexture *) [self registerAsset:filename withContent:[SPTexture textureWithContentsOfFile:filename]];
}

@end
