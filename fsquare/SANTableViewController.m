//
//  SANTableViewController.m
//  fsquare
//
//  Created by Sanjay Kumar Mahalingam on 3/20/14.
//  Copyright (c) 2014 Sanjay. All rights reserved.
//

#import "SANTableViewController.h"
#import "POI.h"
#import "SANDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SANTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SANTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVenues:(NSArray *)venues
{
    _venues = venues;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"venue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    POI *venue = ((POI * )self.venues[indexPath.row]);
    
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = [venue getAddress];
    
    cell.imageView.image = venue.image;
    cell.imageView.layer.cornerRadius = 7;
    cell.imageView.layer.masksToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailView" sender:self];
}

- (void)reloadChangedImageForCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUInteger selectedRow = ((NSIndexPath *)[self.tableView indexPathForSelectedRow]).row;
    ((SANDetailViewController *)segue.destinationViewController).venue = self.venues[selectedRow];
}

@end
