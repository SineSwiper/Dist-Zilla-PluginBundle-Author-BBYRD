package Dist::Zilla::PluginBundle::Author::BBYRD;

# VERSION
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
   );
   $self->add_plugins(
      # [ReadmeAnyFromPod / ReadmeHtmlInBuild]
      # [ReadmeAnyFromPod / ReadmePodInBuild]
      [ReadmeAnyFromPod => ReadmeHtmlInBuild => {}],
      [ReadmeAnyFromPod => ReadmePodInBuild  => {}],
   );
   $self->add_merged(
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
      # [MetaYAML]
      qw( CheckPrereqsIndexed MetaConfig MetaJSON MetaYAML ),
      
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
   );
   $self->add_plugins(  # freeform option plugin
      [MetaResourcesFromGit => {
         x_irc            => (exists $self->payload->{x_irc} ? $self->payload->{x_irc} : 'irc://irc.perl.org/#distzilla'),
         'bugtracker.web' => 'https://github.com/%a/%r/issues',
      }],
   );
   $self->add_merged(
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
      $self->config_short_merge('TravisYML', { test_min_deps => 1 }),

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

__END__

=begin wikidoc

= SYNOPSIS
 
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
   [MetaYAML]

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
 
= DESCRIPTION
 
[I frelling hate these things|sanity], but several releases in, I found myself
needing to keep my {dist.ini} stuff in sync, which requires a single module to
bind them to.

= NAMING SCHEME

I'm a strong believer in structured order in the chaos that is the CPAN
namespace.  There's enough cruft in CPAN, with all of the forked modules, 
legacy stuff that should have been removed 10 years ago, and confusion over
which modules are available vs. which ones actually work.  (Which all stem
from the same base problem, so I'm almost repeating myself...)

Like I said, I hate writing these personalized modules on CPAN.  I even bantered
around the idea of using [MetaCPAN's author JSON input|https://github.com/SineSwiper/Dist-Zilla-PluginBundle-BeLike-You/blob/master/BeLike-You.pod]
to store the plugin data.  However, keeping the Author plugins separated from the
real PluginBundles is a step in the right direction.  See
[KENTNL's comments on the Author namespace|Dist::Zilla::PluginBundle::Author::KENTNL/NAMING-SCHEME]
for more information.

= CAVEATS

This uses [Dist::Zilla::Role::PluginBundle::Merged], so all of the plugins'
arguments are available, using Merged's rules.  Special care should be
made with arguments that might not be unique with other plugins.  (Eventually,
I'll throw these into {config_rename}.)

If this is a problem, you might want to consider using [@Filter|Dist::Zilla::PluginBundle::Filter].

One exception is {x_irc}, which is detected and passed to [MetaResourcesFromGit|Dist::Zilla::Plugin::MetaResourcesFromGit]
properly.

= SEE ALSO

In building my ultimate {dist.ini} file, I did a bunch of research on which
modules to cram in here.  As a result, this is a pretty large set of plugins,
but that's exactly how I like my DZIL.  Feel free to research the modules
listed here, as there's a bunch of good modules that you might want to include
in your own {dist.ini} and/or Author bundle.

Also, here's my {profile.ini}, if you're interested:

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

= TODO

Create a [Pod::Weaver] author bundle.

=end wikidoc
