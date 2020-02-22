//
//  LeaguesViewModel.swift
//  Football League
//
//  Created by Amr AbdelWahab on 2/22/20.
//  Copyright © 2020 Arabia-IT. All rights reserved.
//

import Foundation
import RxSwift

enum LeaguesScreenData {
    case success([LeagueScreenData])
    case loading
    case failure(error:String)
}
struct LeagueScreenData {
    let name: String
    let hasMoreInfo: Bool
}

class LeaguesViewModel {
    private var disposeBage = DisposeBag()
    private var dataSource: LeaguesDataSource
    private var localDataSource: LeaguesDataSource
    typealias loadLeagesUseCaseType = (LeaguesDataSource,LeaguesDataSource)->(Single<LeaguesScreenData>)
    private var loadLeaguesUseCase: loadLeagesUseCaseType
    var leaguesSubject = BehaviorSubject<LeaguesScreenData>(value: .loading)
    init(dataSource: LeaguesDataSource = MoyaLeagesDataSource(),
         localDataSource: LeaguesDataSource = RealmLeaguesDataSource(),
         loadLeaguesUseCase: @escaping loadLeagesUseCaseType = fetchLeagues) {
        self.dataSource = dataSource
        self.localDataSource = localDataSource
        self.loadLeaguesUseCase = loadLeaguesUseCase
        loadData()
    }
    private func loadData() {
        loadLeaguesUseCase(dataSource,localDataSource).subscribe(onSuccess: {[weak self] leagueScreenData in
            self?.leaguesSubject.onNext(leagueScreenData)
        }, onError: { [weak self] error in
            self?.leaguesSubject.onNext(.failure(error: "Server Error"))
            }).disposed(by: disposeBage)
    }
    func didSelectRowAt(index: Int ) {
        
    }
}

