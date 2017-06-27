//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by X S on 03/03/17.
//  Copyright © 2017 XS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtility : NSObject {
    
}

// Folder methods
+ (NSString*)basePath;
+ (NSString*)cachePath;
+ (void)createDirectoryIfNeededAtPath:(NSString*)path;
+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension;
+ (NSString *)pathForDocResource:(NSString *)filename;
+ (void)createFolderInDocuments:(NSString*)folder;

+ (void) createFolderInCache:(NSString *)folder;
+ (NSString *)pathForCacheResource:(NSString *)filename;

// File methods
+ (BOOL)deleteFile:(NSString*)filename;
+ (BOOL)fileExists:(NSString *)filename;
+ (void)createFile:(NSString *)filename;

+ (NSArray *) contentAtDirectoryPath:(NSString *)filePath;

+ (NSString *) getDBPath;
@end
