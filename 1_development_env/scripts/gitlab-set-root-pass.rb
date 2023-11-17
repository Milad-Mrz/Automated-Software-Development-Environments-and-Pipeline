#!/usr/bin/env ruby

user = User.where(id: 1).first
user.password = 'adminadmin'
user.password_confirmation = 'adminadmin'
user.save!
