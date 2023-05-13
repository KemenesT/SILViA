## R CMD check results

For a CRAN submission we recommend that you fix all NOTEs, WARNINGs and ERRORs.
## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking examples ... ERROR
  Running examples in ‘SILViA-Ex.R’ failed
  The error most likely occurred in:
  
  > base::assign(".ptime", proc.time(), pos = "CheckExEnv")
  > ### Name: ctdat
  > ### Title: Example CTD Data from a SWiFT Device
  > ### Aliases: ctdat
  > ### Keywords: datasets
  > 
  > ### ** Examples
  > 
  > ## Load in example data and set it up in the temporary directory:
  > setup_example()
  > 
  > ## Read the example casts:
  > casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  Warning in file(con, "r") :
    cannot open file '/tmp/RtmpGGwsYb/working_dir/RtmpXobB6A\VL_12345_000000000001247e6b286992.vp2': No such file or directory
  Error in file(con, "r") : cannot open the connection
  Calls: read_vp2 -> readLines -> file
  Execution halted

❯ On ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking tests ...
    Running ‘testthat.R’
   ERROR
  Running the tests in ‘tests/testthat.R’ failed.
  Last 13 lines of output:
     2.   └─base::readLines(paste0(directory, "\\", fn))
     3.     └─base::file(con, "r")
    ── Error ('test-read_vp2.R:40:3'): setup_example stores the example files in the temporary directory ──
    Error in `file(con, "r")`: cannot open the connection
    Backtrace:
        ▆
     1. ├─testthat::expect_identical(...) at test-read_vp2.R:40:2
     2. │ └─testthat::quasi_label(enquo(expected), expected.label, arg = "expected")
     3. │   └─rlang::eval_bare(expr, quo_get_env(quo))
     4. └─base::readLines(...)
     5.   └─base::file(con, "r")
    
    [ FAIL 10 | WARN 10 | SKIP 0 | PASS 30 ]
    Error: Test failures
    Execution halted

❯ On windows-x86_64-devel (r-devel)
  checking CRAN incoming feasibility ... [11s] NOTE
  Maintainer: 'Thomas Kemenes van Uden <thomaskemenes@gmail.com>'
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    CTD (3:67, 13:24)
    Incongruent (3:39)
    SILViA (12:26)
    incongruent (15:33, 17:57)
    vp (16:67)

❯ On windows-x86_64-devel (r-devel)
  checking examples ... [40s] NOTE
  Examples with CPU (user + system) or elapsed time > 5s
                      user system elapsed
  plot_profiles      14.54   0.22   16.58
  draw_plot          12.41   0.08   13.53
  label_incongruents  5.43   0.04    6.60

❯ On windows-x86_64-devel (r-devel)
  checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

❯ On ubuntu-gcc-release (r-release)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: ‘Thomas Kemenes van Uden <thomaskemenes@gmail.com>’
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    CTD (3:67, 13:24)
    incongruent (15:33, 17:57)
    Incongruent (3:39)
    SILViA (12:26)
    vp (16:67)

❯ On ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found

❯ On fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... [4s/12s] NOTE
  Maintainer: ‘Thomas Kemenes van Uden <thomaskemenes@gmail.com>’
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    CTD (3:67, 13:24)
    Incongruent (3:39)
    SILViA (12:26)
    incongruent (15:33, 17:57)
    vp (16:67)

2 errors ✖ | 0 warnings ✔ | 7 notes ✖

* This is a new release.
