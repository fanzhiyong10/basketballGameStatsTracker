//
//  ContentView.swift
//  Shared
//
//  Created by 范志勇 on 2022/11/18.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - 全局环境变量 项目创建时，自动生成
    @Environment(\.managedObjectContext) private var viewContext

    //MARK: - 读数据 项目创建时，自动生成
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    //MARK: - 左侧菜单
    private var items_menu: [String] = ["New Game", "Share", "Voice Training", "Team Info", "Players"]
    
    //MARK: - 全局环境变量 状态控制，声明
    @EnvironmentObject var mainStates: MainStateControl
    
    //MARK: -  我队的比赛数据 1.必须确保生成
    @EnvironmentObject var myTeamInfo: MyTeamInfo

    //MARK: -  队员的实时比赛数据，声明时要初始化
    @State private var liveDatas : [LiveData] = LiveData.createData() // 所有队员

    init() {
        // 加载点
        PreinstallData()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items_menu.indices, id: \.self) { index in
                    NavigationLink {
                        switch index {
                        case 0 :
                            // New Game
                            // 新比赛
                            GameTracker()
//                            SelectTeam()
//                            MainTracker(liveDatas: $liveDatas)

                        case 1 :
                            // Share
                            Text(items_menu[index])
                            
                        case 2 :
                            // Voice Training
                            Text(items_menu[index])
                            
                        case 3 :
                            // Teams
                            TeamsListView()
                            
                        case 4 :
                            // Players
                            PlayersListView()
                            
                        default :
                            // 主页面
                            Text(items_menu[index])
                        }
                        
                    } label: {
                        Text(items_menu[index])
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(SidebarListStyle())
            .navigationTitle(Text("Game Tracker"))
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            
            Text("首页：欢迎界面")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainStateControl())
            .environmentObject(MyTeamInfo())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
