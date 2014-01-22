# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name=>'Chicago' }, { name=>'Copenhagen' }])
#   Mayor.create(name=>'Emanuel', city=>cities.first)

writer = User.new(:email=>"writer@localhost.net", :password=>"Plumber364", :password_confirmation=>"Plumber364")

writer.save!

junior = User.new(:email=>"junior@localhost.net", :password=>"Plumber364", :password_confirmation=>"Plumber364")

junior.save!

post = Post.new(:user=>writer, :title=>"Hot Day", :content=>"The sun seems to like me very much these days. I don't really mind, but I really wish it could love someone else too.")

post.save!

post = Post.new(:user=>junior, :title=>"Hello!", :content=>"Hey! I'm pretty new here! Glad to be here! This is my first time here, so please be nice to me (and each other).")

post.save!