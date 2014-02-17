//
//  Assets.m
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "Assets.h"
#import "TextureManager.h"
#import "SoundManager.h"
#import "FileManager.h"

static TextureManager *textureAssets = nil;
static SoundManager *soundAssets = nil;
static FileManager *fileAssets = nil;

@implementation Assets

+(void) initialize
{
    if (!textureAssets) {
        textureAssets = [[TextureManager alloc] init];
    }
    
    if (!soundAssets) {
        soundAssets = [[SoundManager alloc] init];
    }
    
    if (!fileAssets) {
        fileAssets = [[FileManager alloc] init];
    }
}

+(SPTexture *) texture:(NSString *)filename
{
    return [textureAssets registerTexture:filename];
}

+(SPTextureAtlas *) textureAtlas:(NSString*)filename
{
    return [textureAssets registerTextureAtlas:filename];
}

+(SPSound *) sound:(NSString *)filename
{
    return [soundAssets registerSound:filename];
}

+(NSString *) plainText:(NSString *)filename
{
    return [fileAssets registerPlainText:filename];
}

+(NSDictionary *) dictionaryFromJSON:(NSString *)filename
{
    return [fileAssets registerDictionaryFromJSON:filename];
}

@end
