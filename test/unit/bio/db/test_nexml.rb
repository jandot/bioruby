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
      assert_not_equal @doc.version, nil, "NeXML file should have a version."
    end
  end #end TestNeXMLReader

  class TestNeXMLOtus
    def setup
      @otus = Bio::NeXML.read("lib/bio/db/nexml/taxa_sample_.xml").otus
    end
    def test_for_id
      @otus.each do |otus|
        assert_not_equal otus.id, nil, "Otus element should have an id"
      end
    end
  end #end TestOtus
end #end Bio
