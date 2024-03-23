//
//  ContentView.swift
//  Shopping-List
//
//  Created by Oguz Burhan on 2024-03-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            WelcomeScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Welcome")
                }
//            LoginView()
//                .tabItem {
//                    Image(systemName: "person.fill")
//                    Text("Login")
//                }
            HomeView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
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
                // Handle login action
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
                Image("logo") // Make sure this image is added in your assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
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
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            registrationFailed = true
            failureMessage = "Please ensure all fields are filled correctly and passwords match."
            return
        }
        
        // Attempt to create and save the new user
        let newUser = User(context: viewContext)
        newUser.email = email
        newUser.password = password // Note: Ideally, the password should be hashed
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss() // Dismiss on successful registration
        } catch let error as NSError {
            registrationFailed = true
            failureMessage = "Registration failed: \(error.localizedDescription)"
            
            // More detailed error diagnostics
            print("Registration error: \(error), \(error.userInfo)")
        }
    }
}



struct HomeView: View {
    @State private var searchText: String = ""
    
    // Category data
    let categories: [(icon: String, name: String)] = [
        ("applescript", "Food"),
        ("cart", "Beverages"),
        ("house", "Household"),
        ("scissors", "Health & Beauty"),
        ("tv", "Electronics"),
        ("tshirt", "Clothing")
    ]
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter a product name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    // Perform search
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.name) { category in
                        Button(action: {
                            // Handle category selection
                        }) {
                            VStack {
                                Image(systemName: category.icon)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                Text(category.name)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
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
        // Add more categories and items as needed
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
    }
}
