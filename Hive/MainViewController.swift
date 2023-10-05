//
//  ViewController.swift
//  Hive
//
//  Created by Tushar Tayal on 04/10/23.
//

import UIKit

class MainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let viewModel = MainViewModel()
    var wikiResponse: WikipediaResponse?
    var filteredData: [String: Page]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.searchTableData { [weak self] data in
            self?.wikiResponse = data
            self?.filteredData = data.query.pages
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        setup()
        setupConstraints()
    }
    
    private func setup() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search Wikipedia"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell1")
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            searchBar.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }


}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filteredData = filteredData else {
            return 0
        }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! CustomTableViewCell
        cell.contentView.backgroundColor = .yellow
        let data = filteredData?.values.sorted(by: {$0.pageid < $1.pageid})[indexPath.row]
        cell.configure(title: data?.title ?? "", imageThumbnail: data?.thumbnail)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Results"
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredData = wikiResponse?.query.pages
        }
        else {
            filteredData = wikiResponse?.query.pages.filter { $0.value.title.localizedCaseInsensitiveContains(searchText) }
        }
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
}


class CustomTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = UILabel()
    let imageVieww = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupConstraints()
    }
    
    private func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageVieww.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageVieww)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageVieww.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            imageVieww.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            imageVieww.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: imageVieww.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: imageVieww.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageVieww.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, imageThumbnail: Thumbnail? = nil) {
        titleLabel.text = title
        guard let imageThumbnail = imageThumbnail else {
            NSLayoutConstraint.activate([
                imageVieww.widthAnchor.constraint(equalToConstant: 0)
            ])
            return
        }
        NSLayoutConstraint.activate([
            imageVieww.heightAnchor.constraint(equalToConstant: CGFloat(imageThumbnail.height)),
            imageVieww.widthAnchor.constraint(equalToConstant: CGFloat(imageThumbnail.width))
        ])
        imageVieww.load(urlString: imageThumbnail.source)
        imageVieww.layoutIfNeeded()
    }
}
