package Data::Validate::Terrorist;

use strict;
use 5.008_005;
our $VERSION = '0.02';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw/is_terrorist/;

use Carp;

sub is_terrorist {
    my $self = shift if ref($_[0]); # OO

    my $name = join('', @_);
    $name = uc($name);
    $name =~ s/[[:^alpha:]]//g;

    my @data = __load_data();
    return 1 if grep { $_ eq $name } @data;

    # try reverse
    if (@_ > 1) {
        $name = join('', reverse @_);
        $name = uc($name);
        $name =~ s/[[:^alpha:]]//g;
        return 1 if grep { $_ eq $name } @data;
    }

    return 0;
}

my @__data;
sub __load_data {
    return @__data if @__data;

    my $file = __FILE__;
    $file =~ s/\.pm/\.csv/;
    open(my $fh, '<', $file) or croak "Can't find $file, please re-install the module.\n";
    @__data = <$fh>;
    close($fh);

    chomp(@__data);
    @__data;
}

# for OO
sub new {
    my $class = shift;
    return bless {}, ref($class) || $class;
}

1;
__END__

=encoding utf-8

=head1 NAME

Data::Validate::Terrorist - Validate a name against terrorist lists

=head1 SYNOPSIS

    # as exported function
    use Data::Validate::Terrorist qw/is_terrorist/;

    print 'BAD' if is_terrorist($first_name, $last_name);

    # as OO
    use Data::Validate::Terrorist;

    my $validator = Data::Validate::Terrorist->new;
    print 'BAD' if $validator->is_terrorist("$last_name $first_name");

=head1 DESCRIPTION

Data::Validate::Terrorist is a simple validitor to validate a name against terrorist lists.

The list is from L<http://www.treasury.gov/ofac/downloads/sdn.csv>, L<http://www.treasury.gov/resource-center/sanctions/Terrorism-Proliferation-Narcotics/Documents/plc_prim.csv>, L<http://www.treasury.gov/ofac/downloads/fse/fse_prim.csv>

run L<update_terrorist_csv> to update the bundled csv.

=head1 METHODS

=head2 is_terrorist

    is_terrorist($last_name, $first_name);
    is_terrorist($first_name, $last_name);
    is_terrorist("$last_name $first_name");

when one string is passed, please be sure last_name is before first_name.

or you can pass first_name, last_name (last_name, first_name), we'll check both "$last_name $first_name" and "$first_name $last_name".

return 1 for yes, 0 for no.

it will remove all non-alpha chars and compare with the list we have.

=head1 AUTHOR

Binary.com E<lt>fayland@binary.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Binary.com

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Data::OFAC>

=cut
