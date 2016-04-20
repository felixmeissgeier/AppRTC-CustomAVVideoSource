/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "FrameInputAVFoundationVideoSource+Private.h"

#import "RTCMediaConstraints+Private.h"
#import "RTCPeerConnectionFactory+Private.h"
#import "RTCVideoSource+Private.h"

@implementation FrameInputAVFoundationVideoSource

- (instancetype)initWithFactory:(RTCPeerConnectionFactory *)factory
                    constraints:(RTCMediaConstraints *)constraints {
  NSParameterAssert(factory);
  rtc::scoped_ptr<webrtc::CustomVideoCapturer> capturer;
  capturer.reset(new webrtc::CustomVideoCapturer());
  rtc::scoped_refptr<webrtc::VideoTrackSourceInterface> source =
      factory.nativeFactory->CreateVideoSource(
          capturer.release(), constraints.nativeConstraints.get());
  return [super initWithNativeVideoSource:source];
}

- (BOOL)canUseBackCamera {
  return self.capturer->CanUseBackCamera();
}

- (BOOL)useBackCamera {
  return self.capturer->GetUseBackCamera();
}

- (void)setUseBackCamera:(BOOL)useBackCamera {
  self.capturer->SetUseBackCamera(useBackCamera);
}

- (AVCaptureSession *)captureSession {
  return self.capturer->GetCaptureSession();
}

- (webrtc::CustomVideoCapturer *)capturer {
  cricket::VideoCapturer *capturer = self.nativeVideoSource->GetVideoCapturer();
  // This should be safe because no one should have changed the underlying video
  // source.
  webrtc::CustomVideoCapturer *foundationCapturer =
      static_cast<webrtc::CustomVideoCapturer *>(capturer);
  return foundationCapturer;
}

@end
