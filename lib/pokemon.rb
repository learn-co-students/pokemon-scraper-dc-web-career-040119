class Pokemon
  attr_accessor :name, :type, :db, :hp
  attr_reader :id

  def initialize(id: nil, name:, type:, db:)
    @id = id
    @name = name
    @type = type
    @db = db
    @hp = 60
  end

  def alter_hp(amount, db)
    sql = "UPDATE pokemon SET hp = ? WHERE id = ?"
    db.execute(sql, amount, id)
    self.hp = db.execute("SELECT hp FROM pokemon WHERE id = ?", id)[0][0]
  end

  # Class methods

  def self.save(name, type, db)
      sql = "INSERT INTO pokemon (name, type) VALUES (?, ?)"
      db.execute(sql, name, type)
      @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
  end

  def self.find(id, db)
    sql = "SELECT * FROM pokemon WHERE id = ?"
    row = db.execute(sql, id)[0]
    pokemon = Pokemon.new(id: row[0], name: row[1], type: row[2], db: db)
    pokemon.hp = row[3]
    pokemon
  end
end
