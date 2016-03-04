//
//  DownloadTaskCell.swift
//  downloaderDemo
//
//  Created by newegg on 16/3/4.
//  Copyright © 2016年 code. All rights reserved.
//

import UIKit

class DownloadTaskCell: UITableViewCell {
    
    var labelName: UILabel = UILabel()
    var labelSize: UILabel = UILabel()
    var labelProgress: UILabel = UILabel()
    var labelSpeed: UILabel = UILabel()
    
    var downloadTask: DownloadTask?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(labelName)
        self.addSubview(labelSize)
        self.addSubview(labelProgress)
        self.addSubview(labelSpeed)
        
        self.labelName.font = UIFont.systemFontOfSize(14)
        self.labelSize.font = UIFont.systemFontOfSize(14)
        self.labelProgress.font = UIFont.systemFontOfSize(14)
        self.labelSpeed.font = UIFont.systemFontOfSize(14)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateProgress:"), name: DownloadTaskNotification.Progress.rawValue, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(task: DownloadTask) {
        self.downloadTask = task
        labelName.text = self.downloadTask?.url.lastPathComponent
    }
    
    func updateProgress(notification: NSNotification) {
        
        guard let info = notification.object as? NSDictionary else {return}
        
        if let taskIdentifier = info["taskIdentifier"] as? NSNumber {
            
            if taskIdentifier.integerValue == self.downloadTask?.taskIdentifier {
                
                guard let written = info["totalBytesWritten"] as? NSNumber else {return}
                guard let total = info["totalBytesExpectedToWrite"] as? NSNumber else {return}
                guard let speed = info["downSpeed"] as?  String else {return}
                let formattedWrittenSize = NSByteCountFormatter.stringFromByteCount(written.longLongValue, countStyle: NSByteCountFormatterCountStyle.File)
                
                let formattedTotalSize = NSByteCountFormatter.stringFromByteCount(total.longLongValue, countStyle: NSByteCountFormatterCountStyle.File)
                
                self.labelSize.text = "\(formattedWrittenSize) / \(formattedTotalSize)"
                let percentage = Int((written.doubleValue / total.doubleValue) * 100.0)
                self.labelProgress.text = "\(percentage)%"
                
            
                self.labelSpeed.text = "\(speed)/s"
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.labelName.frame = CGRectMake(20, 10, self.contentView.frame.size.width - 50, 20)
        self.labelSize.frame = CGRectMake(20, 40, self.contentView.frame.size.width - 50, 20)
        self.labelProgress.frame = CGRectMake(self.contentView.frame.size.width - 45, 20, 40, 30)
        self.labelSpeed.frame = CGRectMake(170, 20, self.contentView.frame.size.width - 70, 30)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
