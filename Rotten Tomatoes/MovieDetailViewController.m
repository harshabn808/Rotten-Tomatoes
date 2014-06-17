//
//  MovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by Harsha Badami Nagaraj on 6/9/14.
//  Copyright (c) 2014 Harsha Badami Nagaraj. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *movieScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;

@end

@implementation MovieDetailViewController

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.movieTitleLabel.text = self.movieData[@"title"];
    self.movieSynopsisLabel.text = self.movieData[@"synopsis"];
    
    NSString *imageUrl = self.movieData[@"posters"][@"thumbnail"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: url];
    self.moviePosterView.image = [UIImage imageWithData: imageData];
    
    [self loadImage:[self.movieData valueForKeyPath:@"posters.original"] :self.moviePosterView];
}

-(void)viewWillAppear:(BOOL)animated {
    self.title = self.movieData[@"title"];
}

-(void)viewDidLayoutSubviews {
    CGSize maximumLabelSize = CGSizeMake(280,2000);
    
    // use font information from the UILabel to calculate the size
    CGSize expectedLabelSize = [self.movieData[@"synopsis"] sizeWithFont:self.movieSynopsisLabel.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newFrame = self.contentView.frame;
    
    newFrame.size.height = expectedLabelSize.height + 320;
    
    // put calculated frame into UILabel frame
    self.contentView.frame = newFrame;

    self.movieScrollView.contentSize = self.contentView.bounds.size;
}

-(void) loadImage:(NSString *)imageURL :(UIImageView *)imageView {
    NSURL *url = [NSURL URLWithString:imageURL];
    
    [imageView setImageWithURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
