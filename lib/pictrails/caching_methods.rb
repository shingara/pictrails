module Pictrails
  module CachingMethods                                                                                                                                                                           
    def self.included(base)                                                                                                                                                                       
      base.alias_method_chain :caching_allowed, :skipping                                                                                                                                         
    end

    protected
    
    # if a skip_caching attribute is define no caching made
    # it's usefull when you render a redirect after a post.
    def caching_allowed_with_skipping 
      caching_allowed_without_skipping && !@skip_caching                                                                                                                                        
    end                                                                                                                                                                                         
  end          
end
