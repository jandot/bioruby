#
# = test/unit/bio/db/test_nexml.rb - Unit test for Bio::PhyloXML::Parser
#
# Copyright::   Copyright (C) 2010
#               Anurag Priyam <anurag08priyam@gmail.com>
# License::     The Ruby License
#

# loading helper routine for testing bioruby
require 'pathname'
load Pathname.new(File.join(File.dirname(__FILE__), ['..'] * 3,
                            'bioruby_test_helper.rb')).cleanpath.to_s

# libraries needed for the tests
require 'test/unit'
require 'rubygems'
require 'bio/db/nexml/reader'

module Bio
  class TestNeXMLReader < Test::Unit::TestCase
    def setup
      @doc = Bio::NeXML.read "lib/bio/db/nexml/taxa_sample_.xml"
    end
    def test_for_version
      assert_not_equal @doc.version, nil, "NeXML file must have a version."
    end
  end #end TestNeXMLReader

  class TestNeXMLOtus < Test::Unit::TestCase
    def setup
      @otus = Bio::NeXML.read("lib/bio/db/nexml/taxa_sample_.xml").otus
    end
    def test_for_id
      @otus.each do |otus|
        assert_not_equal otus.id, nil, "Otus element must have an id"
        otus.otu.each do |otu|
          assert_not_equal otu.id, nil, "Otu element must have an id"
        end
      end
    end
  end #end TestOtus
  
  class TestNeXMLTrees < Test::Unit::TestCase
    def setup
      @reader = Bio::NeXML.read("lib/bio/db/nexml/trees_sample_.xml")
    end
    def test_for_id
      @reader.trees.each do |trees|
        assert_not_equal trees.id, nil, "Trees element must have an id"
        trees.tree.each do |tree|
          assert_not_equal tree.id, nil, "Tree element must have an id"
        end
        trees.network.each do |network|
          assert_not_equal network.id, nil, "Network element must have an id"
        end
      end
    end
    def test_for_otus
      @reader.trees.each do |trees|
        assert_not_equal trees.otus, nil, "Trees element must have an otus"
      end
    end
    def test_otus_exist
      @reader.trees.each do |trees|
        seen_otus = false
        @reader.otus.each do |otus|
          if otus.id == trees.otus
            seen_otus = true
          end
        end
        assert_equal seen_otus, true, "Otus id reference must exist"
      end
    end
  end
end #end Bio
