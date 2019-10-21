class Dog 
  
  attr_accessor :id, :name, :breed 
  
  def initialize(id: nil, name:, breed:)
    @name = name
    @breed = breed 
    @id = id
  end 
  
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS dogs ( 
        id INTEGER PRIMARY KEY, 
        name TEXT,
        breed TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end 
    
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end 
  
  def self.find_by_name(name)
    sql = "SELECT FROM dogs WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Dogs.new(result[0], result[1], result[2])
  end 
  
  def self.create(name:, breed:)
    dog = Dog.new(name:, breed:)
    dog.save
    dog
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
        VALUES (?,?)
      SQL
    
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end 
  end 
end 