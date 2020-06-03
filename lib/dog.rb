class Dog 
  attr_accessor :name
  attr_reader :breed, :id

  def initialize(id: nil, name:, breed:)
    @id = id 
    @name = name 
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT 
      )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table 
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(arr)
    Dog.new(id: arr[0],name: arr[1], breed: arr[2])
  end
  
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed) 
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end 
    self
  end
  
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(sql, self.name)
    
  end
  
end