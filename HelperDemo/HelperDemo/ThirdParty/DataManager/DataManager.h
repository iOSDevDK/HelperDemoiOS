//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by X S on 03/03/17.
//  Copyright © 2017 XS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <FMDB/FMDB.h>

#import "FileUtility.h"

typedef void(^DataManagerBlock)(NSArray *arrResult,BOOL success);

@interface DataManager : NSObject {
	FMDatabaseQueue *_queue;
    sqlite3 *database;
    FMDatabase * db1;
}

+ (DataManager *)sharedManager;

- (void) getFavoriteMovie:(NSString *)strMovieId CompletionBlock:(DataManagerBlock)block;
- (void) addFavoriteMovie:(NSDictionary *)dictData withMovieId:(NSString *)strMovieId isUpdate:(BOOL)isUpdate CompletionBlock:(DataManagerBlock)block;
- (void) removeFavoriteMovie:(NSString *)strMovieId;
- (BOOL) isFavoriteMovieAlreadyAdded:(NSString *)strMovieId;
- (NSArray*) getFavoriteMoviesList:(NSString *)strMovieId;




@end
