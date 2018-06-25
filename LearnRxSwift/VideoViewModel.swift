//
//  TSChatVideoViewModel.swift
//  Sakura
//
//  Created by 123 on 2018/5/30.
//  Copyright © 2018年 keilon. All rights reserved.
//

import Foundation
import AVFoundation
import RxCocoa
import RxSwift
import UIKit

class VideoView: NSObject {
    var isPlaying = Variable(true)
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    let disposeBag = DisposeBag()
    
    init(urlString mUrlStr: String) {
        super.init()
        let url = NSURL(string: mUrlStr)
        let playerItem = AVPlayerItem(url: url! as URL)
        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        self.avPlayerLayer.backgroundColor = UIColor.white.cgColor
        self.avPlayer.replaceCurrentItem(with: playerItem)
    }
    
    func stopPlayVideo(){
        self.avPlayer.replaceCurrentItem(with: nil)
    }
    
    deinit {
        NSLog("VideoModel deinit")
    }
    
    func playVideo() {
        self.isPlaying.value = self.avPlayer.rate > 0
       
    }
    
    
    func bindVM(videoView mVideoView: TSChatVideoView) {
        avPlayerLayer.frame = mVideoView.bounds
        mVideoView.containerView.layer.insertSublayer(avPlayerLayer, at: 0)
        
        self.avPlayer.rx.observe(CGFloat.self, "rate").subscribe(onNext: {(rate) in
            if Float(rate!) > Float(0){
                mVideoView.dismissView()
            }else{
                mVideoView.playButton.alpha = 1
                mVideoView.bottomView.alpha = 1
            }
        }).disposed(by: self.disposeBag)
        

        isPlaying.asObservable().skip(1).subscribe(onNext: {[weak self] value in
            guard let strongSelf = self else{
                return
            }
            if value{ //表示正在播放
                strongSelf.avPlayer.pause()
                mVideoView.playButton.setImage(nil, for: UIControlState.normal)
                mVideoView.playButton.setImage(nil, for: UIControlState.highlighted)
            }else{ //表示没有在播放
                strongSelf.avPlayer.play()
                mVideoView.playButton.setImage(nil, for: UIControlState.normal)
                mVideoView.playButton.setImage(nil, for: UIControlState.highlighted)
            }
            
        }).disposed(by: self.disposeBag)
        
        
        self.avPlayer.rx.observe(AVPlayerStatus.self, "status").subscribe(onNext: {
            status in if status == AVPlayerStatus.failed {
            }else if status == AVPlayerStatus.readyToPlay {
                //设置时间
                let playTimetext = String(format: "%02d:%02d", ((lround(CMTimeGetSeconds((self.avPlayer.currentItem?.asset.duration)!)) / 60) % 60), lround(CMTimeGetSeconds((self.avPlayer.currentItem?.asset.duration)!)) % 60)
                mVideoView.remainTimeLabel.text = playTimetext
            }else if status == AVPlayerStatus.unknown {
            }
            
        }).disposed(by: self.disposeBag)
        
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(0.1, 600)
        
        self.avPlayer.periodicTimeObserver(interval: timeInterval).subscribe(onNext: { [weak self] (time) in
            
            guard let currentItem = self?.avPlayer.currentItem else{
                return
            }
            let elapsedTime = CMTimeGetSeconds(time)
            let durationTime = CMTimeGetSeconds(currentItem.duration)
            let timeRemaining: Float64 = durationTime - elapsedTime
            let playTimetext = String(format: "%02d:%02d", ((lround(elapsedTime) / 60) % 60), lround(elapsedTime) % 60)
            let remainTimetext = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
            
            mVideoView.playTimeLabel.text = playTimetext
            mVideoView.remainTimeLabel.text = remainTimetext
            mVideoView.sliderLabel.value = Float(elapsedTime)/Float(durationTime)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        mVideoView.sliderLabel.rx.controlEvent(UIControlEvents.touchDown).subscribe({[weak self] _ in
            self?.avPlayer.pause()
        }).disposed(by: self.disposeBag)
        
        mVideoView.sliderLabel.rx.controlEvent(UIControlEvents.touchUpInside).subscribe({[weak self] _ in
            let videoDuration = CMTimeGetSeconds((self?.avPlayer.currentItem!.duration)!)
            let elapsedTime: Float64 = videoDuration * Float64(mVideoView.sliderLabel.value)
            
            self?.avPlayer.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100)) {
                (completed: Bool) -> Void in
                self?.avPlayer.play()
            }
        }).disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx.notification(NSNotification.Name.AVPlayerItemDidPlayToEndTime).subscribe({[weak self]_ in
            self?.avPlayer.currentItem?.seek(to: kCMTimeZero, completionHandler: nil)
            mVideoView.playButton.setImage(nil, for: UIControlState.normal)
            mVideoView.playButton.setImage(nil, for: UIControlState.highlighted)
        }).disposed(by: self.disposeBag)
    }
    
}

extension AVPlayer {
    public func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
        return Observable.create { observer in
            let t = self.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
                observer.onNext(time)
            }
            
            return Disposables.create { self.removeTimeObserver(t) }
        }
    }
}

