//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by X S on 03/03/17.
//  Copyright © 2017 XS. All rights reserved.
//

#import "FileUtility.h"

@implementation FileUtility

// ----------------------------------------------------------------------------

#pragma mark
#pragma mark - Path methods

// -----------------------------------------------------------------------------

+ (NSString*)basePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSAssert([paths count] == 1, @"");
	return [paths objectAtIndex:0];		
}

// -----------------------------------------------------------------------------

+ (NSString*)cachePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSAssert([paths count] == 1, @"");
	return [paths objectAtIndex:0];		
}

// -----------------------------------------------------------------------------

+ (void)createDirectoryIfNeededAtPath:(NSString*)path {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	if (![fileManager fileExistsAtPath:path]) {
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	}
}

// -----------------------------------------------------------------------------

+ (void)createFolderInDocuments:(NSString*)folder {
	NSString* path = [NSString stringWithFormat:@"%@/%@", [FileUtility basePath], folder];
	[FileUtility createDirectoryIfNeededAtPath:path];
}

//-------------------------------------------------------------------------------

+ (void) createFolderInCache:(NSString *)folder {
    NSString* path = [NSString stringWithFormat:@"%@/%@", [FileUtility cachePath], folder];
	[FileUtility createDirectoryIfNeededAtPath:path];
}

//-------------------------------------------------------------------------------

+ (NSString *)pathForCacheResource:(NSString *)filename {
    NSString* result = nil;
    NSString * filePath = [NSString stringWithFormat:@"%@/%@", [FileUtility cachePath],filename];
    if (filePath == nil) {
        return nil;
    }
    result = [NSString stringWithFormat:@"%@",filePath];
    filePath = nil;
    return result;
}

// -----------------------------------------------------------------------------

#pragma mark
#pragma mark - File methods

//-------------------------------------------------------------------------------

+ (BOOL)deleteFile:(NSString*)filename {
	NSFileManager* manager = [NSFileManager defaultManager];
	NSError* error = nil;
    if ([ FileUtility fileExists:filename]) {
        return [manager removeItemAtPath:filename error:&error];
    }
    return YES;
}

// -----------------------------------------------------------------------------

+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension {
	NSString* result = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    if (path == nil) {
        return nil;
    }
    result = [NSString stringWithFormat:@"%@",path];
    return result;
}

// -----------------------------------------------------------------------------

+ (NSString *)pathForDocResource:(NSString *)filename {

    NSString* result = nil;
    NSString * filePath = [NSString stringWithFormat:@"%@/%@", [FileUtility basePath],filename];
    if (filePath == nil) {
        return nil;
    }
    result = [NSString stringWithFormat:@"%@",filePath];
    filePath = nil;
    return result;
}

// -----------------------------------------------------------------------------

+ (BOOL)fileExists:(NSString *)filename {
	NSFileManager* manager = [NSFileManager defaultManager];
	return [manager fileExistsAtPath:filename];
}

// -----------------------------------------------------------------------------

+ (void)createFile:(NSString *)filename {
	NSFileManager* manager = [NSFileManager defaultManager];
	NSString * filePath = [NSString stringWithFormat:@"%@/%@", [FileUtility basePath],filename];
	if (![FileUtility fileExists:filePath]){
		[manager createFileAtPath:filePath contents:nil attributes:nil];
	}
}

//-------------------------------------------------------------------------------

+ (NSArray *) contentAtDirectoryPath:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    return  [manager contentsOfDirectoryAtPath:filePath error:nil];
}

// -----------------------------------------------------------------------------

+ (NSString *) getDBPath {
	NSString *documentsDir = [FileUtility basePath];
	return [documentsDir stringByAppendingPathComponent:@""];
}

//-----------------------------------------------------------------------

@end
