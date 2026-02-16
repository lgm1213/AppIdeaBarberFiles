puts "Seeding database..."

# 45 unique names — one per user
NAMES = [
  # Barbershop Owners (0-9)
  ["Bob", "Smith"],
  ["John", "Carpenter"],
  ["Jim", "Baker"],
  ["Marcus", "Cole"],
  ["Tony", "Rivera"],
  ["Derek", "Washington"],
  ["Frank", "Russo"],
  ["Ray", "Mitchell"],
  ["Calvin", "Hayes"],
  ["Oscar", "Delgado"],
  # Freelance Barbers (10-19)
  ["Andre", "Brooks"],
  ["Kevin", "Nguyen"],
  ["Darnell", "Price"],
  ["Manny", "Ortiz"],
  ["Troy", "Jenkins"],
  ["Cedric", "Palmer"],
  ["Leo", "Grant"],
  ["Isaiah", "Fleming"],
  ["Vince", "Reyes"],
  ["Terrell", "Dixon"],
  # Clients with no history (20-29)
  ["Chris", "Taylor"],
  ["Matt", "Johnson"],
  ["David", "Garcia"],
  ["Brian", "Lee"],
  ["Jason", "Walker"],
  ["Ryan", "Hall"],
  ["Tyler", "Young"],
  ["Nick", "King"],
  ["Sam", "Wright"],
  ["Alex", "Scott"],
  # Clients with history (30-39)
  ["Mike", "Davis"],
  ["Carlos", "Martinez"],
  ["James", "Robinson"],
  ["Eric", "Thompson"],
  ["Dan", "White"],
  ["Greg", "Harris"],
  ["Steve", "Clark"],
  ["Patrick", "Lewis"],
  ["Brandon", "Allen"],
  ["Corey", "Turner"],
  # Staff members (40-44)
  ["Lisa", "Chen"],
  ["Maria", "Santos"],
  ["Rachel", "Kim"],
  ["Angela", "Foster"],
  ["Diana", "Webb"]
].freeze

SHOP_NAMES = [
  "Bob's Classic Cuts",
  "Carpenter's Barbershop",
  "Baker's Blade Lounge",
  "Cole's Cutz",
  "Rivera's Grooming Co.",
  "Washington's Fade Factory",
  "Russo's Razor Room",
  "Mitchell's Mane Shop",
  "Hayes & Sons Barbers",
  "Delgado's Style Studio"
].freeze

# --- 10 Barbershop Owners (role: Barber) each with 1 shop and 2-3 chairs ---
shop_barbers = []
10.times do |i|
  first, last = NAMES[i]
  barber = User.create!(
    first_name: first,
    last_name: last,
    email_address: "#{first.downcase}.#{last.downcase}@example.com",
    password: "password",
    role: "Barber"
  )
  shop_barbers << barber

  shop = Shop.create!(
    name: SHOP_NAMES[i],
    address: "#{100 + i} Main St, City, ST 00#{100 + i}",
    barber_id: barber.id
  )

  num_chairs = [2, 3].sample
  num_chairs.times do |j|
    Chair.create!(
      shop_id: shop.id,
      barber_id: nil,
      name: "Chair #{j + 1}",
      is_available: true
    )
  end
end
puts "Created #{shop_barbers.size} barbershop owners with shops and chairs"

# --- 10 Freelance Barbers (role: Barber) no shops ---
10.times do |i|
  first, last = NAMES[10 + i]
  User.create!(
    first_name: first,
    last_name: last,
    email_address: "#{first.downcase}.#{last.downcase}@example.com",
    password: "password",
    role: "Barber"
  )
end
puts "Created 10 freelance barbers"

# --- 10 Clients with no history ---
10.times do |i|
  first, last = NAMES[20 + i]
  User.create!(
    first_name: first,
    last_name: last,
    email_address: "#{first.downcase}.#{last.downcase}@example.com",
    password: "password",
    role: "Client"
  )
end
puts "Created 10 clients with no history"

# --- 10 Clients with history (appointments + haircuts) ---
10.times do |i|
  first, last = NAMES[30 + i]
  client = User.create!(
    first_name: first,
    last_name: last,
    email_address: "#{first.downcase}.#{last.downcase}@example.com",
    password: "password",
    role: "Client"
  )

  num_records = rand(1..3)
  num_records.times do |j|
    barber = shop_barbers.sample
    start_time = (j + 1).weeks.ago + rand(1..5).hours
    end_time = start_time + 30.minutes

    Appointment.create!(
      barber_id: barber.id,
      client_id: client.id,
      start_time: start_time,
      end_time: end_time,
      status: "confirmed"
    )

    Haircut.create!(
      client_id: client.id,
      barber_id: barber.id,
      details: "Haircut style #{j + 1} for #{first} #{last}"
    )
  end
end
puts "Created 10 clients with appointment and haircut history"

# --- 5 Staff Members linked to first 5 shops ---
shops = Shop.order(:id).limit(5).to_a
5.times do |i|
  first, last = NAMES[40 + i]
  staff_user = User.create!(
    first_name: first,
    last_name: last,
    email_address: "#{first.downcase}.#{last.downcase}@example.com",
    password: "password",
    role: "Staff"
  )

  ShopMember.create!(
    shop: shops[i],
    user: staff_user,
    role_in_shop: "staff",
    active: true
  )
end
puts "Created 5 staff members linked to shops"

# --- Sample Transactions for the first shop ---
first_shop = Shop.first
first_owner = first_shop.barber

[
  { transaction_type: "income", category: "Service", amount_cents: 3500, description: "Men's haircut", transaction_date: 2.days.ago.to_date },
  { transaction_type: "income", category: "Service", amount_cents: 5000, description: "Haircut + beard trim", transaction_date: 1.day.ago.to_date },
  { transaction_type: "income", category: "Tips", amount_cents: 1000, description: "Tip from client", transaction_date: Date.current },
  { transaction_type: "expense", category: "Supplies", amount_cents: 4500, description: "Clipper oil and blades", transaction_date: 3.days.ago.to_date },
  { transaction_type: "expense", category: "Rent", amount_cents: 150000, description: "Monthly rent", transaction_date: Date.current.beginning_of_month },
  { transaction_type: "expense", category: "Utilities", amount_cents: 8500, description: "Electric bill", transaction_date: 5.days.ago.to_date }
].each do |attrs|
  Transaction.create!(attrs.merge(shop: first_shop, barber: first_owner))
end
puts "Created #{Transaction.count} sample transactions"

# --- Sample Inventory Items for the first shop ---
[
  { name: "Andis Clipper Oil", description: "Lubricant for clipper blades", quantity: 25, low_stock_threshold: 10, unit: "bottles", vendor_name: "Andis Co.", vendor_contact: "orders@andis.com", reorder_cost_cents: 599, sku: "AND-OIL-4OZ" },
  { name: "Barber Capes", description: "Black nylon cutting capes", quantity: 8, low_stock_threshold: 5, unit: "pieces", vendor_name: "SalonSupply", vendor_contact: "555-0123", reorder_cost_cents: 1299, sku: "SS-CAPE-BLK" },
  { name: "Neck Strips", description: "Disposable neck strips", quantity: 3, low_stock_threshold: 10, unit: "boxes", vendor_name: "SalonSupply", vendor_contact: "555-0123", reorder_cost_cents: 899, sku: "SS-NECK-100" },
  { name: "Disinfectant Spray", description: "Barbicide spray for tools", quantity: 0, low_stock_threshold: 5, unit: "cans", vendor_name: "Barbicide", vendor_contact: "support@barbicide.com", reorder_cost_cents: 1099, sku: "BARB-SPRAY" },
  { name: "Styling Gel", description: "Strong hold styling gel", quantity: 15, low_stock_threshold: 8, unit: "jars", vendor_name: "American Crew", vendor_contact: "wholesale@americancrew.com", reorder_cost_cents: 1499, sku: "AC-GEL-16OZ" }
].each do |attrs|
  InventoryItem.create!(attrs.merge(shop: first_shop))
end
puts "Created #{InventoryItem.count} sample inventory items"

puts "\nSeed complete!"
puts "Users: #{User.count}"
puts "Shops: #{Shop.count}"
puts "Chairs: #{Chair.count}"
puts "Appointments: #{Appointment.count}"
puts "Haircuts: #{Haircut.count}"
puts "Transactions: #{Transaction.count}"
puts "Inventory Items: #{InventoryItem.count}"
puts "Shop Members (Staff): #{ShopMember.count}"
