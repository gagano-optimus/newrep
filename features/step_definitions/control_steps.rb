
Given /^I enable notifications from nagios main configuration$/ do
	on ControlPage do |page|
	page.enable_notification
	
	end
end

Given /^I click save and next$/ do
	on ControlPage do |page|
	page.save_next	
	end
end


Given /^I disable notifications from nagios main configuration$/ do
	on ControlPage do |page|
	page.disable_notification
	end
end


Given /^I enable flap detection from nagios main configuration$/ do
	on ControlPage do |page|
	page.enable_flap_detection
	end
end


Given /^I disable flap detection from nagios main configuration$/ do
	on ControlPage do |page|
	page.disable_flap_detection
	end
end








