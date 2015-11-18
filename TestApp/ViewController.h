//
//  ViewController.h
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "AppRecord.h"
#import "TableViewCell.h"
#import "Utilities.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *tbl_list;
    NSMutableArray *arr_record;
    
    UIRefreshControl *refreshControl;
}

@property(nonatomic,strong) NSMutableDictionary *imageDownloadsInProgress;

@end

