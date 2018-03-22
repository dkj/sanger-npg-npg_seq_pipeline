use strict;
use warnings;
use Test::More tests => 2;
use Test::Exception;

use t::util;

my $util = t::util->new();
my $runfolder_path = $util->analysis_runfolder_path();

use_ok('npg_pipeline::function::start_stop');

subtest 'start and stop functions' => sub {
  plan tests => 18;

  my $ss = npg_pipeline::function::start_stop->new(
    id_run         => 1234,
    runfolder_path => $runfolder_path,
  );
  
  foreach my $m (qw/pipeline_start pipeline_end/) {
    my $ds = $ss->$m();
    ok ($ds && scalar @{$ds} == 1 && !$ds->[0]->excluded, "$m is enabled");
    my $d = $ds->[0];
    isa_ok ($d, 'npg_pipeline::function::definition');
    is ($d->identifier, '1234', 'identifier set to run id');
    is ($d->created_by, 'npg_pipeline::function::start_stop', 'created_by');
    ok (!$d->immediate_mode, 'mode is not immediate');
    is ($d->command, '/bin/true', 'command');
    is ($d->log_file_dir, $runfolder_path, "log dir for $m");
    is ($d->job_name, $m . '_1234_start_stop', "job name for $m");
    is ($d->queue, 'small', 'small queue');
  }
};

1;