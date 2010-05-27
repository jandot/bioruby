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
    
    # http://nexml.org/nexml/html/doc/schema-1/meta/annotations/#Base
    class Base
      def initialize( element )
        @element = element
      end
    end
    
    # http://nexml.org/nexml/html/doc/schema-1/abstract/#Annotated (needs update)
    class Annotated < Base
    end
    
    # http://nexml.org/nexml/html/doc/schema-1/abstract/#Labelled
    class Labelled < Annotated
      def initialize( element )
        super(element)
      end
      
      def label
        @element.attributes[ 'label' ]
      end      
    end    
    
    # http://nexml.org/nexml/html/doc/schema-1/abstract/#IDTagged
    class IDTagged < Labelled
      def initialize( element )
        super(element)
      end
      
      def id
        @element.attributes[ 'id' ]
      end
    end

    # http://www.nexml.org/nexml/html/doc/schema-1/taxa/taxa/#Taxon
    class Taxon < IDTagged
      def initialize( element )
        super(element)
      end
    end

    # http://www.nexml.org/nexml/html/doc/schema-1/taxa/taxa/#Taxa
    class Taxa < IDTagged
      def initialize( element )
        super(element)
        @otu=element.find('*').select{ |e| e.name == "otu" }.map{ |e| Taxon.new e }
      end
      
      def otu
        @otu
      end
    end
    
    # http://www.nexml.org/nexml/html/doc/schema-1/abstract/#TaxaLinked
    class TaxaLinked < IDTagged
      def initialize( element )
        super(element)
      end
      
      def otus
        @element.attributes[ 'otus' ]
      end
    end
    
    # http://www.nexml.org/nexml/html/doc/schema-1/trees/abstracttrees/#AbstractTree
    class AbstractTree < IDTagged
      def initialize( element )
        super(element)
      end
    end
    
    # http://www.nexml.org/nexml/html/doc/schema-1/trees/abstracttrees/#AbstractNetwork
    class AbstractNetwork < IDTagged
      def initialize( element )
        super(element)
      end
    end    
    
    # http://www.nexml.org/nexml/html/doc/schema-1/trees/tree/#IntTree
    class IntTree < AbstractTree
      def initialize( element )
        super(element)
      end
    end
    
    # http://www.nexml.org/nexml/html/doc/schema-1/trees/tree/#FloatTree
    class FloatTree < AbstractTree
      def initialize( element )
        super(element)
      end
    end
    
    # http://www.nexml.org/nexml/html/doc/schema-1/trees/tree/#IntNetwork
    class IntNetwork < AbstractNetwork
      def initialize( element )
        super(element)
      end
    end
    
    # http://www.nexml.org/nexml/html/doc/schema-1/trees/tree/#FloatNetwork
    class FloatNetwork < AbstractNetwork
      def initialize( element )
        super(element)
      end
    end       
    
    # http://www.nexml.org/nexml/html/doc/schema-1/trees/trees/#Trees
    class Trees < TaxaLinked
      def initialize( element )
        super(element)
        @tree=Array.new
        @network=Array.new
                
        element.find('*').select{ |e| e.name == "tree" }.each do |tree_elt|
          xsi_ns = "http://www.w3.org/2001/XMLSchema-instance"
          xsi_type = tree_elt.attributes.get_attribute_ns(xsi_ns, 'type' ).value          
          if xsi_type == "nex:IntTree"
            @tree.push(IntTree.new tree_elt)
          elsif xsi_type == "nex:FloatTree"
            @tree.push(IntTree.new tree_elt)
          else
            raise "Unknown xsi:type " + xsi_type
          end           
        end
        
        element.find('*').select{ |e| e.name == "network" }.each do |network_elt|
          xsi_ns = "http://www.w3.org/2001/XMLSchema-instance"
          xsi_type = network_elt.attributes.get_attribute_ns(xsi_ns, 'type' ).value            
          if xsi_type == "nex:IntNetwork"
            @network.push(IntNetwork.new network_elt)
          elsif xsi_type == "nex:FloatNetwork"
            @network.push(FloatNetwork.new network_elt)
          else
            raise "Unknown xsi:type " + xsi_type
          end           
        end
        
      end
      
      def tree
        @tree
      end
      
      def network
        @network
      end
    end

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
        @reader.root.find('*').select{ |e| e.name == "otus" }.map{ |e| Taxa.new e }
      end
      
      def trees
        @reader.root.find('*').select{ |e| e.name == "trees" }.map{ |e| Trees.new e }
      end
    end #end Reader
  end #end NeXML
end #end Bio
