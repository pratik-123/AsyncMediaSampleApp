//
//  AsyncMediaSampleApp.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import SwiftUI

@main
struct AsyncMediaSampleApp: App {
    var body: some Scene {
        WindowGroup {
            let useLocal = false
            let dataSource: DataSource = useLocal
                ? LocalDataSource(fileName: "ImageList")
            : RemoteDataSource(urlString: Endpoints.imageItemsURL)
            ImageListView(viewModel: ImageListViewModel(dataSource: dataSource))
        }
    }
}
