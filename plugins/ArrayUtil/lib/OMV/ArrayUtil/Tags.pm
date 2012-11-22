package OMV::ArrayUtil::Tags;
# ArrayUtil (C) 2012 Piroli YUKARINOMIYA (Open MagicVox.net)
# This program is distributed under the terms of the GNU Lesser General Public License, version 3.
# $Id$

use strict;
use warnings;
use MT;

sub instance { MT->component((__PACKAGE__ =~ /^(\w+::\w+)/g)[0]); }



### <mt:IsIn{Array|Hash}> conditional tag
sub IsInArray {
    my ($ctx, $args) = @_;

    defined (my $name = $args->{name} || $args->{var})
        or return $ctx->error (MT->translate ("Parameter '[_1]' is required", 'name'));
    defined (my $value = $args->{value})
        or return $ctx->error (MT->translate ("Parameter '[_1]' is required", 'value'));

    my $var = $ctx->var ($name);
    if (ref $var eq 'ARRAY') {
        my $origin = $args->{origin} || 0;
        return 0 if @$var < $origin;
        foreach ($origin..@$var) {
            if ($var->[$_] == $value) {
                $ctx->var ('__index__', $_);
                return 1;
            }
        }
    }
    elsif (ref $var eq 'HASH') {
        foreach (keys %$var) {
            if ($var->{$_} == $value) {
                $ctx->var ('__key__', $_);
                return 1;
            }
        }
    }
    return 0;
}

### <mt:SetArrayVars> block tag
sub SetArrayVars {
    my ($ctx, $args, $cond) = @_;

    defined (my $name = $args->{name} || $args->{var})
        or return $ctx->error (MT->translate ("Parameter '[_1]' is required", 'name'));
    my $var = $ctx->var ($name) || [];
    ref $var eq 'ARRAY'
        or return $ctx->error (MT->translate ("'[_1]' is not an array.", $name));

    my $block = $ctx->slurp ($args, $cond)
        or return; # build error occurs

    my $iorigin = $args->{origin} || 0;
    my $delimit = $args->{delimitor} || '=';
    foreach (split /[\r\n]/, $block) {
        s/^\s+|\s+$//g;     # trim \s
        my ($index, $value) = /^(\d+)\s*\Q$delimit\E\s*(.*)/;
        next unless defined $index;
        $var->[$iorigin + $index] = $value;
    }
    $ctx->var ($name, $var);

    return $args->{debug} ? $block : '';
}

### <mt:SetForeachArrayVars> block tag
sub SetForeachArrayVars {
    my ($ctx, $args, $cond) = @_;

    defined (my $name = $args->{name} || $args->{var})
        or return $ctx->error (MT->translate ("Parameter '[_1]' is required", 'name'));
    my $var = $ctx->var ($name) || [];
    ref $var eq 'ARRAY'
        or return $ctx->error (MT->translate ("'[_1]' is not an array.", $name));

    my $block = $ctx->slurp ($args, $cond)
        or return; # build error occurs

    my $index = $args->{origin} || 0;
    foreach (split /[\r\n]/, $block) {
        s/^\s+|\s+$//g;     # trim \s
        $var->[$index++] = $_;
    }
    $ctx->var ($name, $var);

    return $args->{debug} ? $block : '';
}

### <mt:SetHashVars> block tag
sub SetHashVars {
    my ($ctx, $args, $cond) = @_;

    defined (my $name = $args->{name} || $args->{var})
        or return $ctx->error (MT->translate ("Parameter '[_1]' is required", 'name'));
    my $var = $ctx->var ($name) || {};
    ref $var eq 'HASH'
        or return $ctx->error (MT->translate ("'[_1]' is not a hash.", $name));

    my $block = $ctx->slurp ($args, $cond)
        or return; # build error occurs

    my $delimit = $args->{delimitor} || '=';
    foreach (split /[\r\n]/, $block) {
        s/^\s+|\s+$//g;     # trim \s
        my ($key, $value) = /^(.+?)\s*\Q$delimit\E\s*(.*)/;
        next unless defined $key;
        $var->{$key} = $value;
    }
    $ctx->var ($name, $var);

    return $args->{debug} ? $block : '';
}

1;