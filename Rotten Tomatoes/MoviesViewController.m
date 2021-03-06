//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by Harsha Badami Nagaraj on 6/8/14.
//  Copyright (c) 2014 Harsha Badami Nagaraj. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "MovieDetailViewController.h"
#import "Reachability.h"
#import "DMRNotificationView.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) DMRNotificationView *notificationView;
@property (nonatomic, strong) NSString *movieAPIURL;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (id)initWithData:(NSString *)movieAPIURL {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.movieAPIURL = movieAPIURL;
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(getMovieData:)
      forControlEvents:UIControlEventValueChanged];

    
    [self getMovieData:refreshControl];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.tableView.rowHeight = 130;
    
    self.notificationView = [[DMRNotificationView alloc] initWithTitle:@"Network Error" subTitle:@"" targetView:self.view];
    
    [self.notificationView setTintColor:[UIColor blackColor]];
    [self.notificationView setHideTimeInterval:0.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMovieData:(UIRefreshControl *)refreshControl {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Movies";

    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.movieAPIURL]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [self showNetworkError];
            
            [hud hide:YES];
            [refreshControl endRefreshing];
        } else {
            [self hideNetworkError];
            
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", object);
        
            self.movies = object[@"movies"];
        
            [self.tableView reloadData];
        
            [hud hide:YES];
            [refreshControl endRefreshing];
        }
    }];

}

- (long) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    [cell setMovieDetails:movie];
    
    UIImageView *selectionView = [[UIImageView alloc]initWithFrame:cell.frame];
    selectionView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = selectionView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *mdvc = [[MovieDetailViewController alloc]init];
    NSDictionary *movie = self.movies[indexPath.row];
    mdvc.movieData = movie;
    
    [self.navigationController pushViewController:mdvc animated:YES];
}

- (void) isNetworkReachable {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.rottentomatoes.com"];
    
    reach.reachableBlock = ^(Reachability *reach) {
        [self hideNetworkError];
    };
    
    reach.unreachableBlock = ^(Reachability*reach) {
        [self showNetworkError];
    };
    
    [reach startNotifier];
    
}

-(void)reachabilityChanged:(NSNotification*)note{
    
    Reachability * reach = [note object];
    
    if([reach isReachable]) {
        [self hideNetworkError ];
    } else {
        [self showNetworkError];
    }
}

-(void) showNetworkError {
    [self.notificationView showAnimated:YES];
}

-(void) hideNetworkError {
    [self.notificationView dismissAnimated:YES];
}

@end
