puts "Seeding database..."

# 40 unique names — one per user
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
  ["Corey", "Turner"]
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

puts "\nSeed complete!"
puts "Users: #{User.count}"
puts "Shops: #{Shop.count}"
puts "Chairs: #{Chair.count}"
puts "Appointments: #{Appointment.count}"
puts "Haircuts: #{Haircut.count}"
