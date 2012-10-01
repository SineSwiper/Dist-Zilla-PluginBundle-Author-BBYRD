package Dist::Zilla::PluginBundle::Author::BBYRD;

our $VERSION = '0.90'; # VERSION
# ABSTRACT: DZIL Author Bundle for BBYRD

use sanity;
use Moose;
 
with 'Dist::Zilla::Role::PluginBundle::Merged' => {
   mv_plugins => [ qw( PruneCruft @Prereqs CheckPrereqsIndexed MetaNoIndex CopyFilesFromBuild Git::CheckFor::CorrectBranch @Git ) ],
};
 
sub configure {
   my $self = shift;
   $self->add_merged(
      # [ReportPhase]
      #
      # ; Makefile.PL maker
      # [MakeMaker]
      #
      qw( ReportPhase MakeMaker ),
      
      # [Git::NextVersion]
      # first_version = 0.90
      $self->config_short_merge('Git::NextVersion', { first_version => '0.90' }),

      #
      # [Git::GatherDir]
      #
      # ; File modifiers
      # [OurPkgVersion]
      # [PodWeaver]
      #
      # ; File pruners
      # [PruneCruft]
      #
      # ; Extra file creation
      # [GitFmtChanges]
      # [ManifestSkip]
      # [Manifest]
      # [License]
      qw( Git::GatherDir OurPkgVersion PodWeaver PruneCruft GitFmtChanges ManifestSkip Manifest License ),

      # [ReadmeAnyFromPod / ReadmeHtmlInBuild]
      # [ReadmeAnyFromPod / ReadmePodInBuild]
      ### MOVED TO THE BOTTOM ###

      # [InstallGuide]
      # [ExecDir]
      # 
      # ; t/* tests
      # [Test::Compile]
      # 
      # ; POD tests
      # [PodCoverageTests]
      # [PodSyntaxTests]
      # ;[Test::PodSpelling]  ; Win32 install problems
      # 
      # ; Other xt/* tests
      # [RunExtraTests]
      # ;[MetaTests]  ; until Test::CPAN::Meta supports 2.0
      # [NoTabsTests]
      qw( InstallGuide ExecDir Test::Compile PodCoverageTests PodSyntaxTests RunExtraTests NoTabsTests ),

      # [Test::EOL]
      # trailing_whitespace = 0
      $self->config_short_merge('Test::EOL', { trailing_whitespace => 0 }),

      # 
      # [Test::CPAN::Meta::JSON]
      # [Test::CheckDeps]
      # [Test::Portability]
      # ;[Test::Pod::LinkCheck]  ; Both of these are borked...  
      # ;[Test::Pod::No404s]     ; ...I really need to create my own
      # [Test::Synopsis]
      # [Test::MinimumVersion]
      # [ReportVersions::Tiny]
      # [Test::CheckManifest]
      # [Test::DistManifest]
      # [Test::UseAllModules]
      # [Test::Version]
      (map { 'Test::'.$_ } qw(CPAN::Meta::JSON CheckDeps Portability Synopsis MinimumVersion CheckManifest DistManifest UseAllModules Version)),
      'ReportVersions::Tiny',

      # 
      # ; Prereqs
      # [@Prereqs]
      # minimum_perl = 5.10.1
      $self->config_short_merge('@Prereqs', { minimum_perl => '5.10.1' }),

      # 
      # [CheckPrereqsIndexed]
      # 
      # ; META maintenance
      # [MetaConfig]
      # [MetaJSON]
      qw( CheckPrereqsIndexed MetaConfig MetaJSON ),
      
      # 
      # [MetaNoIndex]
      # directory = t
      # directory = xt
      # directory = examples
      # directory = corpus
      $self->config_short_merge('MetaNoIndex', { directory => [qw(t xt examples corpus)] }),

      # 
      # [MetaProvides::Package]
      # meta_noindex = 1        ; respect prior no_index directives
      $self->config_short_merge('MetaProvides::Package', { meta_noindex => 1 }),

      # 
      # [MetaResourcesFromGit]
      # x_irc          = irc://irc.perl.org/#distzilla
      # bugtracker.web = https://github.com/%a/%r/issues
      $self->config_short_merge('MetaResourcesFromGit', { 
         x_irc            => 'irc://irc.perl.org/#distzilla',
         'bugtracker.web' => 'https://github.com/%a/%r/issues',
      }),

      # 
      # ; Post-build plugins
      # [CopyFilesFromBuild]
      # move = .gitignore
      # copy = README.pod
      $self->config_short_merge('CopyFilesFromBuild', { 
         move => ['.gitignore'],
         copy => ['README.pod'],
      }),

      # 
      # ; Post-build Git plugins
      # [TravisYML]
      # test_min_deps = 1
      $self->config_short_merge('MetaProvides::Package', { test_min_deps => 1 }),

      # 
      # [Git::CheckFor::CorrectBranch]
      'Git::CheckFor::CorrectBranch',

      # [Git::CommitBuild]
      # release_branch = build/%b
      # release_message = Release build of v%v (on %b)
      $self->config_short_merge('Git::CommitBuild', { 
         release_branch  => 'build/%b',
         release_message => 'Release build of v%v (on %b)',
      }),

      # 
      # [@Git]
      # allow_dirty = dist.ini
      # allow_dirty = .travis.yml
      # allow_dirty = README.pod
      # changelog =
      # commit_msg = Release v%v
      # push_to = origin
      # push_to = origin build/master:build/master
      $self->config_short_merge('@Git', { 
         allow_dirty => [qw(dist.ini .travis.yml README.pod)],
         changelog   => '',
         commit_msg  => 'Release v%v',
         push_to     => ['origin', 'origin build/master:build/master'],
      }),

      # 
      # [GitHub::Update]
      # metacpan = 1
      $self->config_short_merge('GitHub::Update', { metacpan => 1 }),

      # 
      # [TestRelease]
      # [ConfirmRelease]
      # [UploadToCPAN]
      # [InstallRelease]
      # [Clean]
      qw( TestRelease ConfirmRelease UploadToCPAN InstallRelease Clean ),
   );
   
   # [ReadmeAnyFromPod / ReadmeHtmlInBuild]
   # [ReadmeAnyFromPod / ReadmePodInBuild]
   $self->add_plugins(
      [ReadmeAnyFromPod => ReadmeHtmlInBuild => {}],
      [ReadmeAnyFromPod => ReadmePodInBuild  => {}],
   );
}

### TODO: This should probably go into DZIL:R:PB:Merged
sub config_short_merge {
   my ($self, $mod_list, $config_hash) = @_;
   return (
      { %$config_hash, %{$self->payload} },
      (ref $mod_list ? @$mod_list : $mod_list),
      $self->payload,
   );
}

42;



=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::PluginBundle::Author::BBYRD - DZIL Author Bundle for BBYRD

=head1 SYNOPSIS

    ; Very similar to...
 
    [ReportPhase]
 
    ; Makefile.PL maker
    [MakeMaker]
 
    [Git::NextVersion]
    first_version = 0.90
 
    [Git::GatherDir]
 
    ; File modifiers
    [OurPkgVersion]
    [PodWeaver]
 
    ; File pruners
    [PruneCruft]
 
    ; Extra file creation
    [GitFmtChanges]
    [ManifestSkip]
    [Manifest]
    [License]
    [ReadmeAnyFromPod / ReadmeHtmlInBuild]
    [ReadmeAnyFromPod / ReadmePodInBuild]
    [InstallGuide]
    [ExecDir]
 
    ; t/* tests
    [Test::Compile]
 
    ; POD tests
    [PodCoverageTests]
    [PodSyntaxTests]
    ;[Test::PodSpelling]  ; Win32 install problems
 
    ; Other xt/* tests
    [RunExtraTests]
    ;[MetaTests]  ; until Test::CPAN::Meta supports 2.0
    [NoTabsTests]
    [Test::EOL]
    trailing_whitespace = 0
 
    [Test::CPAN::Meta::JSON]
    [Test::CheckDeps]
    [Test::Portability]
    ;[Test::Pod::LinkCheck]  ; Both of these are borked...  
    ;[Test::Pod::No404s]     ; ...I really need to create my own
    [Test::Synopsis]
    [Test::MinimumVersion]
    [ReportVersions::Tiny]
    [Test::CheckManifest]
    [Test::DistManifest]
    [Test::UseAllModules]
    [Test::Version]
 
    ; Prereqs
    [@Prereqs]
    minimum_perl = 5.10.1
 
    [CheckPrereqsIndexed]
 
    ; META maintenance
    [MetaConfig]
    [MetaJSON]
 
    [MetaNoIndex]
    directory = t
    directory = xt
    directory = examples
    directory = corpus
 
    [MetaProvides::Package]
    meta_noindex = 1        ; respect prior no_index directives
 
    [MetaResourcesFromGit]
    x_irc          = irc://irc.perl.org/#distzilla
    bugtracker.web = https://github.com/%a/%r/issues
 
    ; Post-build plugins
    [CopyFilesFromBuild]
    move = .gitignore
    copy = README.pod
 
    ; Post-build Git plugins
    [TravisYML]
    test_min_deps = 1
 
    [Git::CheckFor::CorrectBranch]
    [Git::CommitBuild]
    release_branch = build/%b
    release_message = Release build of v%v (on %b)
 
    [@Git]
    allow_dirty = dist.ini
    allow_dirty = .travis.yml
    allow_dirty = README.pod
    changelog =
    commit_msg = Release v%v
    push_to = origin
    push_to = origin build/master:build/master
 
    [GitHub::Update]
    metacpan = 1
 
    [TestRelease]
    [ConfirmRelease]
    [UploadToCPAN]
    [InstallRelease]
    [Clean]
 
    ; PodWeaver deps
    ; authordep Pod::Weaver::Plugin::WikiDoc
    ; authordep Pod::Weaver::Plugin::Encoding
    ; authordep Pod::Weaver::Section::Availability
    ; authordep Pod::Weaver::Section::Support
    ; authordep Pod::Elemental::Transformer::List
 
    ; sanity deps
    ; authordep autovivification
    ; authordep indirect
    ; authordep multidimensional

=head1 DESCRIPTION

LE<lt>sanityE<verbar>I frelling hate these thingsE<gt>, but several releases in, I found myself
needing to keep my CE<lt>dist.iniE<gt> stuff in sync, which requires a single module to
bind them to.

=head1 NAMING SCHEME

I'm a strong believer in structured order in the chaos that is the CPAN
namespace.  There's enough cruft in CPAN, with all of the forked modules, 
legacy stuff that should have been removed 10 years ago, and confusion over
which modules are available vs. which ones actually work.  (Which all stem
from the same base problem, so I'm almost repeating myself...)

Like I said, I hate writing these personalized modules on CPAN.  I even bantered
around the idea of using LE<lt>https:E<sol>E<sol>github.comE<sol>SineSwiperE<sol>Dist-Zilla-PluginBundle-BeLike-YouE<sol>blobE<sol>masterE<sol>BeLike-You.podE<verbar>MetaCPAN's author JSON inputE<gt>
to store the plugin data.  However, keeping the Author plugins separated from the
real PluginBundles is a step in the right direction.  See
LE<lt>Dist::Zilla::PluginBundle::Author::KENTNLE<sol>NAMING-SCHEMEE<verbar>KENTNL's comments on the Author namespaceE<gt>
for more information.

=head1 CAVEATS

This uses LE<lt>Dist::Zilla::Role::PluginBundle::MergedE<gt>, so all of the plugin
arguments are available, using that plugin's rules.  Special care should be
made with arguments that might not be unique with other plugins.  (Eventually,
I'll throw these into CE<lt>config_renameE<gt>.)

If this is a problem, you might want to consider using LE<lt>Dist::Zilla::PluginBundle::FilterE<verbar>@FilterE<gt>.

=head1 SEE ALSO

In building my ultimate CE<lt>dist.iniE<gt> file, I did a bunch of research on which
modules to cram in here.  As a result, this is a pretty large set of plugins,
but that's exactly how I like my DZIL.  Feel free to research the modules
listed here, as there's a bunch of good modules that you might want to include
in your own CE<lt>dist.iniE<gt> andE<sol>or Author bundle.

Also, here's my CE<lt>profile.iniE<gt>, if you're interested:

    [TemplateModule/:DefaultModuleMaker]
    template = Module.pm
 
    [DistINI]
    append_file = plugins.ini
 
    [GatherDir::Template]
    root = skel
 
    [GenerateFile / Generate-.gitignore]
    filename = .gitignore
    is_template = 1
    content = MANIFEST
    content = MANIFEST.bak
    content = Makefile
    content = Makefile.old
    content = Build
    content = Build.bat
    content = META.*
    content = MYMETA.*
    content = .build/
    content = _build/
    content = blib/
    content = inc/
    content = .lwpcookies
    content = .last_cover_stats
    content = nytprof.out
    content = pod2htm*.tmp
    content = pm_to_blib
    content = {{$dist->name}}-*
    content = {{$dist->name}}-*.tar.gz
 
    [Git::Init]
    commit_message = Initial commit
 
    [GitHub::Create]

=head1 TODO

Create a LE<lt>Pod::WeaverE<gt> author bundle.

=head1 AVAILABILITY

The project homepage is L<https://github.com/SineSwiper/Dist-Zilla-PluginBundle-Author-BBYRD/wiki>.

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<https://metacpan.org/module/Dist::Zilla::PluginBundle::Author::BBYRD/>.

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Internet Relay Chat

You can get live help by using IRC ( Internet Relay Chat ). If you don't know what IRC is,
please read this excellent guide: L<http://en.wikipedia.org/wiki/Internet_Relay_Chat>. Please
be courteous and patient when talking to us, as we might be busy or sleeping! You can join
those networks/channels and get help:

=over 4

=item *

irc.perl.org

You can connect to the server at 'irc.perl.org' and join this channel: #distzilla then talk to this person for help: SineSwiper.

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests via L<L<https://github.com/SineSwiper/Dist-Zilla-PluginBundle-Author-BBYRD/issues>|GitHub>.

=head1 AUTHOR

Brendan Byrd <BBYRD@CPAN.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Brendan Byrd.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut


__END__

