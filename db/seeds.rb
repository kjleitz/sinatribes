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

queens = Tribe.create(
  name: "The Queen's Personal Foot-Lickers",
  user: test_1
)
cheeseburgers = Tribe.create(
  name: "Cheeseburger Squishers",
  user: peabody
)
scalpers = Tribe.create(
  name: "Ticket Scalpers Anonymous",
  money: 5000000,
  user: peabody
)
nerds = Tribe.create(
  name: "Aquarium Nerds",
  technology: 100,
  user: sarah
)
dwarves = Tribe.create(
  name: "Six-Fingered Gay Dwarf Colony",
  user: billiam
)
survivors = Tribe.create(
  name: "Neverland Survivors",
  user: deadpool
)
citizens = Tribe.create(
  name: "Non-Pirate 'Pirate Island' Citizens",
  land: 15,
  user: sarah
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
queens.update(religion: satanism)
cheeseburgers.update(religion: christianity)
scalpers.update(religion: paganism)
nerds.update(religion: paganism)
dwarves.update(religion: satanism)
survivors.update(religion: paganism)
citizens.update(religion: satanism)
