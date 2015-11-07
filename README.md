# apache-log-metrics.pl

## overview

given an apache `access.log` file in the following [log format](http://httpd.apache.org/docs/2.2/mod/mod_log_config.html):

    %a %l %u %t \"%r\" %>s %b %D

print out a list of metrics relating to the log file content.  particularly:

  * number of successful requests per minute
  * number of error requests per minute
  * mean response time per minute, in seconds
  * data sent, in mb


## installation

clone the repo to your machine with the following:

    git clone git@github.com:hybby/apache-log-metrics.git


## usage

simply provide a log file to the script, then sit back and relax:

    ./apache-log-metrics.pl /var/tmp/sample-logs/access.log


## dependancies

Perl, no non-core modules required.  i tested on:

    $ perl -v
    This is perl 5, version 18, subversion 2 (v5.18.2)


## performance

parsed the sample log file pretty quickly, actually, considering its size (~100mb):

    $ time ./apache-log-metrics.pl /var/tmp/sample-logs/access.log
    real  0m1.384s
    user  0m1.343s
    sys 0m0.036s


## implementation details

i took a two-pronged approach to this:

  * parse our log file and load metrics into a hash
  * parse our hash and output our metrics, just how we like

since there was an obvious key to use (`$day/$month/$year $hour:$min`), it would
be pretty easy to do this.  the log was uniform enough that i could build a pretty
comprehensive regexp for it, too.  this had the bonus of flagging nonsense lines.


## tests

### parse valid logfile

    $ ./apache-log-metrics.pl /var/tmp/sample-logs/access.log
    30/Mar/2015 05:04 - successful_reqs: 816, error_reqs: 2, mb_sent_per_min: 13.9381322860718, avg_response_per_min: 0.350734759168704 secs
    30/Mar/2015 05:05 - successful_reqs: 823, error_reqs: 2, mb_sent_per_min: 13.2216300964355, avg_response_per_min: 0.302940841212121 secs
    30/Mar/2015 05:06 - successful_reqs: 879, error_reqs: 2, mb_sent_per_min: 17.8774175643921, avg_response_per_min: 0.297992407491487 secs
    30/Mar/2015 05:07 - successful_reqs: 806, error_reqs: 2, mb_sent_per_min: 12.0799551010132, avg_response_per_min: 0.277300165841584 secs
    30/Mar/2015 05:08 - successful_reqs: 880, error_reqs: 2, mb_sent_per_min: 12.5115175247192, avg_response_per_min: 0.425662876417234 secs
    30/Mar/2015 05:09 - successful_reqs: 986, error_reqs: 2, mb_sent_per_min: 18.6307973861694, avg_response_per_min: 0.469404145748988 secs
    30/Mar/2015 05:10 - successful_reqs: 852, error_reqs: 2, mb_sent_per_min: 12.6580600738525, avg_response_per_min: 0.267417720140515 secs
    30/Mar/2015 05:11 - successful_reqs: 832, error_reqs: 2, mb_sent_per_min: 17.0411033630371, avg_response_per_min: 0.316910028776978 secs
    30/Mar/2015 05:12 - successful_reqs: 916, error_reqs: 2, mb_sent_per_min: 14.1581735610962, avg_response_per_min: 0.310959300653595 secs
    30/Mar/2015 05:13 - successful_reqs: 840, error_reqs: 2, mb_sent_per_min: 13.2748794555664, avg_response_per_min: 0.292990725653207 secs
    30/Mar/2015 05:14 - successful_reqs: 1044, error_reqs: 2, mb_sent_per_min: 19.6655864715576, avg_response_per_min: 0.579928620458891 secs
    30/Mar/2015 05:15 - successful_reqs: 905, error_reqs: 2, mb_sent_per_min: 16.2723722457886, avg_response_per_min: 0.331990899669239 secs
    30/Mar/2015 05:16 - successful_reqs: 898, error_reqs: 2, mb_sent_per_min: 12.7184057235718, avg_response_per_min: 0.269189484444444 secs
    30/Mar/2015 05:17 - successful_reqs: 867, error_reqs: 2, mb_sent_per_min: 18.4040193557739, avg_response_per_min: 0.322718324510932 secs
    30/Mar/2015 05:18 - successful_reqs: 939, error_reqs: 2, mb_sent_per_min: 13.7634811401367, avg_response_per_min: 0.294438331562168 secs
    30/Mar/2015 05:19 - successful_reqs: 1009, error_reqs: 2, mb_sent_per_min: 17.4522485733032, avg_response_per_min: 0.394786738872404 secs
    30/Mar/2015 05:20 - successful_reqs: 864, error_reqs: 2, mb_sent_per_min: 12.8236246109009, avg_response_per_min: 0.381195995381062 secs
    30/Mar/2015 05:21 - successful_reqs: 796, error_reqs: 2, mb_sent_per_min: 12.626669883728, avg_response_per_min: 0.283333067669173 secs
    30/Mar/2015 05:22 - successful_reqs: 846, error_reqs: 2, mb_sent_per_min: 14.2702417373657, avg_response_per_min: 0.273469982311321 secs
    30/Mar/2015 05:23 - successful_reqs: 807, error_reqs: 2, mb_sent_per_min: 10.6161975860596, avg_response_per_min: 0.249765957972806 secs
    30/Mar/2015 05:24 - successful_reqs: 1057, error_reqs: 2, mb_sent_per_min: 19.6062793731689, avg_response_per_min: 0.338897846081209 secs
    30/Mar/2015 05:25 - successful_reqs: 867, error_reqs: 2, mb_sent_per_min: 13.6644916534424, avg_response_per_min: 0.308667289988493 secs
    30/Mar/2015 05:26 - successful_reqs: 951, error_reqs: 2, mb_sent_per_min: 17.5113534927368, avg_response_per_min: 0.403051454354669 secs
    30/Mar/2015 05:27 - successful_reqs: 860, error_reqs: 2, mb_sent_per_min: 19.9910087585449, avg_response_per_min: 0.3471521774942 secs
    30/Mar/2015 05:28 - successful_reqs: 897, error_reqs: 2, mb_sent_per_min: 12.336067199707, avg_response_per_min: 0.297385379310345 secs
    30/Mar/2015 05:29 - successful_reqs: 1001, error_reqs: 2, mb_sent_per_min: 18.5306005477905, avg_response_per_min: 0.398125065802592 secs
    30/Mar/2015 05:30 - successful_reqs: 907, error_reqs: 2, mb_sent_per_min: 14.3022050857544, avg_response_per_min: 0.263879306930693 secs
    30/Mar/2015 05:31 - successful_reqs: 804, error_reqs: 2, mb_sent_per_min: 11.9211349487305, avg_response_per_min: 0.312935983870968 secs
    30/Mar/2015 05:32 - successful_reqs: 887, error_reqs: 2, mb_sent_per_min: 15.6225700378418, avg_response_per_min: 0.400594312710911 secs
    30/Mar/2015 05:33 - successful_reqs: 822, error_reqs: 2, mb_sent_per_min: 13.1280889511108, avg_response_per_min: 0.329150211165049 secs
    30/Mar/2015 05:34 - successful_reqs: 1033, error_reqs: 2, mb_sent_per_min: 18.7780094146729, avg_response_per_min: 0.428906100483092 secs
    30/Mar/2015 05:35 - successful_reqs: 872, error_reqs: 2, mb_sent_per_min: 13.5270080566406, avg_response_per_min: 0.300610107551487 secs
    30/Mar/2015 05:36 - successful_reqs: 948, error_reqs: 2, mb_sent_per_min: 14.2431011199951, avg_response_per_min: 0.279513528421053 secs
    30/Mar/2015 05:37 - successful_reqs: 815, error_reqs: 2, mb_sent_per_min: 16.2764949798584, avg_response_per_min: 0.317639014687883 secs
    30/Mar/2015 05:38 - successful_reqs: 927, error_reqs: 2, mb_sent_per_min: 14.5190000534058, avg_response_per_min: 0.39718890204521 secs
    30/Mar/2015 05:39 - successful_reqs: 1000, error_reqs: 5, mb_sent_per_min: 20.8782777786255, avg_response_per_min: 0.401716506467662 secs
    30/Mar/2015 05:40 - successful_reqs: 912, error_reqs: 2, mb_sent_per_min: 13.2415399551392, avg_response_per_min: 0.326717143326039 secs
    30/Mar/2015 05:41 - successful_reqs: 872, error_reqs: 2, mb_sent_per_min: 13.7226915359497, avg_response_per_min: 0.337560453089245 secs
    30/Mar/2015 05:42 - successful_reqs: 954, error_reqs: 2, mb_sent_per_min: 17.6946811676025, avg_response_per_min: 0.247370074267782 secs
    30/Mar/2015 05:43 - successful_reqs: 809, error_reqs: 2, mb_sent_per_min: 12.5027647018433, avg_response_per_min: 0.284384641183724 secs
    30/Mar/2015 05:44 - successful_reqs: 1021, error_reqs: 2, mb_sent_per_min: 17.3939847946167, avg_response_per_min: 0.476916909090909 secs
    30/Mar/2015 05:45 - successful_reqs: 795, error_reqs: 2, mb_sent_per_min: 13.2599010467529, avg_response_per_min: 0.274566982434128 secs
    30/Mar/2015 05:46 - successful_reqs: 864, error_reqs: 2, mb_sent_per_min: 12.9853086471558, avg_response_per_min: 0.315534120092379 secs
    30/Mar/2015 05:47 - successful_reqs: 805, error_reqs: 2, mb_sent_per_min: 15.3784551620483, avg_response_per_min: 0.318500737298637 secs
    30/Mar/2015 05:48 - successful_reqs: 972, error_reqs: 2, mb_sent_per_min: 15.5730924606323, avg_response_per_min: 0.297615990759754 secs
    30/Mar/2015 05:49 - successful_reqs: 951, error_reqs: 2, mb_sent_per_min: 18.2481021881104, avg_response_per_min: 0.379606511017838 secs
    30/Mar/2015 05:50 - successful_reqs: 961, error_reqs: 2, mb_sent_per_min: 15.8251113891602, avg_response_per_min: 0.425114686396677 secs
    30/Mar/2015 05:51 - successful_reqs: 839, error_reqs: 2, mb_sent_per_min: 15.7167167663574, avg_response_per_min: 0.359422938168847 secs
    30/Mar/2015 05:52 - successful_reqs: 879, error_reqs: 1, mb_sent_per_min: 18.1451330184937, avg_response_per_min: 0.310879459090909 secs
    30/Mar/2015 05:53 - successful_reqs: 820, error_reqs: 2, mb_sent_per_min: 13.077977180481, avg_response_per_min: 0.32110603649635 secs
    30/Mar/2015 05:54 - successful_reqs: 1065, error_reqs: 1, mb_sent_per_min: 19.1975440979004, avg_response_per_min: 0.347743081613508 secs
    30/Mar/2015 05:55 - successful_reqs: 777, error_reqs: 2, mb_sent_per_min: 12.7950496673584, avg_response_per_min: 0.324811246469833 secs
    30/Mar/2015 05:56 - successful_reqs: 930, error_reqs: 1, mb_sent_per_min: 14.6022090911865, avg_response_per_min: 0.380810332975295 secs
    30/Mar/2015 05:57 - successful_reqs: 856, error_reqs: 2, mb_sent_per_min: 20.0852670669556, avg_response_per_min: 0.372200854312354 secs
    30/Mar/2015 05:58 - successful_reqs: 877, error_reqs: 1, mb_sent_per_min: 12.1642265319824, avg_response_per_min: 0.300375470387244 secs
    30/Mar/2015 05:59 - successful_reqs: 945, error_reqs: 2, mb_sent_per_min: 17.5973930358887, avg_response_per_min: 0.42701643189018 secs
    30/Mar/2015 06:00 - successful_reqs: 951, error_reqs: 2, mb_sent_per_min: 15.0028686523438, avg_response_per_min: 0.303795093389297 secs
    30/Mar/2015 06:01 - successful_reqs: 808, error_reqs: 2, mb_sent_per_min: 12.777735710144, avg_response_per_min: 0.350183565432099 secs
    30/Mar/2015 06:02 - successful_reqs: 939, error_reqs: 2, mb_sent_per_min: 17.861213684082, avg_response_per_min: 0.371028315621679 secs
    30/Mar/2015 06:03 - successful_reqs: 896, error_reqs: 2, mb_sent_per_min: 15.9628639221191, avg_response_per_min: 0.416923780623608 secs
    30/Mar/2015 06:04 - successful_reqs: 1085, error_reqs: 5, mb_sent_per_min: 19.4585762023926, avg_response_per_min: 0.393640516513761 secs
    30/Mar/2015 06:05 - successful_reqs: 917, error_reqs: 2, mb_sent_per_min: 15.0955657958984, avg_response_per_min: 0.403244874863983 secs
    30/Mar/2015 06:06 - successful_reqs: 1051, error_reqs: 2, mb_sent_per_min: 16.2255392074585, avg_response_per_min: 0.309473785375119 secs
    30/Mar/2015 06:07 - successful_reqs: 828, error_reqs: 2, mb_sent_per_min: 17.1854181289673, avg_response_per_min: 0.334022446987952 secs
    30/Mar/2015 06:08 - successful_reqs: 914, error_reqs: 2, mb_sent_per_min: 12.6036033630371, avg_response_per_min: 0.346717745633188 secs
    30/Mar/2015 06:09 - successful_reqs: 960, error_reqs: 2, mb_sent_per_min: 17.8028221130371, avg_response_per_min: 0.386275375259875 secs
    30/Mar/2015 06:10 - successful_reqs: 892, error_reqs: 2, mb_sent_per_min: 13.0174865722656, avg_response_per_min: 0.283699484340045 secs
    30/Mar/2015 06:11 - successful_reqs: 838, error_reqs: 2, mb_sent_per_min: 13.6509132385254, avg_response_per_min: 0.308985979761905 secs
    30/Mar/2015 06:12 - successful_reqs: 962, error_reqs: 2, mb_sent_per_min: 20.8720054626465, avg_response_per_min: 0.355403217842324 secs
    30/Mar/2015 06:13 - successful_reqs: 860, error_reqs: 2, mb_sent_per_min: 12.4232311248779, avg_response_per_min: 0.268190336426914 secs
    30/Mar/2015 06:14 - successful_reqs: 1047, error_reqs: 2, mb_sent_per_min: 18.6616487503052, avg_response_per_min: 0.420733832221163 secs
    30/Mar/2015 06:15 - successful_reqs: 868, error_reqs: 2, mb_sent_per_min: 15.6543817520142, avg_response_per_min: 0.442841308045977 secs
    30/Mar/2015 06:16 - successful_reqs: 920, error_reqs: 2, mb_sent_per_min: 15.0003108978271, avg_response_per_min: 0.327870376355748 secs
    30/Mar/2015 06:17 - successful_reqs: 843, error_reqs: 2, mb_sent_per_min: 17.7292852401733, avg_response_per_min: 0.345795349112426 secs
    30/Mar/2015 06:18 - successful_reqs: 943, error_reqs: 2, mb_sent_per_min: 14.4986133575439, avg_response_per_min: 0.289646926984127 secs
    30/Mar/2015 06:19 - successful_reqs: 1016, error_reqs: 2, mb_sent_per_min: 18.4685497283936, avg_response_per_min: 0.346252066797642 secs
    30/Mar/2015 06:20 - successful_reqs: 931, error_reqs: 2, mb_sent_per_min: 14.1675148010254, avg_response_per_min: 0.357912053590568 secs
    30/Mar/2015 06:21 - successful_reqs: 837, error_reqs: 2, mb_sent_per_min: 14.7769041061401, avg_response_per_min: 0.386694287246722 secs
    30/Mar/2015 06:22 - successful_reqs: 891, error_reqs: 2, mb_sent_per_min: 19.1881074905396, avg_response_per_min: 0.358618580067189 secs
    30/Mar/2015 06:23 - successful_reqs: 810, error_reqs: 2, mb_sent_per_min: 14.0843410491943, avg_response_per_min: 0.302902915024631 secs
    30/Mar/2015 06:24 - successful_reqs: 977, error_reqs: 2, mb_sent_per_min: 17.2435789108276, avg_response_per_min: 0.29381420020429 secs
    30/Mar/2015 06:25 - successful_reqs: 885, error_reqs: 1, mb_sent_per_min: 14.5908317565918, avg_response_per_min: 0.306138270880361 secs
    30/Mar/2015 06:26 - successful_reqs: 888, error_reqs: 2, mb_sent_per_min: 13.328182220459, avg_response_per_min: 0.339554661797753 secs
    30/Mar/2015 06:27 - successful_reqs: 901, error_reqs: 2, mb_sent_per_min: 21.2570428848267, avg_response_per_min: 0.468731178294574 secs
    30/Mar/2015 06:28 - successful_reqs: 955, error_reqs: 2, mb_sent_per_min: 15.7645406723022, avg_response_per_min: 0.323845826541275 secs
    30/Mar/2015 06:29 - successful_reqs: 978, error_reqs: 2, mb_sent_per_min: 17.7609691619873, avg_response_per_min: 0.365102365306122 secs
    30/Mar/2015 06:30 - successful_reqs: 892, error_reqs: 2, mb_sent_per_min: 14.1027660369873, avg_response_per_min: 0.275290967561521 secs
    30/Mar/2015 06:31 - successful_reqs: 836, error_reqs: 2, mb_sent_per_min: 14.1926069259644, avg_response_per_min: 0.313378391408115 secs
    30/Mar/2015 06:32 - successful_reqs: 902, error_reqs: 2, mb_sent_per_min: 18.7040176391602, avg_response_per_min: 0.402213172566372 secs
    30/Mar/2015 06:33 - successful_reqs: 843, error_reqs: 2, mb_sent_per_min: 14.6114664077759, avg_response_per_min: 0.39386518816568 secs
    30/Mar/2015 06:34 - successful_reqs: 1021, error_reqs: 2, mb_sent_per_min: 18.2804718017578, avg_response_per_min: 0.302277617790811 secs
    30/Mar/2015 06:35 - successful_reqs: 859, error_reqs: 2, mb_sent_per_min: 13.0775384902954, avg_response_per_min: 0.289973981416957 secs
    30/Mar/2015 06:36 - successful_reqs: 938, error_reqs: 2, mb_sent_per_min: 15.8054304122925, avg_response_per_min: 0.299790354255319 secs
    30/Mar/2015 06:37 - successful_reqs: 914, error_reqs: 2, mb_sent_per_min: 18.9332590103149, avg_response_per_min: 0.326300645196507 secs
    30/Mar/2015 06:38 - successful_reqs: 950, error_reqs: 2, mb_sent_per_min: 13.5771379470825, avg_response_per_min: 0.345541322478992 secs
    30/Mar/2015 06:39 - successful_reqs: 1018, error_reqs: 2, mb_sent_per_min: 20.5828189849854, avg_response_per_min: 0.487918540196078 secs
    30/Mar/2015 06:40 - successful_reqs: 920, error_reqs: 2, mb_sent_per_min: 15.990083694458, avg_response_per_min: 0.298063027114967 secs
    30/Mar/2015 06:41 - successful_reqs: 824, error_reqs: 2, mb_sent_per_min: 13.0277919769287, avg_response_per_min: 0.279998659806295 secs
    30/Mar/2015 06:42 - successful_reqs: 958, error_reqs: 2, mb_sent_per_min: 16.4889764785767, avg_response_per_min: 0.34187151875 secs
    30/Mar/2015 06:43 - successful_reqs: 876, error_reqs: 2, mb_sent_per_min: 20.138355255127, avg_response_per_min: 0.35326675284738 secs
    30/Mar/2015 06:44 - successful_reqs: 1008, error_reqs: 1, mb_sent_per_min: 17.2606611251831, avg_response_per_min: 0.404214853320119 secs
    30/Mar/2015 06:45 - successful_reqs: 843, error_reqs: 2, mb_sent_per_min: 13.8030490875244, avg_response_per_min: 0.457339512426035 secs
    30/Mar/2015 06:46 - successful_reqs: 850, error_reqs: 2, mb_sent_per_min: 12.1379776000977, avg_response_per_min: 0.281023845070422 secs
    30/Mar/2015 06:47 - successful_reqs: 814, error_reqs: 2, mb_sent_per_min: 13.8630924224854, avg_response_per_min: 0.340277504901961 secs
    30/Mar/2015 06:48 - successful_reqs: 913, error_reqs: 2, mb_sent_per_min: 17.8733329772949, avg_response_per_min: 0.365299442622951 secs
    30/Mar/2015 06:49 - successful_reqs: 997, error_reqs: 2, mb_sent_per_min: 17.3660068511963, avg_response_per_min: 0.346632228228228 secs
    30/Mar/2015 06:50 - successful_reqs: 965, error_reqs: 2, mb_sent_per_min: 15.8220653533936, avg_response_per_min: 0.323025682523268 secs
    30/Mar/2015 06:51 - successful_reqs: 877, error_reqs: 2, mb_sent_per_min: 15.7138929367065, avg_response_per_min: 0.466242800910125 secs
    30/Mar/2015 06:52 - successful_reqs: 931, error_reqs: 2, mb_sent_per_min: 15.0631666183472, avg_response_per_min: 0.363248260450161 secs
    30/Mar/2015 06:53 - successful_reqs: 866, error_reqs: 2, mb_sent_per_min: 18.4397325515747, avg_response_per_min: 0.340603852534562 secs
    30/Mar/2015 06:54 - successful_reqs: 1076, error_reqs: 5, mb_sent_per_min: 18.8017997741699, avg_response_per_min: 0.354934862164662 secs
    30/Mar/2015 06:55 - successful_reqs: 974, error_reqs: 2, mb_sent_per_min: 15.7407302856445, avg_response_per_min: 0.282684641393443 secs
    30/Mar/2015 06:56 - successful_reqs: 933, error_reqs: 3, mb_sent_per_min: 13.3367033004761, avg_response_per_min: 0.29823846474359 secs
    30/Mar/2015 06:57 - successful_reqs: 881, error_reqs: 2, mb_sent_per_min: 15.3014268875122, avg_response_per_min: 0.484470995469989 secs
    30/Mar/2015 06:58 - successful_reqs: 927, error_reqs: 3, mb_sent_per_min: 16.2814645767212, avg_response_per_min: 0.319456250537634 secs
    30/Mar/2015 06:59 - successful_reqs: 975, error_reqs: 2, mb_sent_per_min: 18.6110544204712, avg_response_per_min: 0.477100333674514 secs
    30/Mar/2015 07:00 - successful_reqs: 973, error_reqs: 2, mb_sent_per_min: 12.0444173812866, avg_response_per_min: 0.390386745641026 secs
    30/Mar/2015 07:01 - successful_reqs: 841, error_reqs: 2, mb_sent_per_min: 13.9711942672729, avg_response_per_min: 0.337529046263345 secs
    30/Mar/2015 07:02 - successful_reqs: 1018, error_reqs: 2, mb_sent_per_min: 17.6854906082153, avg_response_per_min: 0.386506491176471 secs
    30/Mar/2015 07:03 - successful_reqs: 901, error_reqs: 2, mb_sent_per_min: 20.4526853561401, avg_response_per_min: 0.512618757475083 secs
    30/Mar/2015 07:04 - successful_reqs: 998, error_reqs: 2, mb_sent_per_min: 18.4139413833618, avg_response_per_min: 0.385950572 secs
    30/Mar/2015 07:05 - successful_reqs: 899, error_reqs: 2, mb_sent_per_min: 16.4261865615845, avg_response_per_min: 0.324898890122087 secs
    30/Mar/2015 07:06 - successful_reqs: 918, error_reqs: 2, mb_sent_per_min: 14.6510190963745, avg_response_per_min: 0.331531214130435 secs
    30/Mar/2015 07:07 - successful_reqs: 824, error_reqs: 2, mb_sent_per_min: 13.6667919158936, avg_response_per_min: 0.322004837772397 secs
    30/Mar/2015 07:08 - successful_reqs: 935, error_reqs: 2, mb_sent_per_min: 16.9589128494263, avg_response_per_min: 0.359299310565635 secs
    30/Mar/2015 07:09 - successful_reqs: 985, error_reqs: 2, mb_sent_per_min: 17.819278717041, avg_response_per_min: 0.513630156028369 secs
    30/Mar/2015 07:10 - successful_reqs: 875, error_reqs: 2, mb_sent_per_min: 12.8209047317505, avg_response_per_min: 0.290243059293045 secs
    30/Mar/2015 07:11 - successful_reqs: 818, error_reqs: 2, mb_sent_per_min: 12.4387969970703, avg_response_per_min: 0.298523430487805 secs
    30/Mar/2015 07:12 - successful_reqs: 949, error_reqs: 2, mb_sent_per_min: 15.387788772583, avg_response_per_min: 0.331104517350158 secs
    30/Mar/2015 07:13 - successful_reqs: 785, error_reqs: 1, mb_sent_per_min: 15.7450923919678, avg_response_per_min: 0.348349711195929 secs
    30/Mar/2015 07:14 - successful_reqs: 1071, error_reqs: 2, mb_sent_per_min: 18.2836875915527, avg_response_per_min: 0.423355943150047 secs
    30/Mar/2015 07:15 - successful_reqs: 1011, error_reqs: 2, mb_sent_per_min: 18.0953302383423, avg_response_per_min: 0.477201153998026 secs
    30/Mar/2015 07:16 - successful_reqs: 906, error_reqs: 4, mb_sent_per_min: 15.3121147155762, avg_response_per_min: 0.353786468131868 secs
    30/Mar/2015 07:17 - successful_reqs: 850, error_reqs: 2, mb_sent_per_min: 15.2063055038452, avg_response_per_min: 0.349426237089202 secs
    30/Mar/2015 07:18 - successful_reqs: 933, error_reqs: 2, mb_sent_per_min: 18.1655979156494, avg_response_per_min: 0.33942252513369 secs
    30/Mar/2015 07:19 - successful_reqs: 910, error_reqs: 2, mb_sent_per_min: 16.7013645172119, avg_response_per_min: 0.359959313596491 secs
    30/Mar/2015 07:20 - successful_reqs: 1000, error_reqs: 2, mb_sent_per_min: 15.3766012191772, avg_response_per_min: 0.308987171656687 secs
    30/Mar/2015 07:21 - successful_reqs: 901, error_reqs: 2, mb_sent_per_min: 16.2172899246216, avg_response_per_min: 0.564933626799557 secs
    30/Mar/2015 07:22 - successful_reqs: 864, error_reqs: 2, mb_sent_per_min: 12.3379459381104, avg_response_per_min: 0.375102991916859 secs
    30/Mar/2015 07:23 - successful_reqs: 827, error_reqs: 2, mb_sent_per_min: 15.5031642913818, avg_response_per_min: 0.28889843305187 secs
    30/Mar/2015 07:24 - successful_reqs: 991, error_reqs: 2, mb_sent_per_min: 16.9263887405396, avg_response_per_min: 0.370978093655589 secs
    30/Mar/2015 07:25 - successful_reqs: 840, error_reqs: 3, mb_sent_per_min: 11.7712450027466, avg_response_per_min: 0.266716421115065 secs
    30/Mar/2015 07:26 - successful_reqs: 986, error_reqs: 2, mb_sent_per_min: 14.8584222793579, avg_response_per_min: 0.331219439271255 secs
    30/Mar/2015 07:27 - successful_reqs: 918, error_reqs: 2, mb_sent_per_min: 16.0552158355713, avg_response_per_min: 0.462968390217391 secs
    30/Mar/2015 07:28 - successful_reqs: 945, error_reqs: 2, mb_sent_per_min: 17.5170097351074, avg_response_per_min: 0.35655532312566 secs
    30/Mar/2015 07:29 - successful_reqs: 979, error_reqs: 2, mb_sent_per_min: 18.4354829788208, avg_response_per_min: 0.447217493374108 secs
    30/Mar/2015 07:30 - successful_reqs: 966, error_reqs: 2, mb_sent_per_min: 15.168511390686, avg_response_per_min: 0.324457486570248 secs
    30/Mar/2015 07:31 - successful_reqs: 854, error_reqs: 2, mb_sent_per_min: 14.6130485534668, avg_response_per_min: 0.306654853971963 secs
    30/Mar/2015 07:32 - successful_reqs: 924, error_reqs: 2, mb_sent_per_min: 12.4407033920288, avg_response_per_min: 0.29589517062635 secs
    30/Mar/2015 07:33 - successful_reqs: 866, error_reqs: 2, mb_sent_per_min: 16.9249296188354, avg_response_per_min: 0.503794444700461 secs
    30/Mar/2015 07:34 - successful_reqs: 996, error_reqs: 2, mb_sent_per_min: 16.6851186752319, avg_response_per_min: 0.369734185370741 secs
    30/Mar/2015 07:35 - successful_reqs: 918, error_reqs: 2, mb_sent_per_min: 14.6315116882324, avg_response_per_min: 0.265827416304348 secs
    30/Mar/2015 07:36 - successful_reqs: 962, error_reqs: 2, mb_sent_per_min: 16.1101236343384, avg_response_per_min: 0.291465355809129 secs
    30/Mar/2015 07:37 - successful_reqs: 827, error_reqs: 2, mb_sent_per_min: 13.5823106765747, avg_response_per_min: 0.329787675512666 secs
    30/Mar/2015 07:38 - successful_reqs: 1034, error_reqs: 2, mb_sent_per_min: 18.7873277664185, avg_response_per_min: 0.339063965250965 secs
    30/Mar/2015 07:39 - successful_reqs: 1019, error_reqs: 2, mb_sent_per_min: 18.5133066177368, avg_response_per_min: 0.536503129285015 secs
    30/Mar/2015 07:40 - successful_reqs: 957, error_reqs: 2, mb_sent_per_min: 15.7159595489502, avg_response_per_min: 0.292298923879041 secs
    30/Mar/2015 07:41 - successful_reqs: 862, error_reqs: 2, mb_sent_per_min: 14.7695665359497, avg_response_per_min: 0.322723695601852 secs
    30/Mar/2015 07:42 - successful_reqs: 992, error_reqs: 2, mb_sent_per_min: 14.8253831863403, avg_response_per_min: 0.293448022132797 secs
    30/Mar/2015 07:43 - successful_reqs: 843, error_reqs: 2, mb_sent_per_min: 16.123104095459, avg_response_per_min: 0.317911810650888 secs
    30/Mar/2015 07:44 - successful_reqs: 1076, error_reqs: 3, mb_sent_per_min: 18.1372966766357, avg_response_per_min: 0.39510781742354 secs
    30/Mar/2015 07:45 - successful_reqs: 1020, error_reqs: 2, mb_sent_per_min: 18.6997699737549, avg_response_per_min: 0.549026536203522 secs
    30/Mar/2015 07:46 - successful_reqs: 897, error_reqs: 2, mb_sent_per_min: 12.8238840103149, avg_response_per_min: 0.384831262513904 secs
    30/Mar/2015 07:47 - successful_reqs: 873, error_reqs: 2, mb_sent_per_min: 14.6671314239502, avg_response_per_min: 0.327847299428571 secs
    30/Mar/2015 07:48 - successful_reqs: 930, error_reqs: 2, mb_sent_per_min: 18.3182821273804, avg_response_per_min: 0.425264669527897 secs
    30/Mar/2015 07:49 - successful_reqs: 921, error_reqs: 2, mb_sent_per_min: 16.8157653808594, avg_response_per_min: 0.380513604550379 secs
    30/Mar/2015 07:50 - successful_reqs: 1010, error_reqs: 2, mb_sent_per_min: 15.8886518478394, avg_response_per_min: 0.363954283596838 secs
    30/Mar/2015 07:51 - successful_reqs: 954, error_reqs: 2, mb_sent_per_min: 17.1954660415649, avg_response_per_min: 0.646901513598326 secs
    30/Mar/2015 07:52 - successful_reqs: 956, error_reqs: 2, mb_sent_per_min: 16.2718906402588, avg_response_per_min: 0.345088816283925 secs
    30/Mar/2015 07:53 - successful_reqs: 1082, error_reqs: 14, mb_sent_per_min: 18.8788890838623, avg_response_per_min: 0.532539852189781 secs
    30/Mar/2015 07:54 - successful_reqs: 1200, error_reqs: 15, mb_sent_per_min: 19.6491794586182, avg_response_per_min: 0.322803099588477 secs
    30/Mar/2015 07:55 - successful_reqs: 878, error_reqs: 2, mb_sent_per_min: 13.7824764251709, avg_response_per_min: 0.364652644318182 secs
    30/Mar/2015 07:56 - successful_reqs: 878, error_reqs: 2, mb_sent_per_min: 12.6205263137817, avg_response_per_min: 0.288424373863636 secs
    30/Mar/2015 07:57 - successful_reqs: 1317, error_reqs: 2, mb_sent_per_min: 20.3019495010376, avg_response_per_min: 0.330379651250948 secs
    30/Mar/2015 07:58 - successful_reqs: 964, error_reqs: 2, mb_sent_per_min: 18.7576360702515, avg_response_per_min: 0.324978666666667 secs
    30/Mar/2015 07:59 - successful_reqs: 950, error_reqs: 2, mb_sent_per_min: 13.926064491272, avg_response_per_min: 0.485437674369748 secs
    30/Mar/2015 08:00 - successful_reqs: 1052, error_reqs: 2, mb_sent_per_min: 17.2652168273926, avg_response_per_min: 0.292400780834915 secs
    30/Mar/2015 08:01 - successful_reqs: 876, error_reqs: 2, mb_sent_per_min: 14.824914932251, avg_response_per_min: 0.337386398633257 secs
    30/Mar/2015 08:02 - successful_reqs: 979, error_reqs: 2, mb_sent_per_min: 14.3268814086914, avg_response_per_min: 0.345411317023445 secs
    30/Mar/2015 08:03 - successful_reqs: 1313, error_reqs: 2, mb_sent_per_min: 25.1416921615601, avg_response_per_min: 0.373932 secs
    30/Mar/2015 08:04 - successful_reqs: 1081, error_reqs: 2, mb_sent_per_min: 19.1477546691895, avg_response_per_min: 0.373482639889197 secs
    30/Mar/2015 08:05 - successful_reqs: 969, error_reqs: 2, mb_sent_per_min: 17.056960105896, avg_response_per_min: 0.319088406797116 secs
    30/Mar/2015 08:06 - successful_reqs: 1069, error_reqs: 4, mb_sent_per_min: 17.5335903167725, avg_response_per_min: 0.408786992544268 secs
    30/Mar/2015 08:07 - successful_reqs: 921, error_reqs: 2, mb_sent_per_min: 14.7946805953979, avg_response_per_min: 0.308849283856988 secs
    30/Mar/2015 08:08 - successful_reqs: 1049, error_reqs: 2, mb_sent_per_min: 18.418381690979, avg_response_per_min: 0.337863831588963 secs
    30/Mar/2015 08:09 - successful_reqs: 1118, error_reqs: 2, mb_sent_per_min: 21.3875284194946, avg_response_per_min: 0.507612532142857 secs
    30/Mar/2015 08:10 - successful_reqs: 1006, error_reqs: 1, mb_sent_per_min: 16.2891473770142, avg_response_per_min: 0.289871372393247 secs
    30/Mar/2015 08:11 - successful_reqs: 861, error_reqs: 8, mb_sent_per_min: 11.519437789917, avg_response_per_min: 0.404215357882624 secs
    30/Mar/2015 08:12 - successful_reqs: 969, error_reqs: 2, mb_sent_per_min: 15.3329620361328, avg_response_per_min: 0.307146375901133 secs
    30/Mar/2015 08:13 - successful_reqs: 879, error_reqs: 11, mb_sent_per_min: 16.3478422164917, avg_response_per_min: 0.386169104494382 secs
    30/Mar/2015 08:14 - successful_reqs: 1066, error_reqs: 2, mb_sent_per_min: 21.1054248809814, avg_response_per_min: 0.370264324906367 secs
    30/Mar/2015 08:15 - successful_reqs: 1095, error_reqs: 2, mb_sent_per_min: 21.1560792922974, avg_response_per_min: 0.470441574293528 secs
    30/Mar/2015 08:16 - successful_reqs: 1094, error_reqs: 3, mb_sent_per_min: 19.8230686187744, avg_response_per_min: 0.423140917958067 secs
    30/Mar/2015 08:17 - successful_reqs: 1092, error_reqs: 2, mb_sent_per_min: 17.107982635498, avg_response_per_min: 0.298928171846435 secs
    30/Mar/2015 08:18 - successful_reqs: 1074, error_reqs: 2, mb_sent_per_min: 17.484733581543, avg_response_per_min: 0.371422722118959 secs
    30/Mar/2015 08:19 - successful_reqs: 1005, error_reqs: 2, mb_sent_per_min: 21.4009113311768, avg_response_per_min: 0.38672866633565 secs
    30/Mar/2015 08:20 - successful_reqs: 1072, error_reqs: 1, mb_sent_per_min: 16.85218334198, avg_response_per_min: 0.425860295433364 secs
    30/Mar/2015 08:21 - successful_reqs: 1049, error_reqs: 1, mb_sent_per_min: 17.2910842895508, avg_response_per_min: 0.487711553333333 secs
    30/Mar/2015 08:22 - successful_reqs: 974, error_reqs: 2, mb_sent_per_min: 13.7915153503418, avg_response_per_min: 0.285555968237705 secs
    30/Mar/2015 08:23 - successful_reqs: 932, error_reqs: 2, mb_sent_per_min: 15.7184839248657, avg_response_per_min: 0.290166940042827 secs
    30/Mar/2015 08:24 - successful_reqs: 1099, error_reqs: 2, mb_sent_per_min: 21.9893703460693, avg_response_per_min: 0.356053925522253 secs
    30/Mar/2015 08:25 - successful_reqs: 971, error_reqs: 2, mb_sent_per_min: 18.2165393829346, avg_response_per_min: 0.324634232271326 secs
    30/Mar/2015 08:26 - successful_reqs: 867, error_reqs: 2, mb_sent_per_min: 12.4375658035278, avg_response_per_min: 0.32596281703107 secs
    30/Mar/2015 08:27 - successful_reqs: 878, error_reqs: 2, mb_sent_per_min: 14.521089553833, avg_response_per_min: 0.511213004545454 secs
    30/Mar/2015 08:28 - successful_reqs: 815, error_reqs: 2, mb_sent_per_min: 12.9182214736938, avg_response_per_min: 0.346440512851897 secs
    30/Mar/2015 08:29 - successful_reqs: 883, error_reqs: 2, mb_sent_per_min: 17.2705507278442, avg_response_per_min: 0.442452574011299 secs
    30/Mar/2015 08:30 - successful_reqs: 918, error_reqs: 2, mb_sent_per_min: 16.519061088562, avg_response_per_min: 0.339992823913043 secs
    30/Mar/2015 08:31 - successful_reqs: 835, error_reqs: 16, mb_sent_per_min: 11.0057582855225, avg_response_per_min: 0.320869796709753 secs
    30/Mar/2015 08:32 - successful_reqs: 846, error_reqs: 2, mb_sent_per_min: 13.0774927139282, avg_response_per_min: 0.334021900943396 secs
    30/Mar/2015 08:33 - successful_reqs: 881, error_reqs: 2, mb_sent_per_min: 13.7311515808105, avg_response_per_min: 0.493103590033975 secs
    30/Mar/2015 08:34 - successful_reqs: 857, error_reqs: 2, mb_sent_per_min: 16.8196334838867, avg_response_per_min: 0.3246474225844 secs
    30/Mar/2015 08:35 - successful_reqs: 861, error_reqs: 2, mb_sent_per_min: 11.5077066421509, avg_response_per_min: 0.293532358053302 secs
    30/Mar/2015 08:36 - successful_reqs: 817, error_reqs: 2, mb_sent_per_min: 11.5357151031494, avg_response_per_min: 0.356936615384615 secs
    30/Mar/2015 08:37 - successful_reqs: 720, error_reqs: 2, mb_sent_per_min: 10.3163919448853, avg_response_per_min: 0.349833281163435 secs
    30/Mar/2015 08:38 - successful_reqs: 877, error_reqs: 2, mb_sent_per_min: 11.670337677002, avg_response_per_min: 0.354346433447099 secs
    30/Mar/2015 08:39 - successful_reqs: 956, error_reqs: 2, mb_sent_per_min: 21.0570592880249, avg_response_per_min: 0.522446050104384 secs
    30/Mar/2015 08:40 - successful_reqs: 1116, error_reqs: 2, mb_sent_per_min: 12.6230688095093, avg_response_per_min: 0.450729823792487 secs
    30/Mar/2015 08:41 - successful_reqs: 798, error_reqs: 2, mb_sent_per_min: 12.7666234970093, avg_response_per_min: 0.55618990625 secs
    30/Mar/2015 08:42 - successful_reqs: 882, error_reqs: 2, mb_sent_per_min: 14.7007913589478, avg_response_per_min: 0.449217014705882 secs
    30/Mar/2015 08:43 - successful_reqs: 733, error_reqs: 2, mb_sent_per_min: 12.6327295303345, avg_response_per_min: 0.361440745578231 secs
    30/Mar/2015 08:44 - successful_reqs: 912, error_reqs: 2, mb_sent_per_min: 13.7803325653076, avg_response_per_min: 0.450647828227571 secs
    30/Mar/2015 08:45 - successful_reqs: 942, error_reqs: 2, mb_sent_per_min: 14.5556535720825, avg_response_per_min: 0.478221468220339 secs
    30/Mar/2015 08:46 - successful_reqs: 867, error_reqs: 2, mb_sent_per_min: 11.8116283416748, avg_response_per_min: 0.319587494821634 secs
    30/Mar/2015 08:47 - successful_reqs: 758, error_reqs: 2, mb_sent_per_min: 9.4557933807373, avg_response_per_min: 0.318603139473684 secs
    30/Mar/2015 08:48 - successful_reqs: 934, error_reqs: 2, mb_sent_per_min: 14.742091178894, avg_response_per_min: 0.744789082264957 secs
    30/Mar/2015 08:49 - successful_reqs: 833, error_reqs: 2, mb_sent_per_min: 15.8183813095093, avg_response_per_min: 0.381704419161677 secs
    30/Mar/2015 08:50 - successful_reqs: 949, error_reqs: 2, mb_sent_per_min: 12.8576459884644, avg_response_per_min: 0.443707299684543 secs
    30/Mar/2015 08:51 - successful_reqs: 858, error_reqs: 2, mb_sent_per_min: 11.9554491043091, avg_response_per_min: 0.530983212790698 secs
    30/Mar/2015 08:52 - successful_reqs: 810, error_reqs: 3, mb_sent_per_min: 10.0177364349365, avg_response_per_min: 0.366428537515375 secs
    30/Mar/2015 08:53 - successful_reqs: 795, error_reqs: 2, mb_sent_per_min: 15.3249034881592, avg_response_per_min: 0.515928819322459 secs
    30/Mar/2015 08:54 - successful_reqs: 925, error_reqs: 3, mb_sent_per_min: 18.0157794952393, avg_response_per_min: 0.346779646551724 secs
    30/Mar/2015 08:55 - successful_reqs: 956, error_reqs: 2, mb_sent_per_min: 17.3490800857544, avg_response_per_min: 0.393898831941545 secs
    30/Mar/2015 08:56 - successful_reqs: 808, error_reqs: 2, mb_sent_per_min: 10.6343488693237, avg_response_per_min: 0.372888311111111 secs
    30/Mar/2015 08:57 - successful_reqs: 886, error_reqs: 2, mb_sent_per_min: 13.4552974700928, avg_response_per_min: 0.557171552927928 secs
    30/Mar/2015 08:58 - successful_reqs: 809, error_reqs: 2, mb_sent_per_min: 11.428936958313, avg_response_per_min: 0.319770681874229 secs
    30/Mar/2015 08:59 - successful_reqs: 859, error_reqs: 2, mb_sent_per_min: 17.3882169723511, avg_response_per_min: 0.749882428571429 secs
    30/Mar/2015 09:00 - successful_reqs: 937, error_reqs: 2, mb_sent_per_min: 13.5170059204102, avg_response_per_min: 0.364515954206603 secs
    30/Mar/2015 09:01 - successful_reqs: 717, error_reqs: 2, mb_sent_per_min: 10.4647397994995, avg_response_per_min: 0.328588648122392 secs
    30/Mar/2015 09:02 - successful_reqs: 859, error_reqs: 6, mb_sent_per_min: 12.3932476043701, avg_response_per_min: 0.355551335260116 secs
    30/Mar/2015 09:03 - successful_reqs: 913, error_reqs: 2, mb_sent_per_min: 15.6278228759766, avg_response_per_min: 0.630103996721311 secs
    30/Mar/2015 09:04 - successful_reqs: 885, error_reqs: 2, mb_sent_per_min: 17.0773153305054, avg_response_per_min: 0.393720777903044 secs
    30/Mar/2015 09:05 - successful_reqs: 948, error_reqs: 2, mb_sent_per_min: 15.1818876266479, avg_response_per_min: 0.393395882105263 secs
    30/Mar/2015 09:06 - successful_reqs: 920, error_reqs: 2, mb_sent_per_min: 13.674017906189, avg_response_per_min: 0.498253713665944 secs
    30/Mar/2015 09:07 - successful_reqs: 766, error_reqs: 2, mb_sent_per_min: 11.5480318069458, avg_response_per_min: 0.413721024739583 secs
    30/Mar/2015 09:08 - successful_reqs: 877, error_reqs: 2, mb_sent_per_min: 11.6459636688232, avg_response_per_min: 0.373394122866894 secs
    30/Mar/2015 09:09 - successful_reqs: 945, error_reqs: 2, mb_sent_per_min: 16.4259653091431, avg_response_per_min: 0.660618068637804 secs
    30/Mar/2015 09:10 - successful_reqs: 958, error_reqs: 3, mb_sent_per_min: 13.1871957778931, avg_response_per_min: 0.370492886576483 secs
    30/Mar/2015 09:11 - successful_reqs: 922, error_reqs: 2, mb_sent_per_min: 12.799976348877, avg_response_per_min: 0.413641557359307 secs
    30/Mar/2015 09:12 - successful_reqs: 938, error_reqs: 2, mb_sent_per_min: 12.8004570007324, avg_response_per_min: 0.510739638297872 secs
    30/Mar/2015 09:13 - successful_reqs: 800, error_reqs: 6, mb_sent_per_min: 10.5862245559692, avg_response_per_min: 0.384417570719603 secs
    30/Mar/2015 09:14 - successful_reqs: 1013, error_reqs: 2, mb_sent_per_min: 15.4080762863159, avg_response_per_min: 0.615251876847291 secs
    30/Mar/2015 09:15 - successful_reqs: 1015, error_reqs: 1, mb_sent_per_min: 13.8974876403809, avg_response_per_min: 0.570136099409449 secs
    30/Mar/2015 09:16 - successful_reqs: 1114, error_reqs: 1, mb_sent_per_min: 15.4177083969116, avg_response_per_min: 0.372726624215247 secs
    30/Mar/2015 09:17 - successful_reqs: 1466, error_reqs: 2, mb_sent_per_min: 32.68239402771, avg_response_per_min: 0.280754173024523 secs
    30/Mar/2015 09:18 - successful_reqs: 1184, error_reqs: 2, mb_sent_per_min: 17.3045387268066, avg_response_per_min: 0.40644218296796 secs
    30/Mar/2015 09:19 - successful_reqs: 1103, error_reqs: 2, mb_sent_per_min: 22.0717096328735, avg_response_per_min: 0.423774595475113 secs
    30/Mar/2015 09:20 - successful_reqs: 1188, error_reqs: 4, mb_sent_per_min: 17.2045783996582, avg_response_per_min: 1.50804913674497 secs
    30/Mar/2015 09:21 - successful_reqs: 1219, error_reqs: 3, mb_sent_per_min: 17.5173606872559, avg_response_per_min: 0.554397725040917 secs
    30/Mar/2015 09:22 - successful_reqs: 1113, error_reqs: 2, mb_sent_per_min: 16.0787658691406, avg_response_per_min: 0.32652184573991 secs
    30/Mar/2015 09:23 - successful_reqs: 966, error_reqs: 2, mb_sent_per_min: 14.6608200073242, avg_response_per_min: 0.333991824380165 secs
    30/Mar/2015 09:24 - successful_reqs: 1139, error_reqs: 2, mb_sent_per_min: 20.9306240081787, avg_response_per_min: 0.367901414548642 secs
    30/Mar/2015 09:25 - successful_reqs: 1171, error_reqs: 2, mb_sent_per_min: 19.8825855255127, avg_response_per_min: 0.395795719522592 secs
    30/Mar/2015 09:26 - successful_reqs: 1210, error_reqs: 2, mb_sent_per_min: 16.9473781585693, avg_response_per_min: 0.29845870379538 secs
    30/Mar/2015 09:27 - successful_reqs: 1180, error_reqs: 10, mb_sent_per_min: 18.4936981201172, avg_response_per_min: 0.654691926890756 secs
    30/Mar/2015 09:28 - successful_reqs: 1176, error_reqs: 2, mb_sent_per_min: 18.6486883163452, avg_response_per_min: 0.354837219864177 secs
    30/Mar/2015 09:29 - successful_reqs: 1175, error_reqs: 2, mb_sent_per_min: 23.7846145629883, avg_response_per_min: 0.432578915038233 secs
    30/Mar/2015 09:30 - successful_reqs: 1306, error_reqs: 2, mb_sent_per_min: 20.2267904281616, avg_response_per_min: 0.320994464067278 secs
    30/Mar/2015 09:31 - successful_reqs: 1503, error_reqs: 14, mb_sent_per_min: 18.820502281189, avg_response_per_min: 0.269039630191167 secs
    30/Mar/2015 09:32 - successful_reqs: 2084, error_reqs: 2, mb_sent_per_min: 16.1491813659668, avg_response_per_min: 0.184982393576222 secs
    30/Mar/2015 09:33 - successful_reqs: 1583, error_reqs: 2, mb_sent_per_min: 17.1332273483276, avg_response_per_min: 0.343150316719243 secs
    30/Mar/2015 09:34 - successful_reqs: 1664, error_reqs: 2, mb_sent_per_min: 21.4114971160889, avg_response_per_min: 0.241496327130852 secs
    30/Mar/2015 09:35 - successful_reqs: 1754, error_reqs: 2, mb_sent_per_min: 19.275218963623, avg_response_per_min: 0.253392566628702 secs
    30/Mar/2015 09:36 - successful_reqs: 1715, error_reqs: 2, mb_sent_per_min: 15.6585578918457, avg_response_per_min: 0.207007882935352 secs
    30/Mar/2015 09:37 - successful_reqs: 1540, error_reqs: 2, mb_sent_per_min: 16.181939125061, avg_response_per_min: 0.299393031776913 secs
    30/Mar/2015 09:38 - successful_reqs: 1704, error_reqs: 2, mb_sent_per_min: 16.1192617416382, avg_response_per_min: 0.217043252637749 secs
    30/Mar/2015 09:39 - successful_reqs: 1777, error_reqs: 2, mb_sent_per_min: 17.6820621490479, avg_response_per_min: 0.305199572793704 secs
    30/Mar/2015 09:40 - successful_reqs: 1883, error_reqs: 2, mb_sent_per_min: 25.9118747711182, avg_response_per_min: 0.341931902387268 secs
    30/Mar/2015 09:41 - successful_reqs: 1630, error_reqs: 2, mb_sent_per_min: 16.8245792388916, avg_response_per_min: 0.230148254289216 secs
    30/Mar/2015 09:42 - successful_reqs: 1668, error_reqs: 2, mb_sent_per_min: 16.9093255996704, avg_response_per_min: 0.244371117964072 secs
    30/Mar/2015 09:43 - successful_reqs: 1578, error_reqs: 2, mb_sent_per_min: 17.4581317901611, avg_response_per_min: 0.269707439873418 secs
    30/Mar/2015 09:44 - successful_reqs: 1561, error_reqs: 2, mb_sent_per_min: 13.6825752258301, avg_response_per_min: 0.346021873320537 secs
    30/Mar/2015 09:45 - successful_reqs: 1717, error_reqs: 2, mb_sent_per_min: 22.1059617996216, avg_response_per_min: 0.433466653286795 secs
    30/Mar/2015 09:46 - successful_reqs: 1631, error_reqs: 5, mb_sent_per_min: 16.5984716415405, avg_response_per_min: 0.189508061124694 secs
    30/Mar/2015 09:47 - successful_reqs: 1571, error_reqs: 2, mb_sent_per_min: 15.8218631744385, avg_response_per_min: 0.187595073744437 secs
    30/Mar/2015 09:48 - successful_reqs: 1471, error_reqs: 2, mb_sent_per_min: 13.3827123641968, avg_response_per_min: 0.249469202987101 secs
    30/Mar/2015 09:49 - successful_reqs: 1510, error_reqs: 2, mb_sent_per_min: 17.0147151947021, avg_response_per_min: 0.241015743386243 secs
    30/Mar/2015 09:50 - successful_reqs: 1734, error_reqs: 2, mb_sent_per_min: 20.62659740448, avg_response_per_min: 0.211121060483871 secs
    30/Mar/2015 09:51 - successful_reqs: 1582, error_reqs: 2, mb_sent_per_min: 15.4819850921631, avg_response_per_min: 0.270199486111111 secs
    30/Mar/2015 09:52 - successful_reqs: 1557, error_reqs: 2, mb_sent_per_min: 16.1328725814819, avg_response_per_min: 0.222407854393842 secs
    30/Mar/2015 09:53 - successful_reqs: 1519, error_reqs: 2, mb_sent_per_min: 15.4398126602173, avg_response_per_min: 0.234362607495069 secs
    30/Mar/2015 09:54 - successful_reqs: 1598, error_reqs: 2, mb_sent_per_min: 16.6538591384888, avg_response_per_min: 0.232341915625 secs
    30/Mar/2015 09:55 - successful_reqs: 1692, error_reqs: 6, mb_sent_per_min: 19.8611078262329, avg_response_per_min: 0.226678037102474 secs
    30/Mar/2015 09:56 - successful_reqs: 1577, error_reqs: 2, mb_sent_per_min: 14.0343837738037, avg_response_per_min: 0.184620787207093 secs
    30/Mar/2015 09:57 - successful_reqs: 1492, error_reqs: 1, mb_sent_per_min: 14.4392976760864, avg_response_per_min: 0.246984415271266 secs
    30/Mar/2015 09:58 - successful_reqs: 1639, error_reqs: 2, mb_sent_per_min: 14.7122755050659, avg_response_per_min: 0.282803808043876 secs
    30/Mar/2015 09:59 - successful_reqs: 1547, error_reqs: 2, mb_sent_per_min: 15.6199159622192, avg_response_per_min: 0.297429459651388 secs
    30/Mar/2015 10:00 - successful_reqs: 1602, error_reqs: 2, mb_sent_per_min: 16.6718130111694, avg_response_per_min: 0.227667577306733 secs
    30/Mar/2015 10:01 - successful_reqs: 1441, error_reqs: 2, mb_sent_per_min: 13.2797918319702, avg_response_per_min: 0.198631830907831 secs
    30/Mar/2015 10:02 - successful_reqs: 1469, error_reqs: 2, mb_sent_per_min: 13.2586641311646, avg_response_per_min: 0.188723013596193 secs
    30/Mar/2015 10:03 - successful_reqs: 1601, error_reqs: 2, mb_sent_per_min: 17.5222177505493, avg_response_per_min: 0.320659315658141 secs
    30/Mar/2015 10:04 - successful_reqs: 1518, error_reqs: 2, mb_sent_per_min: 13.402720451355, avg_response_per_min: 0.200547825 secs
    30/Mar/2015 10:05 - successful_reqs: 1619, error_reqs: 2, mb_sent_per_min: 16.7307262420654, avg_response_per_min: 0.220922275138803 secs
    30/Mar/2015 10:06 - successful_reqs: 1607, error_reqs: 3, mb_sent_per_min: 14.7855396270752, avg_response_per_min: 0.199838721118012 secs
    30/Mar/2015 10:07 - successful_reqs: 1451, error_reqs: 1, mb_sent_per_min: 13.7285470962524, avg_response_per_min: 0.191411610192837 secs
    30/Mar/2015 10:08 - successful_reqs: 1597, error_reqs: 2, mb_sent_per_min: 14.1764478683472, avg_response_per_min: 0.464504855534709 secs
    30/Mar/2015 10:09 - successful_reqs: 1589, error_reqs: 2, mb_sent_per_min: 17.3540935516357, avg_response_per_min: 0.28712539912005 secs
    30/Mar/2015 10:10 - successful_reqs: 1733, error_reqs: 9, mb_sent_per_min: 19.3515672683716, avg_response_per_min: 0.365117780137773 secs
    30/Mar/2015 10:11 - successful_reqs: 1487, error_reqs: 7, mb_sent_per_min: 13.1230230331421, avg_response_per_min: 0.277100370147256 secs
    30/Mar/2015 10:12 - successful_reqs: 20, error_reqs: 0, mb_sent_per_min: 0.0842266082763672, avg_response_per_min: 0.96148995 secs
    30/Mar/2015 10:13 - successful_reqs: 6, error_reqs: 0, mb_sent_per_min: 0.0511999130249023, avg_response_per_min: 1.8269695 secs
    30/Mar/2015 10:14 - successful_reqs: 14, error_reqs: 0, mb_sent_per_min: 1.29843997955322, avg_response_per_min: 1.50315535714286 secs
    30/Mar/2015 10:15 - successful_reqs: 37, error_reqs: 1, mb_sent_per_min: 0.817512512207031, avg_response_per_min: 1.96324081578947 secs
    30/Mar/2015 10:16 - successful_reqs: 43, error_reqs: 1, mb_sent_per_min: 0.743732452392578, avg_response_per_min: 0.895347318181818 secs
    30/Mar/2015 10:17 - successful_reqs: 44, error_reqs: 0, mb_sent_per_min: 0.570589065551758, avg_response_per_min: 0.438711363636364 secs
    30/Mar/2015 10:18 - successful_reqs: 53, error_reqs: 0, mb_sent_per_min: 0.747764587402344, avg_response_per_min: 0.751175528301887 secs
    30/Mar/2015 10:19 - successful_reqs: 20, error_reqs: 0, mb_sent_per_min: 0.409782409667969, avg_response_per_min: 1.1460133 secs
    30/Mar/2015 10:20 - successful_reqs: 23, error_reqs: 0, mb_sent_per_min: 0.65565299987793, avg_response_per_min: 0.538907565217391 secs
    30/Mar/2015 10:21 - successful_reqs: 39, error_reqs: 0, mb_sent_per_min: 0.834966659545898, avg_response_per_min: 0.685489051282051 secs
    30/Mar/2015 10:22 - successful_reqs: 11, error_reqs: 0, mb_sent_per_min: 1.27938747406006, avg_response_per_min: 1.53764345454545 secs
    30/Mar/2015 10:23 - successful_reqs: 15, error_reqs: 0, mb_sent_per_min: 0.299939155578613, avg_response_per_min: 0.887433066666667 secs
    30/Mar/2015 10:24 - successful_reqs: 19, error_reqs: 0, mb_sent_per_min: 0.125733375549316, avg_response_per_min: 0.691176631578947 secs
    30/Mar/2015 10:25 - successful_reqs: 6, error_reqs: 0, mb_sent_per_min: 0.0327348709106445, avg_response_per_min: 0.476221833333333 secs
    30/Mar/2015 10:26 - successful_reqs: 18, error_reqs: 0, mb_sent_per_min: 0.0892858505249023, avg_response_per_min: 0.440942166666667 secs
    30/Mar/2015 10:27 - successful_reqs: 5, error_reqs: 0, mb_sent_per_min: 0.0635595321655273, avg_response_per_min: 0.7066522 secs
    30/Mar/2015 10:28 - successful_reqs: 8, error_reqs: 0, mb_sent_per_min: 0.0872373580932617, avg_response_per_min: 1.05601425 secs
    30/Mar/2015 10:29 - successful_reqs: 5, error_reqs: 0, mb_sent_per_min: 0.0127420425415039, avg_response_per_min: 0.5573046 secs
    30/Mar/2015 10:31 - successful_reqs: 12, error_reqs: 0, mb_sent_per_min: 0.047144889831543, avg_response_per_min: 0.62479 secs
    30/Mar/2015 10:32 - successful_reqs: 46, error_reqs: 0, mb_sent_per_min: 0.220402717590332, avg_response_per_min: 0.172383847826087 secs
    30/Mar/2015 10:33 - successful_reqs: 60, error_reqs: 0, mb_sent_per_min: 0.482064247131348, avg_response_per_min: 0.886718033333333 secs
    30/Mar/2015 10:34 - successful_reqs: 38, error_reqs: 0, mb_sent_per_min: 0.137905120849609, avg_response_per_min: 0.316162315789474 secs
    30/Mar/2015 10:35 - successful_reqs: 42, error_reqs: 0, mb_sent_per_min: 0.355555534362793, avg_response_per_min: 0.788512166666667 secs
    30/Mar/2015 10:36 - successful_reqs: 26, error_reqs: 0, mb_sent_per_min: 0.104743957519531, avg_response_per_min: 0.322647730769231 secs
    30/Mar/2015 10:37 - successful_reqs: 46, error_reqs: 0, mb_sent_per_min: 0.387861251831055, avg_response_per_min: 0.992258347826087 secs
    30/Mar/2015 10:38 - successful_reqs: 23, error_reqs: 0, mb_sent_per_min: 0.328097343444824, avg_response_per_min: 0.505272956521739 secs
    30/Mar/2015 10:39 - successful_reqs: 46, error_reqs: 0, mb_sent_per_min: 1.77485847473145, avg_response_per_min: 0.913994521739131 secs
    30/Mar/2015 10:40 - successful_reqs: 18, error_reqs: 0, mb_sent_per_min: 0.105000495910645, avg_response_per_min: 0.423628611111111 secs
    30/Mar/2015 10:41 - successful_reqs: 16, error_reqs: 0, mb_sent_per_min: 0.10621166229248, avg_response_per_min: 0.727684875 secs
    30/Mar/2015 10:42 - successful_reqs: 31, error_reqs: 0, mb_sent_per_min: 0.209108352661133, avg_response_per_min: 0.603540483870968 secs
    30/Mar/2015 10:43 - successful_reqs: 18, error_reqs: 0, mb_sent_per_min: 0.139942169189453, avg_response_per_min: 0.381958777777778 secs
    30/Mar/2015 10:44 - successful_reqs: 64, error_reqs: 0, mb_sent_per_min: 2.94294738769531, avg_response_per_min: 0.831656140625 secs
    30/Mar/2015 10:45 - successful_reqs: 57, error_reqs: 0, mb_sent_per_min: 0.78600025177002, avg_response_per_min: 0.717381614035088 secs
    30/Mar/2015 10:46 - successful_reqs: 38, error_reqs: 0, mb_sent_per_min: 0.409462928771973, avg_response_per_min: 0.310379078947368 secs
    30/Mar/2015 10:47 - successful_reqs: 31, error_reqs: 0, mb_sent_per_min: 0.345664978027344, avg_response_per_min: 0.144774225806452 secs
    30/Mar/2015 10:48 - successful_reqs: 27, error_reqs: 0, mb_sent_per_min: 0.261883735656738, avg_response_per_min: 0.322477037037037 secs
    30/Mar/2015 10:49 - successful_reqs: 36, error_reqs: 0, mb_sent_per_min: 0.233757972717285, avg_response_per_min: 2.7979905 secs
    30/Mar/2015 10:50 - successful_reqs: 38, error_reqs: 0, mb_sent_per_min: 2.1085205078125, avg_response_per_min: 0.595556894736842 secs
    30/Mar/2015 10:51 - successful_reqs: 31, error_reqs: 0, mb_sent_per_min: 0.580886840820312, avg_response_per_min: 0.774810709677419 secs
    30/Mar/2015 10:52 - successful_reqs: 5, error_reqs: 0, mb_sent_per_min: 0.0369167327880859, avg_response_per_min: 0.3331146 secs
    30/Mar/2015 10:53 - successful_reqs: 20, error_reqs: 0, mb_sent_per_min: 0.205870628356934, avg_response_per_min: 0.3540435 secs
    30/Mar/2015 10:54 - successful_reqs: 10, error_reqs: 0, mb_sent_per_min: 0.0614614486694336, avg_response_per_min: 0.7481611 secs
    30/Mar/2015 10:55 - successful_reqs: 11, error_reqs: 0, mb_sent_per_min: 0.115100860595703, avg_response_per_min: 0.397092545454545 secs
    30/Mar/2015 10:56 - successful_reqs: 8, error_reqs: 0, mb_sent_per_min: 0.036224365234375, avg_response_per_min: 0.5568295 secs
    30/Mar/2015 10:57 - successful_reqs: 15, error_reqs: 1, mb_sent_per_min: 0.0819873809814453, avg_response_per_min: 0.851083375 secs
    30/Mar/2015 10:58 - successful_reqs: 14, error_reqs: 0, mb_sent_per_min: 0.0286569595336914, avg_response_per_min: 0.377349714285714 secs
    30/Mar/2015 10:59 - successful_reqs: 1, error_reqs: 0, mb_sent_per_min: 0.000180244445800781, avg_response_per_min: 0.352731 secs
    30/Mar/2015 11:00 - successful_reqs: 26, error_reqs: 0, mb_sent_per_min: 0.203055381774902, avg_response_per_min: 0.378435846153846 secs
    30/Mar/2015 11:01 - successful_reqs: 70, error_reqs: 0, mb_sent_per_min: 0.232627868652344, avg_response_per_min: 0.506772642857143 secs
    30/Mar/2015 11:02 - successful_reqs: 37, error_reqs: 0, mb_sent_per_min: 0.160929679870605, avg_response_per_min: 0.240758 secs
    30/Mar/2015 11:03 - successful_reqs: 51, error_reqs: 0, mb_sent_per_min: 0.337132453918457, avg_response_per_min: 0.466901254901961 secs
    30/Mar/2015 11:04 - successful_reqs: 43, error_reqs: 0, mb_sent_per_min: 0.87498950958252, avg_response_per_min: 0.535102139534884 secs
    30/Mar/2015 11:05 - successful_reqs: 24, error_reqs: 0, mb_sent_per_min: 1.5582332611084, avg_response_per_min: 0.764308916666667 secs
    30/Mar/2015 11:06 - successful_reqs: 22, error_reqs: 0, mb_sent_per_min: 0.0703725814819336, avg_response_per_min: 0.224239681818182 secs
    30/Mar/2015 11:07 - successful_reqs: 20, error_reqs: 1, mb_sent_per_min: 0.106915473937988, avg_response_per_min: 0.572116952380952 secs
    30/Mar/2015 11:08 - successful_reqs: 22, error_reqs: 0, mb_sent_per_min: 0.0826473236083984, avg_response_per_min: 0.288654772727273 secs
    30/Mar/2015 11:09 - successful_reqs: 22, error_reqs: 0, mb_sent_per_min: 0.109710693359375, avg_response_per_min: 0.525247045454545 secs
    30/Mar/2015 11:10 - successful_reqs: 19, error_reqs: 0, mb_sent_per_min: 0.183595657348633, avg_response_per_min: 0.804490842105263 secs
    30/Mar/2015 11:11 - successful_reqs: 23, error_reqs: 0, mb_sent_per_min: 0.113595008850098, avg_response_per_min: 0.543528130434783 secs

### attempt to parse log file that does not exist

    $ ./apache-log-metrics.pl /var/tmp/sample-logs/nonexists.log
    ./apache-log-metrics.pl: file "/var/tmp/sample-logs/nonexists.log" does not exist

### attempt to parse log file that is invalid or empty

    $ ./apache-log-metrics.pl /var/tmp/sample-logs/nonsense.log
    ./apache-log-metrics.pl: looks like you provided an invalid log file; we couldn't process any lines

### attempt to print out usage message

    $ ./apache-log-metrics.pl --help

    usage: ./apache-log-metrics.pl [-h|--help] file

    required arguments:

        file          path to apache access log file to parse
 
    optional arguments:

        -h, --help    show this help message and exit
    


