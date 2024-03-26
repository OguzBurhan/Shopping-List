//
//  ContentView.swift
//  Shopping-List
//
//  Created by Oguz Burhan on 2024-03-21.
//
//Oguzhan Burhan    101354137
//Atakan Arikan 101307095
//Alper Ekici 101212904
//Ruslan Makhanov 101320843

import SwiftUI
import CoreData


struct ContentView: View {
    @EnvironmentObject var loginManager: LoginManager // Use the login manager

    var body: some View {
        if loginManager.isLoggedIn {
            // User is logged in, show the main tab view
            MainTabView()
        } else {
            // User is not logged in, show the WelcomeScreen
            WelcomeScreen()
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var loginManager: LoginManager // Use the login manager

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ShoppingListScreen()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Shopping List")
                }
            ProductDetailView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Product Detail")
                }
        }

    }
}


struct WelcomeScreen: View {
    var body: some View {
        NavigationView {
            VStack {
//                Image("welcome-image")
//                    .resizable()
//                    .scaledToFit()
                Text("Shop-Track")
                    .font(.largeTitle)
                    .padding()
                Text("Stay organized with our app")
                    .font(.subheadline)
                    .padding()
                NavigationLink(destination: LoginView()) {
                    Text("Start")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }


            }
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingRegistration = false
    @State private var errorMessage: String?
    var body: some View {
        VStack {
            // Logo image at the top
            Image("shop-track")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            // Email input field
            TextField("Enter your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Password input field
            SecureField("Enter your password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Login button
            Button("Log in") {
                loginManager.login(email: email, password: password)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()

            // Registration navigation button
            Button("Don't have an account? Sign up") {
                showingRegistration = true
            }
            .sheet(isPresented: $showingRegistration) {
                RegistrationView()
            }
        }
        .padding()
    }

}


struct RegistrationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var registrationFailed: Bool = false
    @State private var failureMessage: String = "An unknown error has occurred."

    var body: some View {
        NavigationView {
            VStack {
                Image("logo") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .textContentType(.oneTimeCode)
                SecureField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .textContentType(.oneTimeCode)
                
                Button("Register") {
                    registerUser()
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if registrationFailed {
                    Text(failureMessage)
                        .foregroundColor(.red)
                }
                
                Spacer()
            }
            .navigationBarTitle("Register", displayMode: .inline)
            .padding()
        }
    }
    
    private func registerUser() {
        print("Attempting to register user with email: \(email) and password: \(password)")
        
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            registrationFailed = true
            failureMessage = "Please ensure all fields are filled correctly and passwords match."
            print("Registration failed: fields are not filled correctly or passwords do not match.")
            return
        }
        
        // Create and save the new user
        let newUser = User(context: viewContext)
        newUser.email = email
        newUser.password = password
        
        do {
            try viewContext.save()
            print("User successfully registered and saved.")
            presentationMode.wrappedValue.dismiss()
        } catch let error as NSError {
            registrationFailed = true
            failureMessage = "Registration failed: \(error.localizedDescription)"
            
            // More detailed error diagnostics
            print("Registration error: \(error), \(error.userInfo)")
        }
    }
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let category: String
}



struct HomeView: View {
    @EnvironmentObject var loginManager: LoginManager
    @State private var searchText: String = ""
    @State private var selectedCategory: String? = nil

    let products: [Product] = [
        // Bakery
        Product(name: "Whole Wheat Bread", description: "Organic whole wheat bread.", category: "Bakery"),
        Product(name: "Croissant", description: "Buttery and flaky French croissant.", category: "Bakery"),
        // Beverages
        Product(name: "Apple Juice", description: "Freshly squeezed apple juice.", category: "Beverages"),
        Product(name: "Green Tea", description: "Refreshing and healthy green tea.", category: "Beverages"),
        // Dairy
        Product(name: "Cheddar Cheese", description: "Aged cheddar cheese with a deep flavor.", category: "Dairy"),
        Product(name: "Greek Yogurt", description: "Thick and creamy Greek yogurt.", category: "Dairy"),
        // Meat
        Product(name: "Grass-fed Beef Steak", description: "Premium grass-fed beef steak.", category: "Meat"),
        Product(name: "Organic Chicken Thighs", description: "Juicy and tender organic chicken thighs.", category: "Meat"),
        // Electronics
        Product(name: "Wireless Earbuds", description: "High-quality sound and noise cancellation.", category: "Electronics"),
        Product(name: "Smart Watch", description: "Stay connected with notifications and health tracking.", category: "Electronics")
    ]

    let categories: [(icon: String, name: String)] = [
        ("applescript", "Bakery"),
        ("cart", "Beverages"),
        ("house", "Dairy"),
        ("tray", "Meat"),
        ("desktopcomputer", "Electronics")
    ]
    
    // This filters products first by selected category, then by search text.
    var filteredProducts: [Product] {
        products.filter { product in
            (selectedCategory == nil || product.category == selectedCategory) &&
            (searchText.isEmpty || product.name.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        VStack {
            SearchAndLogoutView(searchText: $searchText, loginManager: loginManager)
            
            // The rest of your HomeView content
            CategoryScrollView(categories: categories, selectedCategory: $selectedCategory)
            ProductGridView(products: filteredProducts)
            
            Spacer()
        }
    }
}

struct SearchAndLogoutView: View {
    @Binding var searchText: String
    var loginManager: LoginManager
    
    var body: some View {
        HStack {
            TextField("Search products", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                // Currently does nothing, could be used to initiate a search
            }) {
                Image(systemName: "magnifyingglass")
            }
            
            Button(action: {
                loginManager.logout()
            }) {
                Image(systemName: "power")
                    .foregroundColor(.blue)
                    .imageScale(.large)
            }
            .padding(.leading, 10)
        }
        .padding()
    }
}

struct CategoryScrollView: View {
    let categories: [(icon: String, name: String)]
    @Binding var selectedCategory: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(categories, id: \.name) { category in
                    Button(action: {
                        self.selectedCategory = category.name
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: category.icon)
                                .imageScale(.large)
                                .foregroundColor(.blue)

                            Text(category.name)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(self.selectedCategory == category.name ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ProductGridView: View {
    let products: [Product]
    @EnvironmentObject var shoppingListManager: ShoppingListManager
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products) { product in
                    VStack(alignment: .leading) {
                        // Placeholder for product image
                        Rectangle()
                            .fill(Color.secondary)
                            .aspectRatio(1, contentMode: .fit)

                        Text(product.name)
                            .font(.headline)

                        Text(product.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        Button(action: {
                            shoppingListManager.addProduct(product.name)
                        }) {
                            Text("Add to Shopping List")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal)
        }
    }
}


struct ShoppingListScreen: View {
    // Shopping list items
    struct ShoppingItem {
        var name: String
        var isChecked: Bool
    }
    
    // Shopping list categories and items
    let shoppingListData: [(category: String, items: [ShoppingItem])] = [
        ("Fruits and Vegetables", [ShoppingItem(name: "Apples", isChecked: false), ShoppingItem(name: "Bananas", isChecked: true)]),
        ("Dairy Products", [ShoppingItem(name: "Milk", isChecked: false), ShoppingItem(name: "Cheese", isChecked: true)]),
        
    ]
    
    var body: some View {
        List {
            ForEach(shoppingListData, id: \.category) { section in
                Section(header: Text(section.category).font(.headline)) {
                    ForEach(section.items, id: \.name) { item in
                        HStack {
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isChecked ? .green : .gray)
                            Text(item.name)
                        }
                        .onTapGesture {
                            // Handle item check action
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Shopping List") // TODO: Set the navigation bar title if within a NavigationView
    }
}


struct ProductDetailView: View {
    // Example product data
    var productName: String = "Product Name"
    var productDescription: String = "This is the product description where you detail the features of the product."
    

    var relatedProducts: [String] = ["Product 1", "Product 2", "Product 3"]
    var comments: [String] = ["Comment 1", "Comment 2", "Comment 3"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Image("product-image") // Will replace with the actual product image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                
                Text(productName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Text(productDescription)
                    .font(.body)
                    .padding([.horizontal, .bottom])
                
                Text("Related Products")
                    .font(.headline)
                    .padding(.horizontal)
                
                // Horizontal scroll view for related products
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(relatedProducts, id: \.self) { product in
                            Text(product)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("Comments")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(comments, id: \.self) { comment in
                    Text(comment)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationBarTitle(Text("Product Details"), displayMode: .inline)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LoginManager())
    }
}
