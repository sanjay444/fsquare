//
//  SANViewController.m
//  fsquare
//
//  Created by Sanjay Kumar Mahalingam on 3/20/14.
//  Copyright (c) 2014 Sanjay. All rights reserved.
//

#import "SANViewController.h"
#import "SANTableViewController.h"
#import "Foursquare2.h"
#import "POI.h"

@interface SANViewController ()
{
    __weak IBOutlet UIView *__venueListContainer;
    __weak IBOutlet UIActivityIndicatorView *__activityIndicator;
    
    NSArray *_venuesSortedByCheckins;
    CLLocationManager *_locationMananger;
}

- (void)getFoursquareVenuesWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;

- (void)getImagesForVenues;
- (void)downloadImage:(NSURL *)url withIndex:(NSInteger)index;

@end

@implementation SANViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"navBar.png"]
     forBarMetrics:UIBarMetricsDefault];
    
    _locationMananger = [[CLLocationManager alloc] init];
    _locationMananger.delegate = self;
    
    __activityIndicator.hidesWhenStopped = YES;
    [__activityIndicator startAnimating];
    [_locationMananger startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Foursquare API Calls

- (void)getFoursquareVenuesWithLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    _venuesSortedByCheckins = [NSArray array];
    
    [Foursquare2 searchVenuesNearByLatitude:[NSNumber numberWithFloat:latitude]
                 longitude:[NSNumber numberWithFloat:longitude]
                 accuracyLL:nil
                 altitude:nil
                 accuracyAlt:nil
                 query:nil
                 limit:[NSNumber numberWithInt:100]
                 categoryId:@"4d4b7105d754a06374d81259"
                 intent:0
                 radius:[NSNumber numberWithInt:800]
                 callback:^(BOOL success, id result) {
                                       
    if (success) {
                                           
                                           
     NSMutableArray *venuesUnsorted = [NSMutableArray array];
                                           
     NSArray *venuesArray = [result valueForKeyPath:@"response.venues"];
                                           
     for (NSDictionary *venue in venuesArray)
     {
                                               
        POI *newVenue = [[POI alloc] init];
                                               
        newVenue.name = [venue objectForKey:@"name"];
        newVenue.numberOfPeopleHereNow = [[venue valueForKeyPath:@"hereNow.count"] intValue];
        newVenue.address = [venue valueForKeyPath:@"location.address"];
        newVenue.city = [venue valueForKeyPath:@"location.city"];
        newVenue.state = [venue valueForKeyPath:@"location.state"];
        newVenue.zipCode = [[venue valueForKeyPath:@"location.postalCode"] intValue];
        newVenue.latitude = [[venue valueForKeyPath:@"location.lat"] floatValue];
        newVenue.longitude = [[venue valueForKeyPath:@"location.lng"] floatValue];
                                               
        newVenue.checkInCount = [[venue valueForKeyPath:@"stats.checkinsCount"] intValue];
                                            
        newVenue.foursquareId = [venue objectForKey:@"id"];
                                               
        [venuesUnsorted addObject:newVenue];
         
     }
                                           
    _venuesSortedByCheckins = [venuesUnsorted sortedArrayUsingComparator:^NSComparisonResult(POI *venue1, POI *venue2) {
    NSNumber *checkinCount1 = [NSNumber numberWithInt:venue1.checkInCount];
    NSNumber *checkinCount2 = [NSNumber numberWithInt:venue2.checkInCount];
                                               
    return ([checkinCount1 compare:checkinCount2] == NSOrderedAscending);
  }];
                                           
  for (UIViewController *viewController in self.childViewControllers) {
    if ([viewController isKindOfClass:[SANTableViewController class]]) {
        ((SANTableViewController *)viewController).venues = _venuesSortedByCheckins;
        }
    }
                                           
    [__activityIndicator stopAnimating];
    [self getImagesForVenues];
  }
 }];

}

- (void)downloadImage:(NSURL *)url withIndex:(NSInteger)index
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
        queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( !error )
            {
                POI *venue = (POI *)_venuesSortedByCheckins[index];
                UIImage *image = [[UIImage alloc] initWithData:data];
                venue.image = image;
                                   
                for (UIViewController *viewController in self.childViewControllers) {
                  if ([viewController isKindOfClass:[SANTableViewController class]]) {
                    NSIndexPath *venueCellIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
                        [(SANTableViewController *)viewController reloadChangedImageForCellAtIndexPath:venueCellIndexPath];
                    }
                }
                                   
            }
        else
            {
                NSLog(@"%@", error);
            }
    }];
}

- (void)getImagesForVenues
{
    for (int i = 0; i < _venuesSortedByCheckins.count; i++) {
        POI *venue = _venuesSortedByCheckins[i];
        [Foursquare2 getPhotosForVenue:venue.foursquareId
                    limit:[NSNumber numberWithInt:1]
                    offset:nil
                    callback:^(BOOL success, id result) {
        if (success) {
            
            NSDictionary *photoItem = [result valueForKeyPath:@"response.photos.items"][0];
            
            NSString *imageSize = @"300x200";
            
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@%@",
                                        
                                        [photoItem objectForKey:@"prefix"],
                                        
                                        imageSize,
                                        
                                        [photoItem objectForKey:@"suffix"]];
            
                                      [self downloadImage:[NSURL URLWithString:imageURLString] withIndex:i];
                                  }
                              }];
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    
    [self getFoursquareVenuesWithLatitude:(CGFloat)location.coordinate.latitude
                             andLongitude:(CGFloat)location.coordinate.longitude];
    
    [_locationMananger stopUpdatingLocation];
}

@end
