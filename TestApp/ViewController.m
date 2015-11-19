//
//  ViewController.m
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageDownloadsInProgress;

#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    arr_record=[NSMutableArray new];
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    [self Refresh];
    
    self.view.backgroundColor=[UIColor whiteColor];
    tbl_list.backgroundColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
   
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    tbl_list=[[UITableView alloc] initWithFrame:self.view.frame];
    
    tbl_list.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    tbl_list.dataSource = self;
    tbl_list.delegate = self;
    
    tbl_list.separatorColor=[UIColor colorWithRed:129.0/255.0 green:129.0/255.0 blue:129.0/255.0 alpha:1.0];
    
    [self.view addSubview:tbl_list];
    
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    [tbl_list addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Functions

-(void)Refresh
{
    
    if (![Utilities CheckReachability])
    {
       [refreshControl endRefreshing];
       return;
    }
    
    //Get Contents Here(For large data need to go with NSURLConnection)
    
    NSString *str_url=@"https://dl.dropboxusercontent.com/u/746330/facts.json";
    
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:str_url] encoding:NSISOLatin2StringEncoding error:nil];
    
    NSData *metOfficeData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];
    
    for (NSDictionary *dict in [jsonObject valueForKey:@"rows"])
    {
        AppRecord *record=[AppRecord new];
        record.imageURLString=[dict valueForKey:@"imageHref"];
        record.str_title=[dict valueForKey:@"title"];
        record.str_description=[dict valueForKey:@"description"];
        [arr_record addObject:record];
    }
    
    [refreshControl endRefreshing];

}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_record count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText=@"";
    
    AppRecord *appRecord=[arr_record objectAtIndex:indexPath.row];
    
    if (![[Utilities checknull:appRecord.str_description] isEqualToString:@""])
    {
        cellText = appRecord.str_description;
    }
    //Calculate cell height based on the description text
    
    float height=[Utilities calculte_height:tbl_list.frame.size.width-120.0 :cellText];
    
    if (40.0+height<120.0)
    {
        return 120;
    }
    
    return 50.0+height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    AppRecord *appRecord=[arr_record objectAtIndex:indexPath.row];

    NSString *cellText=@"";
    
    if (![[Utilities checknull:appRecord.str_description] isEqualToString:@""])
    {
        cellText = appRecord.str_description;
    }
    
    
    float height=[Utilities calculte_height:tbl_list.frame.size.width-120.0 :cellText];
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)// Load cell if not available for reuse
    {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.lbl_title.frame = CGRectMake(10.0, 20.0, tbl_list.frame.size.width-120, 15.0);
    cell.lbl_desc.frame = CGRectMake(10.0,40.0, tbl_list.frame.size.width-120, 25.0);
    cell.lbl_desc.frame = CGRectMake(cell.lbl_desc.frame.origin.x, cell.lbl_desc.frame.origin.y, cell.lbl_desc.frame.size.width,height);
    cell.img_icon.frame = CGRectMake(tbl_list.frame.size.width-85, 40.0, 75.0, 75.0);

    
    if (![[Utilities checknull:appRecord.str_title] isEqualToString:@""])
    {
         cell.lbl_title.text = appRecord.str_title;
    }
    else
    {
        cell.lbl_title.text = @"";
    }
   
    
    if (![[Utilities checknull:appRecord.str_description] isEqualToString:@""])
    {
        cell.lbl_desc.text =appRecord.str_description;
    }
    else
    {
        cell.lbl_desc.text = @"";
    }
    
    if (![[Utilities checknull:appRecord.imageURLString] isEqualToString:@""])
    {
        if (!appRecord.appIcon)
        {
            if (tbl_list.dragging == NO && tbl_list.decelerating == NO)
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
            cell.img_icon.image = [UIImage imageNamed:@"loading"];
        }
        else
        {
            cell.img_icon.image = appRecord.appIcon;
        }
    }
    else
    {
        cell.img_icon.image = [UIImage imageNamed:@"no_image"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - Handle Orienatations

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    [tbl_list reloadData];
}

#pragma mark - Image loading

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            TableViewCell *cell = [tbl_list cellForRowAtIndexPath:indexPath];
            cell.img_icon.image = appRecord.appIcon;
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

- (void)loadImagesForOnscreenRows
{
    if (arr_record.count > 0)
    {
        NSArray *visiblePaths = [tbl_list indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppRecord *appRecord = (arr_record)[indexPath.row];
            
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
