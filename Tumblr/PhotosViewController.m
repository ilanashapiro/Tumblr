//
//  PhotosViewController.m
//  Tumblr
//
//  Created by ilanashapiro on 6/27/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "PhotosViewController.h"
#import "PostTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController ()
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PhotosViewController
//@synthesize posts;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 240;
}

- (void)fetchData {
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // Get the dictionary from the response key
            NSDictionary *responseDictionary = dataDictionary[@"response"];
            
            // Store the returned array of dictionaries in our posts property
            self.posts = responseDictionary[@"posts"];
            
            NSLog(@"%@", dataDictionary);
            
        }
        [self.tableView reloadData];
        
    }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"PostTableViewCell"];
    myCell.imageViewPost.image = nil;
    
    NSDictionary *post = self.posts[indexPath.row];
    NSArray *photos = post[@"photos"];
    
    if (photos) {
        //Get the first photo in the photos array
        NSDictionary *photo = photos[0];
        
        //Get the original size dictionary from the photo
        NSDictionary *originalSize =  photo[@"original_size"];
        
        //Get the url string from the original size dictionary
        NSString *urlString = originalSize[@"url"];
        
        //Create a URL using the urlString
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        NSLog(@"%@", url);
        [myCell.imageViewPost setImageWithURL:url];
    }
    
    return myCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
