//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"

typedef void (^ResponseBlock)(NSDictionary *dictResponse, NSError *error);

@interface WebService : NSObject

+ (WebService *) sharedInstance;

//RSS feeds from iTune

- (void) fetchRSSFeedFromiTune:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;

- (void) searchSongsFromiTune:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;

- (void) registerUserDetailWithData:(NSDictionary *)dictPostData completionBlock:(ResponseBlock)block;


- (void) uploadMargeDualVideo:(NSDictionary *)dictPostData completionBlock:(ResponseBlock)block;

- (void) uploadMargeDualImage:(NSDictionary *)dictPostData capturedImage:(UIImage *)img completionBlock:(ResponseBlock)block;

- (void) getShortenUrl:(NSDictionary *)dictPostData completionBlock:(ResponseBlock)block;

- (void) callPostMethodForImageUpload:(NSDictionary *)dictPostData withImage:(UIImage *)imgUpload  withUrl:(NSString *)sUrl completionBlock:(ResponseBlock)block;

//- (void) getMediaFromServer:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;
- (void) getMediaFromServer:(NSDictionary *)requestDictionary withType:(int)iMediaType completionBlock:(ResponseBlock)block;

- (void) getMediaCommentsFromServer:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;

- (void) submitCommentForMedia:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;

- (void)addMediaInFavoriteList:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;
- (void)sendInAppPurchaseInfoToServer:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;
- (void)deleteSelectedMedia:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;
- (void)reportSelectedMedia:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block;
@end
