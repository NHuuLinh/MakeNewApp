//
//  HomeViewController.swift
//  Newsapp
//
//  Created by LinhMAC on 27/08/2023.
//

import UIKit
import Alamofire


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var homeTableView: UITableView!
    
    enum HomeNewsSection: Int {
        case trendingNews = 0
        case latestNews = 1
    }
    private var sections = [HomeNewsSection]()
    private var trendingNews = [NewsEntity]()
    private var latestNews = [NewsEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        // Khởi tạo mảng sections
        sections = [HomeNewsSection.trendingNews, .latestNews]
        homeTableView.reloadData()
        
        getTrendingNews()
        getLatetestNews()
    }
    
    private func setupTableView() {
        homeTableView.dataSource = self // self chính instance  của HomeViewController
        
        homeTableView.delegate = self
        
        homeTableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LatestNewsTableViewCell", bundle: nil)
        homeTableView.register(nib, forCellReuseIdentifier: "LatestNewsTableViewCell")
        
        let nib2 = UINib(nibName: "Demo2TableViewCell", bundle: nil)
        homeTableView.register(nib2, forCellReuseIdentifier: "Demo2TableViewCell")
        
        let trendingCell = UINib(nibName: "TrendingTableViewCell", bundle: nil)
        homeTableView.register(trendingCell, forCellReuseIdentifier: "TrendingTableViewCell")
        
        /// Có thể đăng ký nhiều
    }
    
    private func getTrendingNews() {
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/posts",
                   method: .get,
                   parameters: [
                        "is_trending": 1,
                        "page": 1,
                        "pageSize": 20
                    ],
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: [
                    "Authorization": "Bearer \(AuthService.shared.getAccessToken() ?? "")"
                   ])
        .validate(statusCode: 200..<299)
        .responseDecodable(of: ArrayResponse<NewsEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                if let newsList = data.data {
                    self.trendingNews = newsList
                    self.homeTableView.reloadData()
                }
                break
            case .failure(let err):
                print(err.errorDescription)
                break
            }
        }
    }
    
    private func getLatetestNews() {
        AF.request("http://ec2-52-195-148-148.ap-northeast-1.compute.amazonaws.com/posts",
                   method: .get,
                   parameters: [
                        "page": 1,
                        "pageSize": 20
                    ],
                   encoder: URLEncodedFormParameterEncoder.default,
                   headers: [
                    "Authorization": "Bearer \(AuthService.shared.getAccessToken() ?? "")"
                   ])
        .validate(statusCode: 200..<299)
        .responseDecodable(of: ArrayResponse<NewsEntity>.self) { (afDataResponse) in
            switch afDataResponse.result {
            case .success(let data):
                if let newsList = data.data {
                    self.latestNews = newsList
                    self.homeTableView.reloadData()
                }
                break
            case .failure(let err):
                print(err.errorDescription)
                break
            }
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        AuthService.shared.clearAccessToken()

        if let uwWindow = (UIApplication.shared.delegate as? AppDelegate)?.window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            let loginNavigation = UINavigationController(rootViewController: loginVC)
            uwWindow.rootViewController = loginNavigation
            uwWindow.makeKeyAndVisible()
        } else {
            print("error")
        }
    }
    func getKeyWindowC1() -> UIWindow? {
        let keyWindow = (UIApplication.shared.delegate as? AppDelegate)?.window
        return keyWindow
    }
    
    func getKeyWindowC2() -> UIWindow? {
        let keyWindow = UIApplication.shared
            .connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return keyWindow
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /// Section với index là 0 thì là section cho trending news
        /// Section với index là 1 thì là section cho latest news
        return sections.count
    }
    
    /// Chỉ đinh số lượng items trong 1 sections
    /// 1 tableview có thể có nhiều section
    /// Section cơ bản là 1 group các item giống nhau.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let homeSection = HomeNewsSection(rawValue: section)
        
        switch homeSection {
        case .trendingNews:
            return trendingNews.count // return theo design
        case .latestNews:
            return latestNews.count // fake
        default:
            return 0
        }
    }
    
    /// cellForRowAt
    /// Mn define ra 1 đối tượng của UITableViewCell để hiển thị lên data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeSection = HomeNewsSection(rawValue: indexPath.section)
        switch homeSection {
        case .trendingNews:
            /// Sử dụng custom view cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell", for: indexPath) as! TrendingTableViewCell
            
            let news = trendingNews[indexPath.row]
            cell.bindData(news: news)
            
            return cell
        case .latestNews:
            /// Sử dụng custom view cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "LatestNewsTableViewCell", for: indexPath) as! LatestNewsTableViewCell
            let news = latestNews[indexPath.row]
            cell.bindData(news: news)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TAP vào cell ở vị trí thứ: \(indexPath.row + 1)")
    }
}

