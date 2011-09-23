require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @weapons = Category.find_by_slug("weapons")
    @swords = Category.find_by_slug("swords")
    @japanese_swords = Category.find_by_slug("japanese-swords")
  end # method setup
  
  test "category.parent=" do
    @swords.parent = @weapons
    @swords.save
    
    assert_equal @weapons, @swords.parent, "Expected Weapons to be the parent category of Swords."
    assert @weapons.children.include?(@swords), "Expected Swords to be a child category of Weapons."
  end # test parents of categories
  
  test "category.children <<" do
    @swords.children << @japanese_swords
    
    assert_equal @swords, @japanese_swords.parent, "Expected Swords to be the parent category of Japanese Swords."
    assert @swords.children.include?(@japanese_swords), "Expected Swords to be a child category of Weapons."
  end # test children of categories
  
  test "build_parent and create_parent" do
    @sharp_things = @weapons.build_parent :title => "Sharp Things", :slug => "sharp-things"
    @weapons.save
    
    assert_equal @sharp_things, @weapons.parent, "Expected Sharp Things to be the parent category of Weapons."
    assert @sharp_things.children.include?(@weapons), "Expected Weapons to be a child category of Sharp Things."
    
    @dangerous_things = @sharp_things.create_parent :title => "Things That Are Dangerous", :slug => "dangerous-things"
    @sharp_things.save
    
    assert_equal @dangerous_things, @sharp_things.parent, "Expected Dangerous Things to be the parent category of Sharp Things."
    assert @dangerous_things.children.include?(@sharp_things), "Expected Sharp Things to be a child category of Dangerous Things."
  end # test build_parent and create_parent
  
  test "children.build and children.create" do
    @bows = @weapons.children.build :title => "Bows", :slug => "bows"
    
    assert_equal @weapons, @bows.parent, "Expected Weapons to be the parent category of Bows."
    assert @weapons.children.include?(@bows), "Expected Bows to be a child category of Weapons."
    
    @polearms = @weapons.children.create :title => "Polearms", :slug => "polearms"
    
    assert_equal @weapons, @polearms.parent, "Expected Weapons to be the parent category of Polearms."
    assert @weapons.children.include?(@polearms), "Expected Polearms to be a child category of Weapons."
  end # test children.build and children.create
  
  test "category path building" do
    @weapons.children << @swords
    @swords.children << @japanese_swords
    
    assert_equal @weapons.slug, @weapons.path
    assert_equal "#{@weapons.path}/#{@swords.slug}", @swords.path
    assert_equal "#{@swords.path}/#{@japanese_swords.slug}", @japanese_swords.path
  end # test category path building
end # test suite CategoryTest
