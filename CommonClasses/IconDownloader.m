//
//  IconDownloader.m
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//
//

#import "IconDownloader.h"
#import "AppRecord.h"
#import "Utilities.h"

#define kAppIconSize 75


@interface IconDownloader ()

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end


#pragma mark -

@implementation IconDownloader


#pragma mark - Start Download

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    //Start the Url Connection for for ImageReuests
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.imageURLString]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

#pragma mark - Cancel Download

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //Receive the Image data
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //Update on Failure
    self.appRecord.appIcon=[UIImage imageNamed:@"no_image"];
    self.activeDownload = nil;
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    
    //Update the image with proper size
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
    
    self.activeDownload = nil;
    
    self.imageConnection = nil;
    
    if (self.completionHandler)
    {
        self.completionHandler();
    }
}

@end

