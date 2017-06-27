//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

#import "FileUtility.h"

@implementation FileUtility

// ----------------------------------------------------------------------------

#pragma mark - Path methods

// -----------------------------------------------------------------------------

+ (NSString*) basePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//NSAssert([paths count] == 1, @"");
    if(paths.count>0){
       return [paths objectAtIndex:0];
    }
    return nil;
}

// -----------------------------------------------------------------------------

+ (NSString*) cachePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	//NSAssert([paths count] == 1, @"");
    if(paths.count>0){
	return [paths objectAtIndex:0];
    }

        return nil;

}

// -----------------------------------------------------------------------------

+ (void) createDirectoryIfNeededAtPath:(NSString*)path {
	NSFileManager* fileManager = [NSFileManager defaultManager];
	//DLOG(@"path=%@", path);
	NSError *error = nil;
	if (![fileManager fileExistsAtPath:path]) {
		[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
	}
}

// -----------------------------------------------------------------------------

+ (void) createFolderInDocuments:(NSString*)folder {
	NSString* path = [NSString stringWithFormat:@"%@/%@", [FileUtility basePath], folder];
	[FileUtility createDirectoryIfNeededAtPath:path];
}

// -----------------------------------------------------------------------------

+ (NSArray *) getFilesInDirectory:(NSString *)directoryPath {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *filelist;
    NSInteger count;
    NSInteger i;
    filelist = [filemgr contentsOfDirectoryAtPath: directoryPath error: nil];
    count = [filelist count];
    for (i = 0; i < count; i++){
        NSLog (@"%@", [filelist objectAtIndex: i]);
    }
    return filelist;
    
}

// -----------------------------------------------------------------------------

#pragma mark -  File Methods

//-----------------------------------------------------------------------

+ (void) deleteFile:(NSString*)filename {
	NSFileManager* manager = [NSFileManager defaultManager];
	NSError* error = nil;
	if (![manager removeItemAtPath:filename error:&error]) {
	}	
}

// -----------------------------------------------------------------------------

+ (NSString *) pathForResource:(NSString *)name ofType:(NSString *)extension {
	NSString* result = nil;
	//@autoreleasepool {
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    if (path == nil) {
        return nil;
    }
    result = [NSString stringWithFormat:@"%@",path];
    //__autoreleasing NSString * result = [[NSString alloc] initWithString:path];
    return result;
    //}
}

// -----------------------------------------------------------------------------

+ (NSString *) pathForDocResource:(NSString *)filename {
	//__autoreleasing
    NSString* result = nil;
	//@autoreleasepool {
    NSString * filePath = [NSString stringWithFormat:@"%@/%@", [FileUtility basePath],filename];
    if (filePath == nil) {
        return nil;
    }
    result = [NSString stringWithFormat:@"%@",filePath];
    //result = [[NSString alloc] initWithString:filePath];
    filePath = nil;
    return result;
    //}
}
    

// -----------------------------------------------------------------------------

+ (BOOL)fileExists:(NSString *)filename {
	NSFileManager* manager = [NSFileManager defaultManager];
	return [manager fileExistsAtPath:filename];
}

// -----------------------------------------------------------------------------

+ (void) createFile:(NSString *)filename {
	NSFileManager* manager = [NSFileManager defaultManager];
	NSString * filePath = [NSString stringWithFormat:@"%@/%@.xml", [FileUtility basePath],filename];
	if (![FileUtility fileExists:filePath]){
		[manager createFileAtPath:filePath contents:nil attributes:nil];
	}else {
		
	}
}

// -----------------------------------------------------------------------------

+ (BOOL) copyFileAtPath:(NSString *)srcFilePath toDestinationAtPath:(NSString *)destFilePath {
    NSFileManager *filemgr = [NSFileManager defaultManager];
        if (![self fileExists:destFilePath]) {
            if ([filemgr copyItemAtPath:srcFilePath toPath:destFilePath error: NULL]  == YES){
                 NSLog (@"Copy successful");
            }else{
                NSLog (@"Copy failed");
                return NO;
            }
        }
        else {
            NSLog (@"File already exist.");
            return NO;
        }
    return YES;        
}

//---------------------------------------------------------

+ (CGFloat) getFileSize:(NSString *)filePath {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [filemgr attributesOfItemAtPath: filePath error: NULL];
    CGFloat fileSize = 0;
    if (fileAttributes != nil) {
        fileSize = [[fileAttributes objectForKey:NSFileSize] floatValue];
    }
    else {
        NSLog(@"Path (%@) is invalid.", filePath);
    }
    return fileSize;
}

//---------------------------------------------------------

@end
