//
//  PlayersListView.swift
//  basketballGameStatsTrack (iOS)
//
//  Created by 范志勇 on 2022/11/18.
// 

import SwiftUI
import CoreData

/// 列表
///
/// 操作
/// - 删除
/// - 增加
/// - 修改
struct PlayersListView: View {
    //MARK: 配置：数据
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Player.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    )
    private var players: FetchedResults<Player>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(players, id: \.self) { player in
                    
                    NavigationLink {
                        // 修改
                        EditPlayerView(player: player)
                    } label: {
                        HStack {
                            Text("\(player.id)")
                            Spacer()
                            Text(player.name)
                            Spacer()
                            Text(player.fullName)
                        }
                        
                    }
                }
                // 删除
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Players List")
            .toolbar {
                ToolbarItem {
                    // 新增：player
                    NavigationLink {
                        NewPlayerView()
                    } label: {
                        Label("Add Player", systemImage: "plus")
                    }
                }
            }
        }
        
    }
    
//    private func addPlayer() {
//        withAnimation {
//            let newItem = Player(context: viewContext)
//            newItem.name = "Player Name"
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
    
    /// 删除
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { players[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct PlayersListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersListView()
    }
}
