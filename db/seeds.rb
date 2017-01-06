test_1 = User.create(
  username: "test_1",
  email: "test@blah.com",
  password: "test"
)
billiam = User.create(
  username: "billiam",
  email: "bill@bill.com",
  password: "password1"
)
sarah = User.create(
  username: "sarah",
  email: "me@timsister.com",
  password: "weddingslol"
)
peabody = User.create(
  username: "peabody",
  email: "smart@dog.com",
  password: "isapeople"
)
deadpool = User.create(
  username: "deadpool",
  email: "jokes@you.com",
  password: "fourthwall"
)

christianity = Religion.create(
name: "Christianity"
)
paganism = Religion.create(
name: "Paganism"
)
satanism = Religion.create(
name: "Satanism"
)

queens = Tribe.create(
  name: "The Queen's Personal Foot-Lickers",
  user: test_1,
  religion: satanism
)
cheeseburgers = Tribe.create(
  name: "Cheeseburger Squishers",
  user: peabody,
  religion: christianity
)
scalpers = Tribe.create(
  name: "Ticket Scalpers Anonymous",
  money: 5000000,
  user: peabody,
  religion: paganism
)
nerds = Tribe.create(
  name: "Aquarium Nerds",
  technology: 100,
  user: sarah,
  religion: paganism
)
dwarves = Tribe.create(
  name: "Six-Fingered Gay Dwarf Colony",
  user: billiam,
  religion: satanism
)
survivors = Tribe.create(
  name: "Neverland Survivors",
  user: deadpool
)
citizens = Tribe.create(
  name: "Non-Pirate 'Pirate Island' Citizens",
  land: 15,
  user: sarah,
  religion: satanism,
  population: Population.create(
    warriors: 125,
    farmers: 14,
    priests: 1
  )
)

school = Building.create(
  name: "school",
  price: 300,
  resource_amount: 1,
  resource_name: "wood"
)

hospital = Building.create(
  name: "hospital",
  price: 900,
  resource_amount: 3,
  resource_name: "cloth"
)

barracks = Building.create(
  name: "barracks",
  price: 1500,
  resource_amount: 3,
  resource_name: "iron"
)

walls = Building.create(
  name: "walls",
  price: 500,
  resource_amount: 4,
  resource_name: "wood"
)

hut = Building.create(
  name: "hut",
  price: 100,
  resource_amount: 0,
  resource_name: "food"
)

survivors.build_building("hut")
