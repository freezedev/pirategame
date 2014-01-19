//
//  FileManager.m
//  PirateGame
//
//  Created by Johannes Stein on 06/01/14.
//
//

#import "FileManager.h"

@implementation FileManager

-(NSString *) registerPlainText:(NSString *)filename
{
	if ([_dict valueForKey:filename] == nil) {
		NSString *path = [[NSBundle mainBundle] pathForResource:filename];
		NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		
		return (NSString *) [self registerAsset:filename withContent:content];
	} else {
		return (NSString *) [self registerAsset:filename withContent:nil];
	}
}

-(NSDictionary *) registerDictionaryFromJSON:(NSString *)filename
{
	if ([_dict valueForKey:filename] == nil) {
		NSString *path = [[NSBundle mainBundle] pathForResource:filename];
		
		NSData *data = [NSData dataWithContentsOfFile:path];
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
		
		return (NSDictionary *) [self registerAsset:filename withContent:dict];
	} else {
		return (NSDictionary *) [self registerAsset:filename withContent:nil];
	}
}

@end
