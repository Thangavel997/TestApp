//
//  ViewController.h
//  TestApp
//
//  Created by Thangavel on 11/12/15.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *tableViewList;
    
    NSMutableDictionary *dictionaryJsonObject;
    
    NSMutableArray *arrayRecord;
    
    UIRefreshControl *refreshControl;
}

@property(nonatomic,strong) NSMutableDictionary *imageDownloadsInProgress;

@end

