//
//  ViewController.m
//  TextView
//
//  Created by 沈红榜 on 16/2/18.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ResizeMagick.h"
#import "PreViewController.h"
#import "SHBAttachMent.h"
#import "SHBTextViewTapGestureRecognizer.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, SHBTextViewGestureRecognizerDelegate>

@end

@implementation ViewController {
    UITextView                          *_textView;
    NSMutableArray<SHBAttachMent *>     *_dataArray;
    
    UIView                              *_inputView;
    
    SHBTextViewTapGestureRecognizer     *_tap;
    
    
    UIImageView                         *_showImgView;
}

- (void)goinPreView {
    PreViewController *preView = [[PreViewController alloc] initWithAttString:_textView.attributedText attachMents:_dataArray];
    [self.navigationController pushViewController:preView animated:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.775 green:0.971 blue:1.000 alpha:1.000];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"PreView" style:UIBarButtonItemStylePlain target:self action:@selector(goinPreView)];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, CGRectGetWidth(self.view.bounds) - 40, CGRectGetHeight(self.view.bounds) - 200)];
    _textView.allowsEditingTextAttributes = true;

    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    
    [self.view addSubview:_textView];
    
    _tap = [[SHBTextViewTapGestureRecognizer alloc] init];
    _tap.delegate = self;
    [_textView addGestureRecognizer:_tap];
    
    
    CGFloat inputH = 44;
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - inputH, CGRectGetWidth(self.view.bounds), inputH)];
    _inputView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_inputView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"image" forState:UIControlStateNormal];
    btn.frame = CGRectMake(30, 0, 50, inputH);
    [_inputView addSubview:btn];
    [btn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _textView.translatesAutoresizingMaskIntoConstraints = false;
    id top = self.topLayoutGuide;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_textView, _inputView, top);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_textView]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top]-[_textView]-50-|" options:0 metrics:nil views:views]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard:) name:UIKeyboardWillHideNotification object:nil];

    _showImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _showImgView.contentMode = UIViewContentModeScaleAspectFit;
    _showImgView.backgroundColor = [UIColor colorWithWhite:0.78 alpha:0.8];
    [self.view addSubview:_showImgView];
    _showImgView.hidden = true;

}

- (void)chooseImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:true completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_textView endEditing:true];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:true completion:^{
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        NSAttributedString *lastAtt = _textView.attributedText;
        
        NSInteger location = _textView.selectedRange.location;
        CGFloat width = CGRectGetWidth(_textView.bounds) - 16;
        CGFloat height = width * image.size.height / image.size.width;
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:lastAtt];
        
        SHBAttachMent *attachment = [[SHBAttachMent alloc] initWithData:nil ofType:nil];
        attachment.image = [image resizedImageByWidth:width * 2 / 3];
        attachment.originalImage = image;
        attachment.type = SHBAttachMentTypeImage;
        
        attachment.bounds = CGRectMake(0, 0, width, height);
        
        NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSAttributedString *nString = [[NSAttributedString alloc] initWithString:@"\n"];
        [attString insertAttributedString:nString atIndex:location];
        
        [attString insertAttributedString:imgString atIndex:location + 1];
        [_dataArray addObject:attachment];
        _textView.attributedText = attString;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - keyboard
- (void)showKeyBoard:(NSNotification *)info {
    NSDictionary *dic = info.userInfo;
    
    NSValue *rectValue = dic[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [rectValue CGRectValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        _inputView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 44 - CGRectGetHeight(rect), CGRectGetWidth(self.view.bounds), 44);
    }];
    _textView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(rect), 0);
}

- (void)hiddenKeyBoard:(NSNotification *)info {
    _textView.contentInset = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.25 animations:^{
        _inputView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.bounds), 44);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SHBTextViewGestureRecognizerDelegate
- (void)gesture:(UIGestureRecognizer *)gesture handleTapOnTextAttachment:(NSTextAttachment *)tempAttachment inRange:(NSRange)characterRange {
    SHBAttachMent *attachment = (SHBAttachMent *)tempAttachment;
    [_textView endEditing:true];
    NSLog(@"tap: %@", attachment.originalImage);
    
    _showImgView.hidden = false;
    _showImgView.image = attachment.originalImage;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _showImgView.hidden = true;
    });
}

@end
