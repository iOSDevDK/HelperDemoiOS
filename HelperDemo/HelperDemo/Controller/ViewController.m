//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//


#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <MKMapViewDelegate,CLLocationManagerDelegate> {
    MKCoordinateRegion displayRegion;
    MKPointAnnotation *pointAnnot;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLPlacemark *placeMark;
@property (strong, nonatomic) NSString *strAddress;

@end

@implementation ViewController

//----------------------------------------------------------------------

#pragma mark - Memory Management Methods

//----------------------------------------------------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------

#pragma mark - CoreLocation Delegate Methods

//----------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
//    NSLog(@"locations :: %@",[locations description]);
//    UIAlertController *alert = [[UIAlertController alloc] init];
//    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        alert.message =  [locations description];
//    }]];
}

//----------------------------------------------------------------------

#pragma mark - MapView Delagate Methods

//----------------------------------------------------------------------

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    
    if (pointAnnot == nil) {
        
        displayRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 2000, 2000);
        [self.mapView setRegion:[self.mapView regionThatFits:displayRegion] animated:YES];
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        
        pointAnnot = [[MKPointAnnotation alloc] init];
        pointAnnot.coordinate = displayRegion.center;
        [self.mapView addAnnotation:pointAnnot];

        MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:self.mapView.userLocation.coordinate radius:100];
        [self.mapView addOverlay:circleOverlay];

    }
    
    /*
    NSArray *arrAnnotations = @[@{@"lat":@"23.0714",@"long":@"72.5869"},
                                @{@"lat":@"23.0250",@"long":@"72.6010"},
                                @{@"lat":@"22.3108",@"long":@"73.1808"},
                                ];
    for (int idx = 0; idx < arrAnnotations.count; idx++) {
        MKPointAnnotation *myPointAnnot = [[MKPointAnnotation alloc] init];
        myPointAnnot.coordinate = CLLocationCoordinate2DMake([[[arrAnnotations objectAtIndex:idx] objectForKey:@"lat"] floatValue], [[[arrAnnotations objectAtIndex:idx] objectForKey:@"long"] floatValue]);
        CLGeocoder *reverseGeoCoder = [[CLGeocoder alloc] init];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:myPointAnnot.coordinate.latitude longitude:myPointAnnot.coordinate.longitude];
        [mapView addAnnotation:myPointAnnot];
        [reverseGeoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            self.placeMark = [placemarks objectAtIndex:0];
            myPointAnnot.title = self.placeMark.subLocality;
            myPointAnnot.subtitle = [NSString stringWithFormat:@"postcode :: %@",[self.placeMark postalCode]];
            if (error) {
                NSLog(@"error :: %@",[error description]);
            }
        }];
    } // end of for loop.
    */
    
    CLGeocoder *reverseGeoCoder = [[CLGeocoder alloc] init];
    [reverseGeoCoder reverseGeocodeLocation:mapView.userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.placeMark = [placemarks objectAtIndex:0];
        self.mapView.userLocation.title = self.placeMark.subLocality;
        self.mapView.userLocation.subtitle = [NSString stringWithFormat:@"%@",[self.placeMark postalCode]];
//        [self btnSetCoverage:nil];
        if (error) {
            NSLog(@"error :: %@",[error description]);
        }
    }];
}

//----------------------------------------------------------------------

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }
    return nil;
//    MKAnnotationView *pinAnnotView = [[MKAnnotationView alloc] initWithAnnotation:[self.mapView.annotations lastObject] reuseIdentifier:@"pinAnnot"];
//    pinAnnotView.image = [UIImage imageNamed:@"Img_AnnotPin"];
//    pinAnnotView.canShowCallout = YES;
//    
//    return pinAnnotView;
}

//----------------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(nonnull MKAnnotationView *)view {
    
}

//----------------------------------------------------------------------

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circleRender.fillColor = [UIColor redColor];
    circleRender.alpha = 0.5f;
    return circleRender;
}

//----------------------------------------------------------------------

#pragma mark - IB Action Methods

//----------------------------------------------------------------------

- (IBAction) selectMapType:(UISegmentedControl *)sender {
    switch ([sender selectedSegmentIndex]) {
        case 1:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        default:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
    }
}

//----------------------------------------------------------------------

- (IBAction)btnTracking_Tapped:(UIButton *)sender {
    if ([sender isSelected] == YES) {
        // Stop Tracking.
//        NSLog(@"Tracking Stopped");
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
        [sender setSelected:NO];
    } else {
        // Start Tracking.
//        NSLog(@"Tracking Started");
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        [sender setSelected:YES];
//        [self customLocation];
    }
}

//----------------------------------------------------------------------

#pragma mark - Action Methods

//----------------------------------------------------------------------

- (void) tappedOnMap:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.mapView];
    
    CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.view];
    
    MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:tapPoint];
    // Some other stuff
    
    [self.mapView addAnnotation:annotation];
}

//----------------------------------------------------------------------

#pragma mark - Custom Methods

//----------------------------------------------------------------------

- (void) setUpView {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:50];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    displayRegion = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 2000, 2000);
    [self.mapView setRegion:[self.mapView regionThatFits:displayRegion] animated:YES];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    [tap setNumberOfTapsRequired:1];
//    [tap addTarget:self action:@selector(tappedOnMap:)];
//    [self.mapView addGestureRecognizer:tap];
}

//----------------------------------------------------------------------

- (void) customLocation {
    [self.mapView removeAnnotations:self.mapView.annotations];
    MKPointAnnotation *myPointAnnot = [[MKPointAnnotation alloc] init];
    myPointAnnot.coordinate = CLLocationCoordinate2DMake(28.6139,77.2090);
    CLGeocoder *reverseGeoCoder = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:myPointAnnot.coordinate.latitude longitude:myPointAnnot.coordinate.longitude];
    [self.mapView addAnnotation:myPointAnnot];
    [reverseGeoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.placeMark = [placemarks objectAtIndex:0];
        //            NSLog(@"placeMark :: %@", self.placeMark);
        
        myPointAnnot.title = self.placeMark.subLocality;
        myPointAnnot.subtitle = [NSString stringWithFormat:@"%@",[self.placeMark postalCode]];
        if (error) {
            NSLog(@"error :: %@",[error description]);
        }
    }];
}

//----------------------------------------------------------------------

- (IBAction) btnSetCoverage:(id) sender {
//    NSMutableDictionary *dicSubmit = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
//        @"3.00",@"current_radius",
//        @"83",@"driver_id",
//        self.mapView.userLocation.title,@"town",
//        [NSString stringWithFormat:@"%f",self.mapView.userLocation.coordinate.latitude],@"latitude",
//        [NSString stringWithFormat:@"%f",self.mapView.userLocation.coordinate.longitude],@"longitude",
//        self.mapView.userLocation.subtitle,@"postcode" , nil];
//    
//    [WebServiceViewController wsVC].strURL = DriverApp_Webservice_FixedUrl;
//    [WebServiceViewController wsVC].strCallHttpMethod = @"POST";
//    [WebServiceViewController wsVC].strMethodName = @"insertCoverageData";
    
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSMutableDictionary *dict = [[WebServiceViewController wsVC] sendRequestWithParameter:dicSubmit];
//        
//        if (dict != Nil && dict != NULL) {
//        }
//    });
    
    NSString *strURL=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius=500&types=food&sensor=true&key=AIzaSyCa8Fj2ewYw-I09Obm_zBsfqTktd_oZ1nE"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:strURL]];
    
    
    NSError *error;
    NSURLResponse *resultResponse;
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resultResponse error:&error];
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSLog(@"response=%@",json_string);
    // NSError *jsonError = nil;
    
    //    NSMutableDictionary *dictResult =[NSMutableDictionary dictionaryWithDictionary:[json_string JSONValue]];
    
    NSMutableDictionary *dictResult =[NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil]];
    
    NSLog(@"dictResult :: %@",dictResult);
}

//----------------------------------------------------------------------

#pragma mark - View Life Cycle Methods

//----------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setMapType:MKMapTypeStandard];
    [self setUpView];
}

//----------------------------------------------------------------------

@end
