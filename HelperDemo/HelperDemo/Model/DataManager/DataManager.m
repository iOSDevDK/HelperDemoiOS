//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//


#import "DataManager.h"


static DataManager *sharedDB;

@implementation DataManager

//-------------------------------------------------------------------------------

#pragma mark
#pragma mark  Shared Method

//-------------------------------------------------------------------------------

+ (DataManager *)sharedManager {
    @synchronized(self) {
        if (!sharedDB)
            sharedDB = [[DataManager alloc] init];
    }
    return sharedDB;
}

// ------------------------------------------------------------------------------------

- (void) initFMDB {
    [db1 close];
    if(db1 == nil){
        db1 = [[FMDatabase alloc]initWithPath:[self getDBPath]];
    }
    [db1 setLogsErrors:TRUE];
}

// ------------------------------------------------------------------------------------

- (void)getFavoriteMovie:(NSString *)strMovieId CompletionBlock:(DataManagerBlock)block {
    FMDatabaseQueue *queue = [self getQueue];
    __block NSMutableArray *arrTemp = [NSMutableArray array];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *strQuery = [NSString stringWithFormat:@"select * from %@ where %@ = %@",@"",@"",@""];
        
        NSLog(@"Query For Get profile details : %@ ",strQuery);
        FMResultSet *rs = [db executeQuery:strQuery];
        NSLog(@"Last Query Error : %@ ",db.lastErrorMessage);
        while ([rs next]) {
            NSDictionary *dictData = @{
                                       @"":@"",
                                       @"":@""
                                       };
            [arrTemp addObject:dictData];
            dictData = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *arrProfileDetails = [NSArray arrayWithArray:(NSArray*)arrTemp];
            arrTemp = nil;
            block(arrProfileDetails, YES);
        });
        
    }];
}

- (void)addFavoriteMovie:(NSDictionary *)dictData withMovieId:(NSString *)strMovieId isUpdate:(BOOL)isUpdate CompletionBlock:(DataManagerBlock)block {
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabaseQueue *queue = [self getQueue];
    __block BOOL success = NO;
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSLog(@"%d",[strMovieId intValue]);
        
        NSString *strVetClinicName = [self replaceOccurenaceOfSingleQuote:[dictData valueForKey:@""]];
        NSString *strVetDrName = [self replaceOccurenaceOfSingleQuote:[dictData valueForKey:@""]];
        
        int userId = [[[NSUserDefaults standardUserDefaults] valueForKey:@""] intValue];
        if ([dictData valueForKey:@""]) {
            if ([(NSString *)[dictData valueForKey:@""] length] > 0) {
                userId = [[dictData valueForKey:@""] intValue];
            }
        }
        
        NSString *strQuery = @"";
        
        if (isUpdate) {
            strQuery = [NSString stringWithFormat:@"update %@ set %@ = '%@' , %@ = '%@' ",@"TableName",@"columnName",strVetClinicName,@"columnName",strVetDrName];
            
        } else {
            strQuery = [NSString stringWithFormat:@"insert into %@(%@,%@) values('%@','%@')",@"TableName",@"columnName",@"columnName",strVetClinicName,strVetDrName];
        }
        
        NSLog(@"Query For Vet Details : %@ ",strQuery);
        success = [db executeUpdate:strQuery];
        NSLog(@"Last Query Error : %@ ",db.lastErrorMessage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(nil, success);
        });
    }];
    
    //        [queue close];
    //    });
    
}

- (BOOL)isFavoriteMovieAlreadyAdded:(NSString *)strMovieId {
    FMDatabaseQueue *queue = [self getQueue];
    __block BOOL added = NO;
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * query =  [NSString stringWithFormat:@"select * from %@ where %@ = %@", @"TableName",@"columnName",@"strMovieId"];
        NSLog(@"isAlreadyAddedAllergy Query :\n%@",query);
        FMResultSet * rs = [db executeQuery:query];
        while ([rs next]) {
            added = YES;
        }
    }];
    
    return added;
}

- (void)removeFavoriteMovie:(NSString *)strMovieId {
    FMDatabaseQueue *queue = [self getQueue];
    __block BOOL success = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *strQuery = [NSString stringWithFormat:@"delete from %@ where %@ = %@",@"TableName",@"columnName",strMovieId];
        
        NSLog(@"Query For Pet Allergies details : %@ ",strQuery);
        success = [db executeUpdate:strQuery];
        NSLog(@"Last Query Error : %@ ",db.lastErrorMessage);
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
    
}

//-----------------------------------------------------------------------

- (NSArray *)getFavoriteMoviesList:(NSString *)strMovieId {
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    FMDatabaseQueue *queue = [self getQueue];
    __block NSMutableArray *arrTemp = [NSMutableArray array];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *strQuery = [NSString stringWithFormat:@"select * from %@ where %@ = %@",@"TableName",@"columnName",strMovieId];
        if ([strMovieId isEqualToString:@""]) {
            strQuery = [NSString stringWithFormat:@"select * from %@ where %@ = %@ ",@"TableName",@"columnName",strMovieId];
        }
        
        NSLog(@"Query For Get pet details : %@ ",strQuery);
        FMResultSet *rs = [db executeQuery:strQuery];
        NSLog(@"Last Query Error : %@ ",db.lastErrorMessage);
        while ([rs next]) {
            NSDictionary *dictData = @{
                                       @"columnName":@"value",
                                       @"columnName":@"value"
                                       };
            [arrTemp addObject:dictData];
            dictData = nil;
        }
        
        
    }];
    
    //    [queue close];
    NSArray *arrPetDetails = [NSArray arrayWithArray:(NSArray*)arrTemp];
    arrTemp = nil;
    return arrPetDetails;
    
}


//-----------------------------------------------------------------------

- (NSString *) convertUTCTimeToLocalTime:(NSString *)strUtcTime {
    
    // NSTimeZone *outputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    // [inputDateFormatter setTimeZone:outputTimeZone];
    [inputDateFormatter setDateFormat:@""];
    NSDate *localDate = [inputDateFormatter dateFromString:strUtcTime];
    
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [localDate dateByAddingTimeInterval:timeZoneSeconds];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@""];
    NSString *strDateInLocal = [outputDateFormatter stringFromDate:dateInLocalTimezone];
    
    return strDateInLocal;
}

//-------------------------------------------------------------------------------

#pragma mark
#pragma mark  Custom Methods

//-------------------------------------------------------------------------------

- (NSString *) getDBPath {
    NSString *documentsDir = [FileUtility basePath];
    return [documentsDir stringByAppendingPathComponent:@""];
}

//-------------------------------------------------------------------------------

- (FMDatabaseQueue *)getQueue {
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self getDBPath]];
    }
    return _queue;
}

//-------------------------------------------------------------------------------

- (BOOL)openDatabse {
    NSString *pDbPath = [self getDBPath];
    if (sqlite3_open([pDbPath UTF8String], &database)!=SQLITE_OK) {
        sqlite3_close(database);
        return NO;
    }else {
        return YES;
    }
}

//-----------------------------------------------------------------------

- (NSString *) replaceOccurenaceOfSingleQuote:(NSString*)strVal {
    strVal = [strVal stringByReplacingOccurrencesOfString:@"\\'" withString:@"\'"];
    strVal=[strVal stringByReplacingOccurrencesOfString:@"\'" withString:@"''"];
    return strVal;
}

//-------------------------------------------------------------------------------
/*
 - (NSString *) checkForNull:(NSString *)strVal {
 if ([[strVal class] isSubclassOfClass:[NSNull class]]) {
 return @"";
 }
 if (!strVal || [allTrim(strVal) length] == 0 || [strVal isEqual:[NSNull null]] || [strVal isEqualToString:@"(null)"] || [strVal isEqualToString:@"<null>"]) {
 return @"";
 }
 return allTrim(strVal);
 }
 */
@end
