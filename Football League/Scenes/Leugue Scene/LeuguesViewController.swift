//
//  ViewController.swift
//  Football League
//
//  Created by Arabia-IT on 11/18/18.
//  Copyright © 2018 Arabia-IT. All rights reserved.
//

import UIKit
import RxSwift

protocol LeagesView: class {
    func updateData()
    func presentTeamsViewController(withLeagueId leagueId: Int)
}

class LeuguesViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private var leagues: [LeagueScreenData] = []
    @IBOutlet weak var leaguesTableView: UITableView!
    private lazy var leaguesViewModel = {
       return LeaguesViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeaguesTableview()
        setupLeagesSubscribers()
    }
    private func setupLeaguesTableview() {
          registerLeaguesTableCells()
          leaguesTableView.estimatedRowHeight = 100
          leaguesTableView.rowHeight = UITableView.automaticDimension
      }
      private func registerLeaguesTableCells() {
          let leagueCellNib = UINib(nibName: LeagueCell.identifier, bundle: nil)
          leaguesTableView.register(leagueCellNib, forCellReuseIdentifier: LeagueCell.identifier)
      }
    private func setupLeagesSubscribers() {
        leaguesViewModel.leaguesSubject.subscribe({
            [weak self] event in
            if let element = event.element {
                self?.handleLeaguesScreenData(screenData: element)
            }
            }).disposed(by: disposeBag)
    }
    private func handleLeaguesScreenData(screenData: LeaguesScreenData) {
        switch screenData {
        case .loading: break
        case .success(let leagues): handleLeagues(leagues: leagues)
        case .failure(error: let error): break
        }
    }
    private func handleLeagues(leagues: [LeagueScreenData]) {
        self.leagues = leagues
        leaguesTableView.reloadData()
    }
    
  
}

extension LeuguesViewController: LeagesView {
    
    func presentTeamsViewController(withLeagueId leagueId: Int) {
        perform(segue: Segues.TeamsViewController.rawValue) { (teamsViewController: TeamsViewController) in
            teamsViewController.leagueId = leagueId
        }
    }
    
    func updateData() {
        print("data updated successfully")
        leaguesTableView.reloadData()
    }
}

extension LeuguesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leagueCell = tableView.dequeueReusableCell(withIdentifier: LeagueCell.identifier) as! LeagueCell
        leagueCell.leagueNameLabel.text = leagues[indexPath.row].name
        leagueCell.containerView.backgroundColor = leagues[indexPath.row].hasMoreInfo ? UIColor.green : .red
        return leagueCell
    }
}

extension LeuguesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        leaguesViewModel.didSelectRowAt(index: indexPath.row)
    }
}

