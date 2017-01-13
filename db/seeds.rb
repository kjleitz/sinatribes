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
egg_nog = User.create(
  username: "egg_nog",
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

christianity = Religion.create(name: "Christianity")
paganism = Religion.create(name: "Paganism")
satanism = Religion.create(name: "Satanism")
buddhism = Religion.create(name: "Buddhism")
judaism = Religion.create(name: "Judaism")
islam = Religion.create(name: "Islam")
hinduism = Religion.create(name: "Hinduism")
animism = Religion.create(name: "Animism")
secularism = Religion.create(name: "Secularism")
arbitraryism = Religion.create(name: "Arbitrary *-ism")

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
  religion: paganism,
  population: Population.create(
    warriors: 125,
    farmers: 100,
    priests: 30
  )
)
nerds = Tribe.create(
  name: "Aquarium Nerds",
  technology: 100,
  user: egg_nog,
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
  user: egg_nog,
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
  resource_amount: 2,
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
  resource_amount: 1,
  resource_name: "food"
)

town_hall = Building.create(
  name: "town hall",
  price: 2000,
  resource_amount: 3,
  resource_name: "stone"
)

factory = Building.create(
  name: "factory",
  price: 1500,
  resource_amount: 5,
  resource_name: "coal"
)

farm = Building.create(
  name: "farm",
  price: 300,
  resource_amount: 1,
  resource_name: "wood"
)

mine = Building.create(
  name: "mine",
  price: 1000,
  resource_amount: 2,
  resource_name: "stone"
)

temple = Building.create(
  name: "temple",
  price: 750,
  resource_amount: 5,
  resource_name: "stone"
)

lumber_yard = Building.create(
  name: "lumber yard",
  price: 750,
  resource_amount: 2,
  resource_name: "iron"
)

survivors.build_building("hut")

10.times { scalpers.add_resource("iron") }
8.times { scalpers.add_resource("wood") }
25.times { scalpers.add_resource("food") }
30.times { scalpers.add_resource("stone") }
15.times { scalpers.add_resource("coal") }
6.times { scalpers.add_resource("cloth") }

2.times { scalpers.add_building("school") }
1.times { scalpers.add_building("hospital") }
1.times { scalpers.add_building("walls") }
1.times { scalpers.add_building("mine") }
1.times { scalpers.add_building("factory") }
4.times { scalpers.add_building("hut") }
2.times { scalpers.add_building("barracks") }
2.times { scalpers.add_building("town hall") }
2.times { scalpers.add_building("temple") }
5.times { scalpers.add_building("farm") }

20.times { queens.collect_resource(Resource.discover) }
