=head1 NAME

Linux::Ethtool::Ring - Manipulate interface Ring parameter information

=head1 SYNOPSIS

  use Linux::Ethtool::Ring;

  my $ring = Linux::Ethtool::Ring->new("eth0") or die($!);

  $ring->rx($ring->rx_max() / 2);

  $ring->apply() or die($!);

=head1 DESCRIPTION

This module provides a wrapper around the C<ethtool_ringparam> structure and
associated ioctls, used for configuring Ring parameters.

=head1 METHODS

=cut

package Linux::Ethtool::Ring;

use strict;
use warnings;

our $VERSION = "0.11";

require XSLoader;
XSLoader::load("Linux::Ethtool::Ring");

use Exporter qw(import);

use Carp;

=head2 new($dev)

Construct a new instance using the settings of the named interface.

Returns an object instance on success, undef on failure.

=cut

sub new
{
	my ($class, $dev) = @_;

	my $self = bless({ dev => $dev }, $class);

	if(_ethtool_gring($self, $dev))
	{
		return $self;
	}
	else{
		return undef;
	}
}

=head2 apply()

Apply any changed settings to the interface.

Returns true on success, false on failure.

=cut

sub apply
{
	my ($self) = @_;

	return _ethtool_sring($self->{dev}, $self->{rx_max}, $self->{mini_max},
                          $self->{jumbo_max}, $self->{tx_max}, $self->{rx},
                          $self->{mini}, $self->{jumbo}, $self->{tx});
}

=head2 rx([ $rx ])

Get or set the Ring RX number entries size

=cut

sub rx
{
	my ($self, $rx) = @_;
	$self->{rx} = $rx if defined $rx and $rx <= $self->{rx_max};
	return $self->{rx};
}

=head2 rx_max()

Get the maximum number of entries on the Ring RX

=cut

sub rx_max
{
	my $self = shift;
	return $self->{rx_max};
}

=head2 tx([ $tx ])

Get or set the Ring TX number entries size

=cut

sub tx
{
	my ($self, $tx) = @_;
	$self->{tx} = $tx if defined $tx and $tx <= $self->{tx_max};
	return $self->{tx};
}

=head2 tx_max()

Get the maximum number of entries on the Ring TX

=cut

sub tx_max
{
	my $self = shift;
	return $self->{tx_max};
}

=head2 rx_mini([ $rx_mini ])

Get or set the Ring RX Mini number entries size

=cut

sub rx_mini
{
	my ($self, $mini) = @_;
	$self->{mini} = $mini if defined $mini and $mini <= $self->{mini_max};
	return $self->{mini};
}

=head2 rx_mini_max()

Get the maximum number of entries on the Ring RX Mini

=cut

sub rx_mini_max
{
	my $self = shift;
	return $self->{mini_max};
}

=head2 rx_jumbo([ $rx_jumbo ])

Get or set the Ring RX Jumbo number entries size

=cut

sub rx_jumbo
{
	my ($self, $jumbo) = @_;
	$self->{jumbo} = $jumbo if defined $jumbo and $jumbo <= $self->{jumbo_max};
	return $self->{jumbo};
}

=head2 rx_jumbo_max()

Get the maximum number of entries on the Ring RX Jumbo

=cut

sub rx_jumbo_max
{
	my $self = shift;
	return $self->{jumbo_max};
}

=head1 SEE ALSO

L<Linux::Ethtool>, L<Linux::Ethtool::Settings>, L<Linux::Ethtool::WOL>

=cut

1;
