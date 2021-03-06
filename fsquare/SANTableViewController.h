//
//  SANTableViewController.h
//  fsquare
//
//  Created by Sanjay Kumar Mahalingam on 3/20/14.
//  Copyright (c) 2014 Sanjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SANTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *venues;

- (void)reloadChangedImageForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
