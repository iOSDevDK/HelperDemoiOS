//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

#import "WebService.h"
//#import "AFHTTPRequestOperationManager.h"
#import "UAProgressView.h"

static WebService *sharedWS;

@implementation WebService

//-------------------------------------------------------------------------------

#pragma mark
#pragma mark  Shared Methods

//-------------------------------------------------------------------------------

+ (WebService *) sharedInstance {
    @synchronized(self) {
        if (!sharedWS)
            sharedWS = [[WebService alloc] init];
    }
    return sharedWS;
}

//-------------------------------------------------------------------------------

#pragma mark
#pragma mark  WS Calling Method

//-------------------------------------------------------------------------------

- (void) callPostMethod:(NSDictionary *)dictPostData  withUrl:(NSString *)sUrl completionBlock:(ResponseBlock)block {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * strUrl = [sUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictPostData  options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        DLOG(@"Post Data : %@",jsonString);
    
    
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        DLOG(@"URL : %@ ",strUrl);
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:strUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            // Append webdata as form data
            [formData appendPartWithFormData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] name:kWebData];
            
        } success:^(AFHTTPRequestOperation *operation, NSDictionary *dictResponse) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DLOG(@"Response Object : %@ ",dictResponse);
                block(dictResponse,nil);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DLOG(@"Error  : %@ ",error.localizedDescription);
                block(nil,error);
            });
        }];
   // });
}

//-----------------------------------------------------------------------

- (void) callJsonPostMethod:(NSDictionary *)dictPostData  withUrl:(NSString *)sUrl completionBlock:(ResponseBlock)block {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    DLOG(@"serverUrl = %@",sUrl);
  //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager POST:sUrl parameters:dictPostData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLOG(@"Error: %@", error);
            block (nil , error);
        }];
  //  });
}


//-----------------------------------------------------------------------

- (void) callPostMethodForVideoUpload:(NSDictionary *)dictPostData  withUrl:(NSString *)sUrl completionBlock:(ResponseBlock)block {
    
    NSString * strServiceURL = sUrl;
    
    AFHTTPRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    
    //    NSMutableDictionary * mutdict = [[NSMutableDictionary alloc]init];
    //    [mutdict setObject:@"101" forKey:@"fb_id"];
    //    [mutdict setObject:@"nationalmilk" forKey:@"description"];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictPostData  options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString = [NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    DLOG(@"Post Data : %@",jsonString);
    
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:strServiceURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        NSData *data = [NSData dataWithContentsOfURL:kFinalRecordedVideoFileURL];
        //        NSString *mimeType = @"video/quicktime";
        
        NSData * videoData = [NSData dataWithContentsOfURL:kFinalRecordedVideoFileURL];
        [formData appendPartWithFormData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] name:kWebData];
        
        [formData appendPartWithFileData:videoData name:@"file_name" fileName:@"video.mp4" mimeType:@"video/quicktime"];
    } error:nil];
    
    [request setTimeoutInterval:600];
    
    __block UAProgressView* progressForDownloading  = [[UAProgressView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    progressForDownloading.borderWidth = 4.0;
    progressForDownloading.lineWidth = 8.0;
    progressForDownloading.center = [AppDelegate sharedInstance].window.center;
    [AppDelegate sharedInstance].window.userInteractionEnabled = NO;
    [[AppDelegate sharedInstance].window addSubview:progressForDownloading];
    progressForDownloading.tintColor = colorGreenBorder;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 20.0)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = progressForDownloading.tintColor;
    label.font = [UIFont boldSystemFontOfSize:19];
    label.userInteractionEnabled = NO;
    progressForDownloading.centralView = label;
    
    progressForDownloading.progressChangedBlock = ^(UAProgressView *progressView, float progress) {
        [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
    };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         DLOG(@"Success %@", responseObject);
                                         block(responseObject,nil);
                                         [AppDelegate sharedInstance].window.userInteractionEnabled = true;
                                         [progressForDownloading removeFromSuperview];
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         DLOG(@"Failure %@", error.description);
                                         [AppDelegate sharedInstance].window.userInteractionEnabled = true;
                                         [progressForDownloading removeFromSuperview];
                                         block (nil , error);
                                         
                                     }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        // progressForDownloading =
        float downloadPercentage = (float)totalBytesWritten/totalBytesExpectedToWrite;
        [progressForDownloading setProgress:downloadPercentage];
        
        DLOG(@"Wrote %lld/%lld = %f", totalBytesWritten, totalBytesExpectedToWrite,(double)totalBytesWritten/totalBytesExpectedToWrite);
    }];
    
    
    // 5. Begin!
    [operation start];
}

//-----------------------------------------------------------------------

- (void) callPostMethodForImageUpload:(NSDictionary *)dictPostData withImage:(UIImage *)imgUpload  withUrl:(NSString *)sUrl completionBlock:(ResponseBlock)block {
    
    NSString * strServiceURL = sUrl;
    
    AFHTTPRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictPostData  options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [NSString stringWithFormat:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    DLOG(@"Post Data : %@",jsonString);
    
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:strServiceURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //UIImage  * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"]];
        NSData * ImageData = UIImagePNGRepresentation(imgUpload);
        //NSData * ImageData = [NSData dataWithContentsOfURL:kImageFileURL];
        [formData appendPartWithFormData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] name:kWebData];
        [formData appendPartWithFileData:ImageData name:@"file_name" fileName:@"image.png" mimeType:@"image/png"];
        
    } error:nil];
    
    [request setTimeoutInterval:600];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         DLOG(@"Success %@", responseObject);
                                         block(responseObject,nil);
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         DLOG(@"Failure %@", error.description);
                                         
                                         block (nil , error);
                                         
                                     }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        
        DLOG(@"Wrote %lld/%lld = %f", totalBytesWritten, totalBytesExpectedToWrite,(double)totalBytesWritten/totalBytesExpectedToWrite);
    }];
    [operation start];
}


//-------------------------------------------------------------------------------

#pragma mark
#pragma mark  Authentication Methods

//-------------------------------------------------------------------------------
- (void)sendInAppPurchaseInfoToServer:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kUpdateInAppPurchaseInfo];
    DLOG(@"Register Profile -> %@",strUrl);
    [self callPostMethod:requestDictionary withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}
- (void)registerUserDetailWithData:(NSDictionary *)dictPostData completionBlock:(ResponseBlock)block {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kSignUp];
    DLOG(@"Register Profile -> %@",strUrl);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictPostData
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DLOG(@"Register Profile -> %@",jsonString);
    }
    
    [self callPostMethod:dictPostData withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//-------------------------------------------------------------------------------

- (void)fetchRSSFeedFromiTune:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block {
    
    NSString *strUrl = [NSString stringWithFormat:@"https://itunes.apple.com/%@/rss/topsongs/limit=50/json",kCountryCode];
    //DLOG(@"Register Profile -> %@",str);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
        [policy setAllowInvalidCertificates:YES];
        
        AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
        [operationManager setSecurityPolicy:policy];
        operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [operationManager POST:strUrl parameters:requestDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //DLOG(@"Response Object : %@ ",responseObject);
                block(responseObject,nil);
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DLOG(@"Error  : %@ ",error.localizedDescription);
                block(nil,error);
            });
            
        }];
        
    });
    
}


//-------------------------------------------------------------------------------

- (void) searchSongsFromiTune:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block{
    
    NSString * strUrl = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=%@&media=music&entity=song&attribute=albumTerm",[requestDictionary objectForKey:@"term"],kCountryCode];
    //NSString *strUrl = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=IN&media=music&entity=song&attribute=albumTerm",[requestDictionary objectForKey:@"term"]];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //DLOG(@"Register Profile -> %@",str);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
        [policy setAllowInvalidCertificates:YES];
        
        AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
        [operationManager setSecurityPolicy:policy];
        operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [operationManager GET:strUrl parameters:requestDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(responseObject,nil);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DLOG(@"Error  : %@ ",error.localizedDescription);
                block(nil,error);
            });
        }];
    });
}

//-------------------------------------------------------------------------------

- (void) getMediaFromServer:(NSDictionary *)requestDictionary withType:(int)iMediaType completionBlock:(ResponseBlock)block {
    
    //NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLocal,kGetVideoUrl];
    
    //NSString * strUrl = [NSString stringWithFormat:@"http://192.168.101.131:5123/services/get_videos"];
    
    //    NSString * strUrl = [NSString stringWithFormat:@"http://192.168.101.105:615/services/get_videos"];
    NSString *strUrl = @"";
    if (iMediaType == 0) {
        strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kGetAllImages];
    } else {
        strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kGetAllVideos];
    }
    
    
    DLOG(@"Upload Switchback Url -> %@",strUrl);
    
    /*
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
     [policy setAllowInvalidCertificates:YES];
     
     AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
     [operationManager setSecurityPolicy:policy];
     operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
     operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
     operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
     
     [operationManager GET:strUrl parameters:requestDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
     dispatch_async(dispatch_get_main_queue(), ^{
     // DLOG(@"getVideosFromServer Response : %@ ",responseObject);
     block(responseObject,nil);
     });
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     dispatch_async(dispatch_get_main_queue(), ^{
     DLOG(@"Error  : %@ ",error.localizedDescription);
     block(nil,error);
     });
     }];
     });*/
    
    [self callPostMethod:requestDictionary withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
//-----------------------------------------------------------------------

- (void) getShortenUrl:(NSDictionary *)dictPostData completionBlock:(ResponseBlock)block {
    NSString *strUrl = kGoogleShortUrl;
    
    [self callJsonPostMethod:dictPostData withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//-----------------------------------------------------------------------

- (void) uploadMargeDualVideo:(NSDictionary *)dictPostData completionBlock:(ResponseBlock)block {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kUploadMedia];
    DLOG(@"Upload Switchback Url -> %@",strUrl);
    [self callPostMethodForVideoUpload:dictPostData withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//-----------------------------------------------------------------------

- (void) uploadMargeDualImage:(NSDictionary *)dictPostData capturedImage:(UIImage *)img completionBlock:(ResponseBlock)block {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kUploadMedia];
    DLOG(@"Upload Switchback Url -> %@",strUrl);
    
    [self callPostMethodForImageUpload:dictPostData withImage:img withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//-------------------------------------------------------------------------------

- (void) submitCommentForMedia:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block {
    
    //    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.101.105:615/services/video_comments/data"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kVideoComment];
    DLOG(@"Upload Switchback Url -> %@",strUrl);
    
    [self callPostMethod:requestDictionary withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//-------------------------------------------------------------------------------

- (void) getMediaCommentsFromServer:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block{
    
    //    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.101.105:615/services/get_video_comments/data"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kGetVideoComment];
    DLOG(@"get Media Comments Switchback Url -> %@",strUrl);
    
    [self callPostMethod:requestDictionary withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


//-----------------------------------------------------------------------

- (void)addMediaInFavoriteList:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block {
    
    //    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.101.105:615/services/favourite/data"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kFavouriteData];
    DLOG(@"get Media Comments Switchback Url -> %@",strUrl);
    [self callPostMethod:requestDictionary withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//-----------------------------------------------------------------------

- (void)deleteSelectedMedia:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block {
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,kDeleteMedia];
    DLOG(@"get Media Comments Switchback Url -> %@",strUrl);
    [self callPostMethod:requestDictionary withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

//-----------------------------------------------------------------------

- (void)reportSelectedMedia:(NSDictionary *)requestDictionary completionBlock:(ResponseBlock)block{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kWebServiceUrlLive,@"get_videos/report_video"];
    DLOG(@"get Media Comments Switchback Url -> %@",strUrl);
    [self callPostMethod:requestDictionary withUrl:strUrl completionBlock:^(NSDictionary *dictResponse, NSError *error) {
        block(dictResponse,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
//-----------------------------------------------------------------------

/*
 - (void) getComments {
 
 dispatch_async(dispatch_get_main_queue(), ^{
 HUD  = [MBProgressHUD showHUDAddedTo:[AppDelegate sharedInstance].window animated:YES];
 HUD.mode = MBProgressHUDModeIndeterminate;
 HUD.labelText = @"Processing...";
 });
 
 DLOG(@"self.stringVideoId -- > %@",self.stringVideoId);
 
 iCommentPageCount = iCommentPageCount + 1;
 
 NSDictionary * requestDictionary = @{
 kMediaID:self.stringVideoId,
 kWSPageOffset:[NSString stringWithFormat:@"%ld",(long)iCommentPageCount]
 };
 
 __block NSArray * arrayComment;
 
 [[WebService sharedInstance] getMediaCommentsFromServer:requestDictionary completionBlock:^(NSDictionary *responseDictionary, NSError *error) {
 [MBProgressHUD hideHUDForView:[AppDelegate sharedInstance].window animated:true];
 self.view.userInteractionEnabled = YES;
 if (!error) {
 if ([[responseDictionary objectForKey:kStatus] boolValue]) {
 arrayComment = [[responseDictionary objectForKey:kData] valueForKey:kMediaComment];
 
 iToltalCommentCount = [[responseDictionary valueForKey:@"total_count"]integerValue];
 
 if (!arrayTableData) {
 arrayTableData = [[NSArray alloc]initWithArray:arrayComment];
 } else {
 NSMutableArray * arrVideoCommentList =[[NSMutableArray alloc]init];
 [arrVideoCommentList addObjectsFromArray:arrayTableData];
 arrayTableData = nil;
 if (arrVideoCommentList) {
 [arrVideoCommentList addObjectsFromArray:arrayComment];
 arrayTableData = [[NSArray alloc]initWithArray:arrVideoCommentList];
 arrVideoCommentList = nil;
 }
 }
 
 [self.tableComments reloadData];
 
 self.navigationItem.title = [NSString stringWithFormat:@"User Comments (%d)",(int)iToltalCommentCount];
 } else {
 NSString * msg = [NSString stringWithFormat:@"%@",[responseDictionary objectForKey:kMessage]];
 DisplayAlertWithTitle(msg, kAppName);
 return;
 }
 } else {
 DisplayAlertWithTitle(@"Please try again", kAppName);
 return;
 }
 }];
}
 */

@end
