# JRuby runs on the JVM which does not support forking processes. Workers are disabled
#
# This means we can only use puma threads to scale out. Unlike CRuby (MRI), JRuby does not have a GVL/GIL
# so threads can execute JRuby code concurrently (versus only IO) so processes are not required
# to fully utilize multiple CPU cores.
#
# workers ENV.fetch('WEB_CONCURRENCY') { 2 }
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

preload_app!

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
