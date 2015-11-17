//
//  IconDownloader.h
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//
//
#import <UIKit/UIKit.h>

@class AppRecord;

@interface IconDownloader : NSObject

@property (nonatomic, strong) AppRecord *appRecord;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
