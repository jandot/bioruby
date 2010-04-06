#
# = bio/db/nexml/parser.rb - NeXML parser
#
# Copyright::   Copyright (C) 2010
#               Anurag Priyam <anurag08priyam@gmail.com>
# License::     The Ruby License
#
# $Id:$
#
# == Description
#
# This file containts parser for NeXML
#
# == Requirements
# 
# Libxml2 XML parser is required. Install libxml-ruby bindings from
# http://libxml.rubyforge.org or
#
#   gem install -r libxml-ruby
#
# == References
#
# * http://www.nexml.org
#
# * https://www.nescent.org/wg/phyloinformatics/index.php?title=Phyloinformatics_Summer_of_Code_2010#Evolution_and_the_semantic_web_in_Ruby:_NeXML_I.2FO_for_BioRuby


require 'libxml'

module Bio
  module NeXML
    class << self
      def read( nexml_file )
        Reader.new File.read( nexml_file )
      rescue => e
        puts e
      end
    end

    class Otus
      def initialize( otus )
        @otus = otus
      end
      
      def id
        @otus.attributes[ 'id' ]
      end

      def label
        @otus.attributes[ 'label' ]
      end
    end #end Otus

    class Reader
      include LibXML

      def initialize( nexml_string, validate = true )
        @reader = XML::Parser.string( nexml_string ).parse
      rescue => e
        puts e
      end

      def version
        @reader.root.attributes[ 'version' ]
      end

      def generator
        @reader.root.attributes[ 'generator' ]
      end

      def otus
        @reader.root.find('*').select{ |e| e.name == "otus" }.map{ |e| Otus.new e }
      end
    end #end Reader
  end #end NeXML
end #end Bio
