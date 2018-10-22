//
//  KRMine_UesrInfoCell.swift
//  KoalaReadingTeacher
//
//  Created by 李鹏跃 on 17/8/16.
//  Copyright © 2017年 Koalareading. All rights reserved.
//

import UIKit
///左右的label
class KRMine_UesrInfoCell: UITableViewCell {
    var isHaveArrow: Bool = false
    //颜色
    var leftColor = UIColor.c_0x333333
    var rightColor = UIColor.c_0x999999
    
    //字体
    var leftFont = UIFont.kr_font(size: 30)
    var rightFont = UIFont.kr_font(size: 30)
    
    var rightLableDelegate: UITextFieldDelegate?
    
    //image
    var rightImageUrl:String?
    
    
    
    var isImageCircular: Bool {
        didSet {
            if isImageCircular {
                self.rightImageView.layer.cornerRadius = UIScreen.kViewCurrentH(H: 115.0/2)
                self.rightImageView.layer.masksToBounds = true
                return
            }
            self.rightImageView.layer.cornerRadius = 0
            self.rightImageView.layer.masksToBounds = false
        }
    }
    
    //str
    var leftStr: String = ""
    var rightStr: String = ""
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        isImageCircular = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUP()
    }
  
    private func setUP() {
        self.setUPSubView()
    }
    
    override func didMoveToSuperview() {
        self.setUPValue()
    }
    
    
    func setUPValue() {
        self.leftLable.font = leftFont
        self.rightLabel.font = rightFont
        
        self.leftLable.textColor = leftColor
        self.rightLabel.textColor = rightColor
        
        self.leftLable.text = leftStr
        self.rightLabel.text = rightStr
        
        self.rightLabel.isHidden = rightImageUrl?.length != nil
        
        self.rightLabel.delegate = self.rightLableDelegate
        self.rightLabel.isUserInteractionEnabled = self.rightLableDelegate != nil
        
        if rightImageUrl?.length != nil {
            self.rightImageView.imageName = rightImageUrl ?? ""
            self.rightImageView.isHidden = false
        }
        
        if isHaveArrow {
            self.accessoryType = .disclosureIndicator
            rightLabel.snp.updateConstraints { (make) in
                make.right.equalTo(contentView).offset(UIScreen.kViewCurrentW(W: -19))
            }
            return
        }
        
        rightLabel.snp.updateConstraints { (make) in
            make.right.equalTo(contentView).offset(UIScreen.kViewCurrentW(W: -30))
        }
        self.accessoryType = .none
    }

    
    private func setUPSubView() {
        
        self.leftLable.font = UIFont.kr_font(size: 30)
        self.rightLabel.font = UIFont.kr_font(size: 30)
        
        self.leftLable.textColor = UIColor.c_0x333333
        self.rightLabel.textColor = UIColor.c_0x999999
        self.rightLabel.isUserInteractionEnabled = false
        self.rightLabel.textAlignment = NSTextAlignment.right
        
        
        rightImageView.isHidden = true
        
        self.contentView.addSubview(leftLable)
        self.contentView.addSubview(rightLabel)
        self.contentView.addSubview(rightImageView)
        
        
        leftLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(UIScreen.kViewCurrentW(W: 29))
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(UIScreen.kViewCurrentW(W: -30))
            make.left.equalTo(self.leftLable.snp.right).offset(UIScreen.kViewCurrentW(W: 20))
            make.bottom.top.equalTo(self.contentView)
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(UIScreen.kViewCurrentW(W: -19))
            make.top.equalTo(self.contentView).offset(UIScreen.kViewCurrentH(H: 21))
            make.width.height.equalTo(UIScreen.kViewCurrentH(H: 115))
        }
    }
    
    
    //MARK: 私有属性
    private let leftLable = UILabel()
    private let rightLabel = UITextField()
    private let rightImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

