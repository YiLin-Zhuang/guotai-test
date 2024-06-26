//
//  ViewController.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit
//import SkeletonView

class HomeViewController: UIViewController {
    
    @IBOutlet fileprivate weak var eyeButton: UIButton!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var tabbarView: UIView!
    @IBOutlet fileprivate weak var adView: UIView!
    @IBOutlet fileprivate weak var usdAmountLabel: UILabel!
    @IBOutlet fileprivate weak var khrAmountLabel: UILabel!
    @IBOutlet fileprivate weak var bellButton: UIButton!
    
    fileprivate lazy var adbannerView: UIScrollView = {
        let adbannerView = UIScrollView()
        let width: Int = Int(adView.bounds.width)
        let height = 90
        adbannerView.showsHorizontalScrollIndicator = false
        adbannerView.contentSize = CGSize(width: width * 3, height: height)
        adbannerView.contentOffset = CGPoint(x: width, y: 0)
        adbannerView.isPagingEnabled = true
        adbannerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        rightImageView.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        currentImageView.frame = CGRect(x: width * 1, y: 0, width: width, height: height)
        leftImageView.frame = CGRect(x: width * 0, y: 0, width: width, height: height)
        adbannerView.addSubview(rightImageView)
        adbannerView.addSubview(currentImageView)
        adbannerView.addSubview(leftImageView)
        adbannerView.delegate = self
        return adbannerView
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = .clear
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = UIColor(white: 136.0 / 255.0, alpha: 1.0)
        pageControl.numberOfPages = viewModel.data?.adBanner.count ?? 0
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    fileprivate lazy var usdLodingView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0,y: 0),size: lodingViewSize))
        view.backgroundColor = .darkGray
        view.alpha = 0.1
        return view
    }()
    fileprivate lazy var khrLodingView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0,y: 0),size: lodingViewSize))
        view.backgroundColor = .darkGray
        view.alpha = 0.1
        return view
    }()
    
    @IBAction fileprivate func showAmount(_ sender: UIButton) {
        let isShow = sender.image(for: .normal) == UIImage(named: "iconEyeOff")
        let eyeIcon = isShow ? UIImage(named: "iconEyeOn") : UIImage(named: "iconEyeOff")
        sender.setImage(eyeIcon, for: .normal)
        
        if isShow, let data = viewModel.data {
            usdAmountLabel.text = "\(data.usdSum)"
            khrAmountLabel.text = "\(data.khrSum)"
        } else {
            usdAmountLabel.text = "********"
            khrAmountLabel.text = "********"
        }
        
    }
    
    @IBAction func goToNotificationPage(_ sender: UIButton) {
        guard let notificationViewModel = viewModel.data?.notification else { return }
        Router.open(RouterPath.notificationPage(notificationViewModel), present: false)
    }
    //MARK: - Variables
    
    fileprivate lazy var controller: HomeController = {
        return HomeController()
    }()
    
    fileprivate var viewModel: HomeViewModel {
        return controller.viewModel
    }
    
    fileprivate var refreshControl:UIRefreshControl!
    
    fileprivate var currentIndex : NSInteger = 1
    fileprivate var leftImageView = UIImageView()
    fileprivate var rightImageView = UIImageView()
    fileprivate var currentImageView = UIImageView()
    fileprivate var timer: Timer? = nil
    
    fileprivate var startLoding: (() -> ())?
    fileprivate var stopLoding: (() -> ())?
    fileprivate var animator: UIViewPropertyAnimator!
    fileprivate let lodingViewSize = CGSize(width: 50, height: 50)
    
    //MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLodingAnimator()
        initBinding()
        controller.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    deinit {
        print("HomeViewController deinit")
    }
    //MARK: - Func
    
    fileprivate func setupUI() {
        self.tabbarView.layer.shadowOffset = CGSizeMake(5, 5)
        self.tabbarView.layer.shadowOpacity = 0.2
        self.tabbarView.layer.shadowRadius = 5
        self.tabbarView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
        guard let data = viewModel.data else { return }
        
        self.usdAmountLabel.backgroundColor = .clear
        self.khrAmountLabel.backgroundColor = .clear
        
        let isShow = eyeButton.image(for: .normal) != UIImage(named: "iconEyeOff")
        if isShow {
            self.usdAmountLabel.text = "\(data.usdSum)"
            self.khrAmountLabel.text = "\(data.khrSum)"
        } else {
            self.usdAmountLabel.text = "********"
            self.khrAmountLabel.text = "********"
        }
        
        if data.notification?.messages.count != 0 {
            self.bellButton.setImage(UIImage(named: "iconBellActive"), for: .normal)
        }
        
        self.collectionView.reloadData()
        
        if timer == nil, !data.adBanner.isEmpty {
            self.adView.addSubview(self.adbannerView)
            self.scrollView.addSubview(self.pageControl)
            self.pageControl.translatesAutoresizingMaskIntoConstraints = false
            self.pageControl.leftAnchor.constraint(equalTo: self.adView.leftAnchor).isActive = true
            self.pageControl.rightAnchor.constraint(equalTo: self.adView.rightAnchor).isActive = true
            self.pageControl.topAnchor.constraint(equalTo: self.adView.bottomAnchor).isActive = true
            self.setupTimer()
            self.reloadImage()
            
        }
        
    }
    func setupLodingAnimator() {
        self.startLoding = {
            self.usdLodingView.frame.origin.x = 0
            self.khrLodingView.frame.origin.x = 0
            self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                self.usdLodingView.frame.origin.x = UIScreen.main.fixedCoordinateSpace.bounds.size.width - self.lodingViewSize.width
                self.khrLodingView.frame.origin.x = UIScreen.main.fixedCoordinateSpace.bounds.size.width - self.lodingViewSize.width
            })
            
            self.animator.addCompletion { position in
                if position == .end {
                    self.startLoding?()
                }
            }
            
            self.animator.startAnimation()
        }
        
        self.stopLoding = {
            self.usdLodingView.removeFromSuperview()
            self.khrLodingView.removeFromSuperview()
        }
        
        self.usdAmountLabel.addSubview(usdLodingView)
        self.khrAmountLabel.addSubview(khrLodingView)
    }
    
    fileprivate func initBinding() {
        viewModel.endRefreshing = { [weak self] in
            self?.refreshControl.endRefreshing()
        }
        
        viewModel.$data { [weak self] data in
            guard let self, data != nil else { return }
            self.setupUI()
        }
        
        viewModel.$loading { [weak self] loading in
            guard let self else { return }
            if loading {
                self.startLoding?()
            } else {
                self.animator.stopAnimation(true)
                self.stopLoding?()
            }
            
        }
    }
    
    @objc fileprivate func refresh() {
        controller.refreshData()
    }
    
    fileprivate func reloadImage(){
         var leftIndex = 0
         var rightIndex = 0
         guard let adBanners = viewModel.data?.adBanner else { return }
         currentIndex = currentIndex % adBanners.count
         adbannerView.setContentOffset(CGPoint(x: adView.bounds.width, y: 0), animated: false)
         pageControl.currentPage = (currentIndex - 1 + adBanners.count) % adBanners.count
         leftIndex = (currentIndex - 1 + adBanners.count) % adBanners.count
         rightIndex = (currentIndex + 1) % adBanners.count
         rightImageView.image = adBanners[rightIndex]
         currentImageView.image = adBanners[currentIndex]
         leftImageView.image = adBanners[leftIndex]
        
    }
    
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3,target:self,selector:#selector(timeChanged),userInfo:nil,repeats:true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc fileprivate func timeChanged(){
        currentIndex = currentIndex + 1
        reloadImage()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = viewModel.data?.favorite.count else { return 0 }
        
        collectionView.backgroundView = count == 0 ? EmptyFavoriteView() : nil
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FavoriteCell,
              let cellViewModel = viewModel.data?.favorite[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.setup(cellViewModel)
        
        return cell
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let adBannerCount = viewModel.data?.adBanner.count ?? 0
        if scrollView.contentOffset.x > adView.bounds.width {
            currentIndex = (currentIndex + 1) % adBannerCount
        }
        
        if scrollView.contentOffset.x < adView.bounds.width {
            currentIndex = (currentIndex - 1 + adBannerCount) % adBannerCount
        }
        
        pageControl.currentPage = (currentIndex - 1 + adBannerCount) % adBannerCount
        reloadImage()
        setupTimer()
    }
}
