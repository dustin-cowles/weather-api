This repo is the result of a time-boxed exercise as part of an interview. No 
part of it should be considered worth using or imitating in any capacity.

Usage
-----
From the root of repo run `vagrant up`.
The API can be called at http://10.0.0.100/temperature.
The temperature will be retrieved and stored in `weather_cache.db` before 
it is returned. 
You can safely delete `weather_cache.db` at any time to cause it to retrieve
a fresh result next time the API is called.

Notes/Summary
-------------
I have not used Puppet before (but have used Chef long ago, and Ansible more 
recently). I am 100% sure that there is a better way to organize my modules.
My Puppet modules could also make better use of templates and parameters to be 
more reuseable. I could also have made use of other people's modules for some 
services to save time, but I wanted to have a better understanding of Puppet 
after the exercise so used a read-understand-reproduce tactic rather than just 
learning how to configure other people's modules.

I ended up using Vagrant synced folder to deploy the application rather than 
packaging and deploying using some proper method. This was done to save time
and is really not a great solution. It also required hacky uid/gid stuff in
the Vagrantfile (see comments there). In the end it probably won't save me any
time, but I needed to keep moving forward.

I am not using a virtualenv or requirements.txt file, this was mostly due to
the limited dependencies (flask, uwsgi, requests) but even so it would be best 
to use both. I did not have time to implement this later on.

I spent a long time on Puppet and Nginx/uWSGI configuration. The Nginx/uWSGI 
configuration issues ended up being due to SELinux . I disabled that with a 
hack in the Vagrantfile to keep moving. 

I hoped to have time to clean up hacks in the Vagrantfile but I ran out of 
time. Reprovisioning a box does not work, you will need to destroy/create a box 
to provision. So sorry about that. I did find a SELinux Puppet library, but had 
issues figuring out how to make use of it with Vagrant using `puppet apply`. I 
think I would need to figure out how to configure puppet-librarian or use a 
puppet master to enable importing third party modules.

Since I ran short on time, I never got a chance to clean up the API handler.
This is probably the dirtiest and most error-prone Flask app I have ever 
written and I hope never to do that again :).

The weather API I called to get real temperatures is not the best one available
but was the best one I found that did not require an API key. It returns a list
of forecasts each with a "predictability" score which is supposed to indicate
how "in consensus" the forecast is. In my quick checking, the highest score 
definitely aligned more closely with trusted sources (google, wunderground)
than lower scores. I went ahead and just used the temperature with the highest
predictability score. There is also no real error handling around that call and
it is very likely that something can go wrong and cause an exception.

Rough Task Breakdown
--------------------
This is a rough list of the tasks I wanted to accomplish and the order I 
planned on working on them.

* Flask API  
  * ~~temperature route~~
  * ~~Use fake data~~
  * ~~Logging~~
* Vagrantfile
  * ~~Puppet Provisioner~~
  * ~~CentOS~~
* Configuration
  * ~~Nginx~~
  * ~~uWSGI~~
* Flask API Revisit
  * ~~sqlite for data caching, 5 minute TTL~~
  * ~~Add real weather data source (external API)~~
  * ~~Method to configure credentials/API key (N/A)~~
  * Unit tests (ran out of time here)
* Extra credit
  * Flask API Revisit 3
    * Add param for location(s?)
  * Vagrant Revisit
     * Clean up hacks in Vagrantfile
     * Deploy PostgreSQL
  * Flask API Revisit 4
    * Migrate to PostgreSQL
    * Additional unit tests
