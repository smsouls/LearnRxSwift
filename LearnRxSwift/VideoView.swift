//
//  TSChatVideoView.swift
//  Sakura
//
//  Created by 123 on 2018/5/30.
//  Copyright © 2018年 keilon. All rights reserved.
//

import UIKit

class TSChatVideoView: UIView {
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var remainTimeLabel: UILabel!
    @IBOutlet weak var sliderLabel: UISlider!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        containerView = Bundle.main.loadNibNamed("VideoView", owner: self, options: nil)?.first as! UIView
        containerView.frame = self.bounds
        self.bottomView.backgroundColor = UIColor.white
        self.addSubview(containerView)
        
        
        self.playButton.setImage(nil, for: UIControlState.normal)
        self.playButton.setImage(nil, for: UIControlState.highlighted)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.bottomView.alpha = 1;
        self.playButton.alpha = 1;
        super.touchesBegan(touches, with: event)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismissView), object: nil)
    }
    
        

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.perform(#selector(dismissView), with: nil, afterDelay: 0.5)
        super.touchesEnded(touches, with: event)
    }
    
    
    @objc func dismissView() {
        UIView.animate(withDuration: 1) {
            self.bottomView.alpha = 0;
            self.playButton.alpha = 0;
        }
    }
    
    
}
