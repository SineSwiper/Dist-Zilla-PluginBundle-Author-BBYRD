use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

# List our own version used to generate this
my $v = "\nGenerated by Dist::Zilla::Plugin::ReportVersions::Tiny v1.06\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = 'v5.10.1';
    $v .= "perl: $] (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Dist::Zilla','4.300026') };
eval { $v .= pmver('Dist::Zilla::Plugin::CheckExtraTests','0.007') };
eval { $v .= pmver('Dist::Zilla::Plugin::CheckPrereqsIndexed','0.007') };
eval { $v .= pmver('Dist::Zilla::Plugin::Clean','0.07') };
eval { $v .= pmver('Dist::Zilla::Plugin::CopyFilesFromBuild','0.103510') };
eval { $v .= pmver('Dist::Zilla::Plugin::GitFmtChanges','0.005') };
eval { $v .= pmver('Dist::Zilla::Plugin::InstallGuide','1.200000') };
eval { $v .= pmver('Dist::Zilla::Plugin::InstallRelease','0.008') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaProvides::Package','1.14000001') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaResourcesFromGit','1.103620') };
eval { $v .= pmver('Dist::Zilla::Plugin::NoTabsTests','0.01') };
eval { $v .= pmver('Dist::Zilla::Plugin::OurPkgVersion','0.004000') };
eval { $v .= pmver('Dist::Zilla::Plugin::PodWeaver','3.101641') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReadmeAnyFromPod','0.120120') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReportPhase','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReportVersions::Tiny','1.08') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::CPAN::Meta::JSON','0.003') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::CheckDeps','0.005') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::CheckManifest','0.04') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Compile','1.112820') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::DistManifest','2.000002') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::EOL','0.07') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::MinimumVersion','2.000002') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Portability','2.000003') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Synopsis','2.000002') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::UseAllModules','0.002') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Version','0.002004') };
eval { $v .= pmver('Dist::Zilla::Plugin::TravisYML','0.95') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Git','2.001') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Git::CheckFor','0.005') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::GitHub','0.27') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Prereqs','0.91') };
eval { $v .= pmver('Dist::Zilla::Role::PluginBundle::Merged','0.91') };
eval { $v .= pmver('Moose','2.0604') };
eval { $v .= pmver('Pod::Coverage::TrustPod','0.100002') };
eval { $v .= pmver('Pod::Elemental::Transformer::List','0.101620') };
eval { $v .= pmver('Pod::Weaver::Plugin::Encoding','0.01') };
eval { $v .= pmver('Pod::Weaver::Plugin::WikiDoc','0.093002') };
eval { $v .= pmver('Pod::Weaver::Section::Availability','1.20') };
eval { $v .= pmver('Pod::Weaver::Section::Support','1.005') };
eval { $v .= pmver('Test::CPAN::Meta::JSON','0.14') };
eval { $v .= pmver('Test::CheckDeps','0.002') };
eval { $v .= pmver('Test::UseAllModules','0.14') };
eval { $v .= pmver('autovivification','0.10') };
eval { $v .= pmver('indirect','0.26') };
eval { $v .= pmver('multidimensional','0.010') };
eval { $v .= pmver('sanity','0.94') };


# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve your problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
