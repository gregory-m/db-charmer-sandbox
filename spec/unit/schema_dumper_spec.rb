require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "SchemaDumper" do
  def standard_dump
    stream = StringIO.new
    ActiveRecord::SchemaDumper.ignore_tables = []
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, stream)
    stream.string
  end
  
  describe "core DB" do
    it  "should dump tables" do
      output = standard_dump
      output.should =~ %r{ create_table "posts"}
    end
    
    it "should not dump in sub DB schema" do
      output = standard_dump
      sub_bd_schema(output).should_not =~ /posts/
    end
  end
  
  describe "sub BD" do
    it "dump tables into sub DB schema" do
      output = standard_dump
      sub_bd_schema(output).should =~ %r{ create_table "log_records"}
    end
  end
  
  def sub_bd_schema(schema_str)
    schema_str.scan(/^( *)on_db :logs.*?\n(.*?)^\1end/m)[0][1]
  end

end