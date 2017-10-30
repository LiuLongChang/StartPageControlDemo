//
//  PageControlSwift.swift
//  StartPageControlDemo
//
//  Created by zgzzzs on 2017/10/30.
//  Copyright © 2017年 zzzsw. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

let kHighlighted = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
let kBtnBackgroundColor = UIColor.clear





class PageControlSwift: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    /*分区数*/
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    /*每个分区含有的item个数*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageListCount!;
    }

    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    //最小 行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    //item尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pageControlCellId, for: indexPath) as! PageControlCollectionViewCell

        cell.contentView.backgroundColor = .black

        cell.imageV?.image = UIImage(named: self.imageList![indexPath.row] as! String)


        return cell;
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var collectionView : UICollectionView?
    var pageControl : UIPageControl?
    var cancenBtn : UIButton?
    let pageControlCellId = "cellid"
    var imageListCount : Int? = nil
    var imageList : Array<Any>?


    override init(frame: CGRect) {
        super.init(frame: frame);



    }

    typealias pageNumClosure = (_ selectIndex : Int) -> Void
    var pageClosure : pageNumClosure?
    typealias touchBtnClosure  = ()->Void
    var touchClosure : touchBtnClosure?



    class func setUpPageControlView(imagesList:Array<Any>,closure:pageNumClosure?,touchClosure:@escaping touchBtnClosure){

        let pageControlView = PageControlSwift(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        pageControlView.backgroundColor = .red

        let windowView : UIView! = (UIApplication.shared.delegate?.window)! as UIView!

        windowView.addSubview(pageControlView);

        windowView.backgroundColor = UIColor.purple;


        pageControlView.setValues(imageList: imagesList)
        pageControlView.setupUI()
        pageControlView.pageClosure = closure
        pageControlView.touchClosure = touchClosure


    }


    func setValues(imageList:Array<Any>){
        self.imageListCount = imageList.count
        self.imageList = imageList;
    }


    func setupUI(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true;
        collectionView?.bounces = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.cyan;
        collectionView?.register(PageControlCollectionViewCell.self, forCellWithReuseIdentifier: pageControlCellId)

        self.addSubview(collectionView!);



        pageControl = UIPageControl(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 30))
        pageControl?.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height-(pageControl?.frame.size.height)!)
        pageControl?.backgroundColor = .clear
        pageControl?.numberOfPages = self.imageListCount!;
        pageControl?.currentPage = 0;
        //设置单页时隐藏
        pageControl?.hidesForSinglePage = true
        //设置显示颜色
        pageControl?.currentPageIndicatorTintColor = .green;
        //设置页背景指示颜色
        pageControl?.pageIndicatorTintColor = .lightGray;
        self.addSubview(pageControl!);

        //取消按钮
        cancenBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width*0.5, height: self.frame.size.height*0.08))
        cancenBtn?.center = CGPoint.init(x: self.frame.size.width/2, y: (self.pageControl?.frame.origin.y)! - (self.cancenBtn?.frame.size.height)!/2-10)
        cancenBtn?.backgroundColor = kBtnBackgroundColor
        cancenBtn?.layer.masksToBounds = true
        cancenBtn?.layer.cornerRadius = (cancenBtn?.frame.size.height)!/2;
        cancenBtn?.layer.borderColor = UIColor.white.cgColor;
        cancenBtn?.layer.borderWidth = 1.0;
        cancenBtn?.setTitle("立即体验", for: .normal);
        cancenBtn?.addTarget(self, action: #selector(PageControlSwift.buttonBackgroundHighlighted(_:)), for: .touchDown);
        cancenBtn?.addTarget(self, action: #selector(PageControlSwift.removeViewBtn(_:)), for: .touchUpInside);

        self.addSubview(cancenBtn!);

        if self.imageListCount == 1 {
            cancenBtn?.isHidden = false;
        }else{
            cancenBtn?.isHidden = true;
        }

    }

    @objc func buttonBackgroundHighlighted(_ btn:UIButton){
        btn.backgroundColor = kHighlighted;
    }

    @objc func removeViewBtn(_ btn:UIButton){
        btn.backgroundColor = kBtnBackgroundColor;
        self.touchClosure!();
        self.removeFromSuperview();
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的第几页
        let page = Int(scrollView.contentOffset.x/scrollView.frame.size.width);
        //设置pageController的当前页
        pageControl?.currentPage = page
        if page == self.imageListCount!-1 {
            print("最后一页了");
        };pageClosure!(page);
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x/self.frame.size.width) == (self.imageList?.count)! - 1 {
            cancenBtn?.isHidden = false;
        }else{
            cancenBtn?.isHidden = true;
        }
    }




    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}






class PageControlCollectionViewCell: UICollectionViewCell {

    var imageV : UIImageView?


    override init(frame: CGRect) {
        super.init(frame: frame);
        imageV = UIImageView(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(imageV!);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}
