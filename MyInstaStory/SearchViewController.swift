//
//  SearchViewController.swift
//  MyInstaStory
//
//  Created by park kyung suk on 2017/08/16.
//  Copyright © 2017年 park kyung suk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .minimal
        sb.placeholder = "Search"
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        searchBar.frame.size.width = view.frame.size.width - 60
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
}
