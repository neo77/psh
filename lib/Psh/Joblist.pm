package Psh::Joblist;

use strict;
use vars qw($VERSION);

use Psh::Job;

$VERSION = '0.01';

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
	my @jobs_order= ();
	my %jobs_list= ();
	$self->{jobs_order}= \@jobs_order;
	$self->{jobs_list}= \%jobs_list;
	return $self;
}

sub create_job {
	my ($self, $pid, $call) = @_;
	my $jobs_order= $self->{jobs_order};
	my $jobs_list= $self->{jobs_list};

	my $job = new Psh::Job( $pid, $call);
	$jobs_list->{$pid}=$job;
	push(@$jobs_order,$job);
	return $job;
}

sub delete_job {
	my ($self, $pid) = @_;
	my $jobs_order= $self->{jobs_order};
	my $jobs_list= $self->{jobs_list};

	my $job= $jobs_list->{$pid};
	return if !defined($job);

	delete $jobs_list->{$pid};
	my $i;
	for($i=0; $i <= $#$jobs_order; $i++) {
		last if( $jobs_order->[$i]==$job);
	}

	splice( @$jobs_order, $i, 1);
}

sub job_exists {
	my ($self, $pid) = @_;

	return exists($self->{jobs_list}->{$pid});
}

sub get_job {
	my ($self, $pid) = @_;

	return $self->{jobs_list}->{$pid};
}

sub get_job_number {
	my ($self, $pid) = @_;
	my $jobs_order= $self->{jobs_order};

	for( my $i=0; $i<=$#$jobs_order; $i++) {
		return $i+1 if( $jobs_order->[$i]->{pid}==$pid);
	}
	return -1;
}

#
# $pid=$joblist->find_job([$jobnumber])
# Finds either the job with the specified job number
# or the highest numbered not running job and returns
# the job or undef is none is found
#
sub find_job {
	my ($self, $job_to_start) = @_;
	my $jobs_order= $self->{jobs_order};

	return $jobs_order->[$job_to_start] if defined( $job_to_start);

	for (my $i = $#$jobs_order; $i >= 0; $i--) {
		my $job = $jobs_order->[$i];
		
		if(!$job->{running}) {
			$job_to_start = $i;
			return $job;
		}
	}
	return undef;
}

#
# Resets the enumeration counter for access using "each"
#
sub enumerate {
	my $self= shift;

	$self->{pointer}=0;
}

#
# Returns the next job
#
sub each {
	my $self= shift;
	my $jobs_order= $self->{jobs_order};
	if( $self->{pointer}<=$#$jobs_order) {
		return $jobs_order->[$self->{pointer}++];
	}
	return undef;
}


1;
__END__

=head1 NAME

Psh::Joblist - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Psh::Joblist;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Psh::Joblist was created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head1 AUTHOR

A. U. Thor, a.u.thor@a.galaxy.far.far.away

=head1 SEE ALSO

perl(1).

=cut