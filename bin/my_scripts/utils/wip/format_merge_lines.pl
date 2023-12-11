#!/usr/bin/perl

use strict;
use warnings;
use File::Find;
use File::Slurp;

sub check_first_line {
    my ($line) = @_;
    $line =~ s/^\s+|\s+$//g; # Trim whitespaces
    return ($line eq '' || $line =~ m{^/} || $line =~ m{^\*}) && $line !~ m{^#};
}

sub check_for_comment {
    my ($line) = @_;
    $line =~ s/^\s+|\s+$//g;
    return $line =~ m{^/} || $line =~ m{^\*};
}

sub check_for_content {
    my ($line) = @_;
    $line =~ s/^\s+|\s+$//g;
    return $line ne '' && !check_for_comment($line) && $line !~ m{^#};
}

sub check_for_paren {
    my ($line) = @_;
    $line =~ s/^\s+|\s+$//g;
    return $line =~ m{\(};
}

sub check_for_end_paren {
    my ($line) = @_;
    $line =~ s/^\s+|\s+$//g;
    return $line =~ m{\)$};
}

sub check_for_func_start {
    my ($line) = @_;
    $line =~ s/[\n\r]//g; # Remove newlines
    return $line =~ m{^\{};
}

sub process_file {
    my ($filename) = @_;
    my @lines = read_file($filename);
    my @new_lines;
    my $change_counter = 0;
    my $i = 0;

    while ($i < scalar @lines) {
        if ($i < scalar @lines - 3 && check_first_line($lines[$i]) && check_for_content($lines[$i + 1]) && check_for_end_paren($lines[$i + 2]) && check_for_func_start($lines[$i + 3])) {
            push @new_lines, $lines[$i];
            push @new_lines, $lines[$i + 1];
            $new_lines[-1] =~ s/\s+$//; # Trim right whitespace
            $new_lines[-1] .= ' ' . $lines[$i + 2];
            push @new_lines, $lines[$i + 3];
            $i += 4;
            $change_counter++;
        } else {
            push @new_lines, $lines[$i];
            $i++;
        }
    }

    write_file($filename, @new_lines);
    return $change_counter;
}

sub wanted {
    if (/\.c$/ && -f $_) {
        print "Processing file: $_\n";
        my $file_change_count = process_file($File::Find::name);
        print "Done! Changes done: $file_change_count\n";
    }
}

my $dir_path = './'; # Current directory
find(\&wanted, $dir_path);
