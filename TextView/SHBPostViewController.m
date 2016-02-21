//
//  SHBPostViewController.m
//  TextView
//
//  Created by 沈红榜 on 16/2/19.
//  Copyright © 2016年 沈红榜. All rights reserved.
//

#import "SHBPostViewController.h"
#import "UIColor+SHBHex.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SHBAttachMent.h"
#import "UIImage+ResizeMagick.h"
#import "SHBInputView.h"

CGFloat toolBarH = 44;

@interface SHBPostViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, SHBInputViewDelegate>


@end

@implementation SHBPostViewController {
    UILabel         *_title;
    UIButton        *_tagBtn;
    UIButton        *_cTag;
    
    UIView          *_line;
    UITextView      *_textView;
    
    NSDictionary    *_textViewConfig;
    
    CGFloat         _keyboardH;
    
    
    SHBInputView    *_inputView;
    UIButton        *_recordBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发帖";
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    _textViewConfig = @{NSParagraphStyleAttributeName : style, NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor shbColorWithHexString:@"333333"]};
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard:) name:UIKeyboardWillHideNotification object:nil];

    
}

- (void)initUI {
    _title = [[UILabel alloc] initWithFrame:CGRectZero];
    _title.translatesAutoresizingMaskIntoConstraints = false;
    _title.textColor = [UIColor shbColorWithHexString:@"403f55"];
    _title.text = @"类型";
    _title.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_title];
    
    _tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tagBtn.translatesAutoresizingMaskIntoConstraints = false;
    [_tagBtn setTitle:@"title" forState:UIControlStateNormal];
    [_tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tagBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _tagBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _tagBtn.backgroundColor = [UIColor shbColorWithHexString:@"403f55"];
    [_tagBtn addTarget:self action:@selector(clickedTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tagBtn];
    
    _cTag = [UIButton buttonWithType:UIButtonTypeCustom];
    _cTag.translatesAutoresizingMaskIntoConstraints = false;
    [_cTag setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
    _cTag.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [_cTag addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cTag];
    
    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.translatesAutoresizingMaskIntoConstraints = false;
    _line.backgroundColor = [UIColor shbColorWithHexString:@"dedede"];
    [self.view addSubview:_line];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.translatesAutoresizingMaskIntoConstraints = false;
    _textView.typingAttributes = _textViewConfig;
    [self.view addSubview:_textView];
    
    id top = self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(top, _title, _tagBtn, _cTag, _line, _textView);
    NSDictionary *me = @{@"t" : @(15 - _textView.textContainerInset.top), @"r" : @(15 - 8), @"l" : @(15 - 8)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[_title]-8-[_tagBtn]-(>=0)-[_cTag]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[_line]-15-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-l-[_textView]-r-|" options:0 metrics:me views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top]-20-[_title]-20-[_line(1)]-t-[_textView]-44-|" options:0 metrics:me views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tagBtn(30)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cTag(30)]" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tagBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_title attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_cTag attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_title attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    UIToolbar *bar = [self getToolbar];

  
    [self.view addSubview:bar];
    
    UIToolbar *tempbar = [self getToolbar];
    _textView.inputAccessoryView = tempbar;
//    [self configInputView];
}

- (void)chooseTag:(UIButton *)btn {
    
}

- (void)clickedTagBtn:(UIButton *)btn {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
//    _textView.inputView = nil;
}

- (UIToolbar *)getToolbar {
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - toolBarH, CGRectGetWidth(self.view.bounds), toolBarH)];
    
    [bar setItems:@[[[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStylePlain target:self action:@selector(first)],
                    [[UIBarButtonItem alloc] initWithTitle:@"视频" style:UIBarButtonItemStylePlain target:self action:@selector(second)],
                    [[UIBarButtonItem alloc] initWithTitle:@"录音" style:UIBarButtonItemStylePlain target:self action:@selector(third)],
                    [[UIBarButtonItem alloc] initWithTitle:@"收起" style:UIBarButtonItemStylePlain target:self action:@selector(fourth)]]];
    return bar;
}

#pragma mark - inputView
- (void)configInputView {
    
    _inputView = [[SHBInputView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 196)];
    
    _inputView.delegate = self;
    
}

- (void)clickedRecordBtn:(UIButton *)btn {
    
    
    
}


- (void)first {
    [self superAction];

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    picker.delegate = self;
    [self presentViewController:picker animated:true completion:nil];
}

- (void)second {
    [self superAction];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:true completion:nil];
    
}

- (void)third {
    [self superAction];
    if (!_inputView) {
        [self configInputView];
    }
    _textView.inputView = _inputView;
    [_textView becomeFirstResponder];
}

- (void)fourth {
    if (_textView.isFirstResponder) {
        [self superAction];
    } else {
        [_textView becomeFirstResponder];
    }
}

- (void)superAction {
    [_textView resignFirstResponder];
    _textView.inputView = nil;
    
    
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:true completion:^{
        if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *image = info[UIImagePickerControllerOriginalImage];
            
            NSAttributedString *lastAtt = _textView.attributedText;
            
            NSInteger location = _textView.selectedRange.location;
            CGFloat width = CGRectGetWidth(_textView.bounds) - 16;
            CGFloat height = width * image.size.height / image.size.width;
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:lastAtt];
            
            SHBAttachMent *attachment = [[SHBAttachMent alloc] initWithData:nil ofType:nil];
            
            UIImage *tempImage = [image resizedImageByWidth:width];
            
            attachment.image = [tempImage addImage:[UIImage imageNamed:@"stop"] size:CGSizeMake(50, 50)];
            
            attachment.originalImage = image;
            attachment.type = SHBAttachMentTypeImage;
            
            attachment.bounds = CGRectMake(0, 0, width, height);
            
            NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:attachment];
            if (_textView.text.length > 0) {// 未输入文字就插入图片，不加换行
                NSAttributedString *nString = [[NSAttributedString alloc] initWithString:@"\n"];
                [attString insertAttributedString:nString atIndex:location];
                [attString insertAttributedString:imgString atIndex:location + 1];
            } else {
                [attString insertAttributedString:imgString atIndex:location];
            }
            
            
            [attString addAttributes:_textViewConfig range:NSMakeRange(0, attString.length)];
            _textView.attributedText = attString;
            _textView.selectedRange = NSMakeRange(0, _textView.attributedText.length);
            
            
            
        } else if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
            NSURL *movpath = info[UIImagePickerControllerMediaURL];
            NSLog(@"movPath: %@", movpath);
        }

        _textView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        if (_textView.contentSize.height >= CGRectGetHeight(_textView.frame)) {
            
            _textView.contentOffset = CGPointMake(0, _textView.contentSize.height - CGRectGetHeight(_textView.frame));
        }
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
    _keyboardH = CGRectGetHeight(rect);
    _textView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(rect), 0);
}

- (void)hiddenKeyBoard:(NSNotification *)info {
    _textView.contentInset = UIEdgeInsetsZero;

}

#pragma mark - SHBInputViewDelegate
- (void)inputViewHasNoPower {
    NSLog(@"%s", __FUNCTION__);
}

- (void)inputViewCancel {
    NSLog(@"%s", __FUNCTION__);
}

- (void)inputViewSure:(NSString *)recordPath {
    NSLog(@"path: %@", recordPath);
}

@end
