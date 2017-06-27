//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FileUtility;
@interface FileUtility : NSObject {
}



// Folder methods
+ (NSString*)basePath;
+ (NSString*)cachePath;
+ (void)createDirectoryIfNeededAtPath:(NSString*)path;
+ (NSString *)pathForResource:(NSString *)name ofType:(NSString *)extension;
+ (NSString *)pathForDocResource:(NSString *)filename;
+ (void)createFolderInDocuments:(NSString*)folder;
+ (NSArray *)getFilesInDirectory:(NSString *)directoryPath;

// File methods
+ (void)deleteFile:(NSString*)filename;

+ (BOOL)fileExists:(NSString *)filename;
+ (void)createFile:(NSString *)filename;
+ (CGFloat)getFileSize:(NSString *)filename;
+ (BOOL)copyFileAtPath:(NSString *)srcFilePath toDestinationAtPath:(NSString *)destFilePath;

@end
