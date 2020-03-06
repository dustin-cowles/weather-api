Rough Task Breakdown
--------------------
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
  * MySQL for data caching, 5 minute TTL
  * Add real weather data source (external API)
  * Method to configure credentials/API key (for external api call)
  * Unit tests
* Extra credit
  * Flask API Revisit 3
    * Add param for location(s?)
  * Vagrant Revisit
     * Clean up hacks in Vagrantfile
     * Deploy PostgreSQL
  * Flask API Revisit 4
    * Migrate to PostgreSQL
    * Additional unit tests
    
    
Issues/Excuses/Explanations :)
------------------------------
I have not used Puppet before (but have used Chef long ago, and Ansible more 
recently). I am 100% sure that there is a better way to lay out the modules.

I ended up using Vagrant synced folder to deploy the application rather than 
packaging and deploying using some proper method. This was done to save time
and is really not a great solution. It also required hacky uid/gid stuff in
the Vagrantfile (see comments there). In the end it probably won't save me any
time but I need to keep moving forward.

My Puppet modules could make better use of templates and parameters to be more
reuseable. I could also have made use of other people's modules for some 
services to save time, but I wanted to have a better understanding of Puppet 
after the exercise so used a read-understand-reproduce tactic rather than just 
learning how to configure other people's modules.

I am not using a virtualenv or requirements.txt file, this was mostly due to
the limited dependencies (just flask and uwsgi) but even so it would be best to
use both. I ended up skipping it but may implement later if I have time.
