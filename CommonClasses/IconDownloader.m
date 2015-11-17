//
//  IconDownloader.m
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//
//

#import "IconDownloader.h"
#import "AppRecord.h"

#define kAppIconSize 75


@interface IconDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end


#pragma mark -

@implementation IconDownloader


#pragma mark - Start Download

- (void)startDownload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.imageURLString]];

    // create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        

        if (error != nil)
        {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
            {
                abort();
            }
        }
                                                       
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            
            // Set appIcon and clear temporary data/image
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
            {
                CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                self.appRecord.appIcon = image;
            }
            
            // call our completion handler to tell our client that our icon is ready for display
            if (self.completionHandler != nil)
            {
                self.completionHandler();
            }
        }];
    }];
    
    [self.sessionTask resume];
}

#pragma mark - Cancel Download

- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end

