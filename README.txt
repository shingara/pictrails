h1. Pictrails

A Web Photo Gallery, written with Rails 2.0. Pictrails can manage several photo galleries.

h2. Features

 * Create several Galleries
 * Create Galleries like child of another Gallery
 * Add several pictures in a Gallery
 * Create a gallery with define a directory in same server of pictrails if the
   directory has several directories into, all of this directory are child of
   master Gallery
 * Admin interface with login to add/edit/delete Galleries and Pictures
 * Define the thumbnails and pictures size in settings interface
 * Delete the cache page in settings interface
 * Define the number of pictures by pagination Gallery
 * Define the number of gallery by pagination of Gallery's list

h2. Requirements

Currently you need all of those things to get Pictrails to run:

 * Ruby On Rails 2.0.x (not already test with Rails 2.1.x)
 * Ruby of 1.8.6 (Rails 2.0.x is not yet ruby 1.9 compatible)
 * A database supported by Rails ActiveRecord (MySQL, DB2, SQLite3, ...)
 * Ruby drivers for your database (obviously out of the box with Rails)
 * A gem of an image-handling API like :
 ** ImageScience
 ** RMagick
 ** Mini-magick

h2. Installing

With the tar.gz or any other archive:

 * Extract sources to a folder
 * Create a database.yml file in the config directory. You can copy the database.yml.example
 * Create your databases: <kbd>rake db:create:all</kbd>
 * Migrate your database: <kbd>rake db:migrate</kbd>
 * Start the server in production mode : <kbd>ruby script/server -e production</kbd>

h2. Updating

With the tar.gz or any other archive:

 * Extract sources and replace all in the old folder
 * Stop the server
 * Migrate your database: <kbd>rake db:migrate</kbd>
 * Start the server in production mode : <kbd>ruby script/server -e production</kbd>

h2. Demo Website

A demo website of Pictrails is available to the "demo of pictrails":http://pictrails.shingara.fr

The "admin part":http://pictrails.shingara.fr/admin has like login/pass : admin/pictrails

h2. Information about this project

Pictrails is actually consider like an Beta version, and is under development.

All contributions are welcome. 

I suck in design, I know it and I am sorry but I will really be happy if anyone could
help me.

If you want to contribute, all work is made under a git repository. You can clone the 
source with the following command :

<kbd>git clone git://github.com/shingara/pictrails.git</kbd>

After a clone you need update the submodule :

<kbd>git submodule init</kbd>
<kbd>git submodule update</kbd>

A "redmine development platform":http://dev.shingara.fr/projects/show/3 is
used. Feel free to post your feature requests and defects report.

h2. License

This code is free to use under the terms of the MIT license (provided with sources).
