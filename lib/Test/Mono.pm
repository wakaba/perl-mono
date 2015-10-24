package Test::Mono;
use strict;
use warnings;
our $VERSION = '2.0';
use Mono::ID;

our @EXPORT = qw(
    create_asin
    create_isbn10
    create_isbn13
    create_ean13

    create_broken_isbn10
    create_broken_isbn13
);

sub import ($;@) {
  my $from_class = shift;
  my ($to_class, $file, $line) = caller;
  no strict 'refs';
  for (@_ ? @_ : @{$from_class . '::EXPORT'}) {
    my $code = $from_class->can ($_)
        or croak qq{"$_" is not exported by the $from_class module at $file line $line};
    *{$to_class . '::' . $_} = $code;
  }
} # import

my @ASIN_ALPHABET = ('0'..'9', 'A'..'Z');

sub create_asin (;%) {
    my (%args) = @_;
    {
        my $v = '';
        $v .= $ASIN_ALPHABET[rand @ASIN_ALPHABET] for 1..10;
        if (is_asin $v) {
            return $v;
        }
        redo;
    }
}

my @ISBN_ALPHABET = ('0'..'9');

sub create_isbn10 (;%) {
    my $v = '';
    $v .= $ISBN_ALPHABET[rand @ISBN_ALPHABET] for 1..9;
    $v .= calculate_isbn10_check_digit $v . '?';
    return $v;
}

sub create_broken_isbn10 (;%) {
    my $v = create_isbn10;
    $v++;
    $v =~ tr/Y/0/;
    return sprintf '%010s', $v;
}

sub create_isbn13 (;%) {
    my $ean = '978' . create_isbn10;
    return substr($ean, 0, 12) . calculate_ean_check_digit $ean;
}

sub create_broken_isbn13 (;%) {
    my $v = create_isbn13;
    $v++;
    return sprintf '%013d', $v;
}

sub create_ean13 (;%) {
    {
        my $v = '';
        $v .= $ISBN_ALPHABET[rand @ISBN_ALPHABET] for 1..12;
        $v .= calculate_ean_check_digit $v . '?';
        return $v unless is_isbn13 $v;
        redo;
    }
}

1;
