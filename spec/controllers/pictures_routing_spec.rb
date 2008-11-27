require File.dirname(__FILE__) + '/../spec_helper'

describe PicturesController do
  route_matches('/pictures/2008', :get, :controller => 'pictures', :action => 'find_by_date', :year => '2008')
  route_matches('/pictures/2008/11', :get, :controller => 'pictures', :action => 'find_by_date', :year => '2008', :month => '11')
  route_matches('/pictures/2008/11/25', :get, :controller => 'pictures', :action => 'find_by_date', :year => '2008', :month => '11', :day => '25')
  route_matches('/pictures/foo', :get, :controller => 'pictures', :action => 'show', :id => 'foo')
  route_matches('/pictures/create_comment', :post, :controller => 'pictures', :action => 'create_comment')
  route_matches('/pictures/page/1', :get, :controller => 'pictures', :action => 'index', :page => '1')
  route_matches('/pictures', :get, :controller => 'pictures', :action => 'index')
end
