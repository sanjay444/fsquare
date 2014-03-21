//
//  SANDetailViewController.m
//  fsquare
//
//  Created by Sanjay Kumar Mahalingam on 3/20/14.
//  Copyright (c) 2014 Sanjay. All rights reserved.
//

#import "SANDetailViewController.h"

@interface SANDetailViewController ()
{
    __weak IBOutlet UIImageView *__imageView;
    __weak IBOutlet UILabel *__addressLabel;
   __weak IBOutlet UILabel *__checkinsLabel;
    __weak IBOutlet UILabel *__name;
    
    
}@end

@implementation SANDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __imageView.image = self.venue.image;
    
    __name.text = [NSString stringWithFormat:@"%@ ",self.venue.name];
    
    __addressLabel.text = [NSString stringWithFormat:@"%@ ", self.venue.address];
    
    
    
    __checkinsLabel.text = [NSString stringWithFormat:@"%i here now", self.venue.numberOfPeopleHereNow];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
