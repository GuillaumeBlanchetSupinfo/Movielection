//
//  FilmDetailsViewModelTest.swift
//  MovielectionTests
//
//  Created by DotVision DotVision on 14/05/2020.
//  Copyright © 2020 Guillaume Blanchet. All rights reserved.
//

import XCTest
@testable import Movielection

class FilmDetailsViewModelTest: XCTestCase {

    var vm: FilmDetailsViewModel!
    var filmDetailsController: FilmDetailsController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        filmDetailsController = storyboard.instantiateViewController(withIdentifier: "FilmDetailsController") as! FilmDetailsController
        _ = filmDetailsController.view
        
        vm = FilmDetailsViewModel()
        vm.movie = Movie(id: 12345, title: "StarWars", imgURI: "URI", overview: "Galaxy lointaine", img: nil)
        vm.moviesList = [
            Movie(id: 12345, title: "StarWars", imgURI: "URI", overview: "Galaxy lointaine", img: nil),
            Movie(id: 12345, title: "StarWars", imgURI: "URI", overview: "Galaxy lointaine", img: nil),
            Movie(id: 12345, title: "StarWars", imgURI: "URI", overview: "Galaxy lointaine", img: nil),
            Movie(id: 12345, title: "StarWars", imgURI: "URI", overview: "Galaxy lointaine", img: nil)]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGivenMovieNotSelected_WhenClickAdd_ThenMovieIsSelected() {
        vm.add(filmDetailsController)
        XCTAssert(vm.movie.selected)
    }



    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
