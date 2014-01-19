//
//  FileManager.h
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "AssetsDictionary.h"

@interface FileManager : AssetsDictionary

-(NSString *) registerPlainText:(NSString *)filename;
-(NSDictionary *) registerDictionaryFromJSON:(NSString *)filename;

@end
