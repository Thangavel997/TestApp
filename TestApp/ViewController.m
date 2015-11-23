//
//  ViewController.m
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//

#import "ViewController.h"
#import "Constants.h"
#import "IconDownloader.h"
#import "AppRecord.h"
#import "Utilities.h"
#import "CustomCell.h"


@interface ViewController ()

@end
static NSString* const CellIdentifier = @"DynamicTableViewCell";

@implementation ViewController
@synthesize imageDownloadsInProgress;


#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Allocations and Set proper resizing masks for UI based controls
    
    arrayRecord=[NSMutableArray new];
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    self.view.backgroundColor=[UIColor whiteColor];
    tableViewList.backgroundColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    tableViewList=[[UITableView alloc] initWithFrame:self.view.frame];
    [tableViewList registerNib:[UINib nibWithNibName:@"CustomCell" bundle: nil] forCellReuseIdentifier:CellIdentifier];
    tableViewList.hidden=YES;
    [self Refresh];
    
    tableViewList.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    tableViewList.dataSource = self;
    tableViewList.delegate = self;
    
    tableViewList.separatorColor=[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
    
    [self.view addSubview:tableViewList];
    
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    [tableViewList addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Functions

-(void)Refresh
{
    
    //Make sure network is available or not
    if (![Utilities CheckReachability])
    {
        [refreshControl endRefreshing];
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Unable to connect the internet through Wifi or cellular network.Please check the settings and try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
       return;
    }
    
    //Make API Call with the help of Operation queue for Asynchronous connections
    NSURL *url = [NSURL URLWithString:BASEURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil)
        {
            [arrayRecord removeAllObjects];
            NSError *error;
            //Parse the Response data based on the encoding format/Dictionary/Array
            NSString *stringData=[[NSString alloc] initWithData:data encoding:NSISOLatin2StringEncoding];
            NSData *metOfficeData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:metOfficeData options:NSJSONReadingMutableContainers error:&error];
            //Get the Json object for further updates
            for (NSDictionary *dict in [jsonObject valueForKey:@"rows"])
            {
                AppRecord *record=[AppRecord new];
                record.imageURLString=[dict valueForKey:@"imageHref"];
                record.stringTitle=[dict valueForKey:@"title"];
                record.stringDescription=[dict valueForKey:@"description"];
                [arrayRecord addObject:record];
            }
            //Update the UI with Main queue
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^ {
                self.title=[jsonObject valueForKey:@"title"];
                if (tableViewList.hidden)
                {
                    tableViewList.hidden=NO;
                }
                [tableViewList reloadData];
                [refreshControl endRefreshing];
            }];

            
            
        }
    }];

}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the no. of rows for Tableview
    return [arrayRecord count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Calculate height Based on the Json description.
    static CustomCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableViewList dequeueReusableCellWithIdentifier:CellIdentifier];
    });
    
    [self configureImageCell:sizingCell atIndexPath:indexPath];
    
    //Update the Cell constraints
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableViewList.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
    
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isLandscapeOrientation])
    {
        return 140.0f;
    }
    else
    {
        return 235.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Return the Cell based on Reusable Identifier
    CustomCell *cell = (CustomCell *)[tableViewList dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureImageCell:cell atIndexPath:indexPath];
    return cell;

}
- (void)configureImageCell:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    AppRecord *appRecord=[arrayRecord objectAtIndex:indexPath.row];
    
    //Check with Null function whether having proper value or not and then update the UI
    if (![[Utilities checknull:appRecord.stringTitle] isEqualToString:@""])
    {
        cell.labelTitle.text = appRecord.stringTitle;
    }
    else
    {
        cell.labelTitle.text = @"";
    }
    
    
    if (![[Utilities checknull:appRecord.stringDescription] isEqualToString:@""])
    {
        cell.labelDescription.text =appRecord.stringDescription;
    }
    else
    {
        cell.labelDescription.text = @"";
    }
    
    //Load the Image form Json Image Url with the help of IconDownloader
    if (![[Utilities checknull:appRecord.imageURLString] isEqualToString:@""])
    {
        if (!appRecord.appIcon)
        {
            if (tableViewList.dragging == NO && tableViewList.decelerating == NO)
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
            cell.imageIcon.image = [UIImage imageNamed:@"loading"];//Update Some Loding image while dowmnloading to indicate the user.
        }
        else
        {
            cell.imageIcon.image = appRecord.appIcon;
        }
        
    }
    else
    {
        cell.imageIcon.image = [UIImage imageNamed:@"no_image"];
    }
    
    //Update the Description label constraints if needed
    if (cell.labelDescription.numberOfLines == 0 && cell.labelDescription.bounds.size.width != cell.labelDescription.preferredMaxLayoutWidth)
    {
        cell.labelDescription.preferredMaxLayoutWidth = cell.labelDescription.bounds.size.width;
        [cell.labelDescription setNeedsUpdateConstraints];
    }

}



- (BOOL)isLandscapeOrientation {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

#pragma mark - Image loading

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        //Update the IconDownloader class with Apprecord files i.e ImageURL and Icon(if already cached)
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            //Update the UI once Icondownloader Cached the image
            CustomCell *cell =(CustomCell *) [tableViewList cellForRowAtIndexPath:indexPath];
            cell.imageIcon.image = appRecord.appIcon;
            
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

- (void)loadImagesForOnscreenRows
{
    if (arrayRecord.count > 0)
    {
        //Load the image for AppReocrd for Visible rows
        NSArray *visiblePaths = [tableViewList indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppRecord *appRecord = (arrayRecord)[indexPath.row];
            
             if (![[Utilities checknull:appRecord.imageURLString] isEqualToString:@""])
             {
                 if (!appRecord.appIcon)
                 {
                     [self startIconDownload:appRecord forIndexPath:indexPath];
                 }

             }
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


@end
