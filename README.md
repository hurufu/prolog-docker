# All the Prologs

🚧 This repo is work-in-progress, it isn't documented and may not even work!

The idea behind this repo is to have a usable docker container ultimately for
*all* Prolog implementations out there, to be able to easily test portability
of your code.

Currently it supports only handful of them, but it will support much more. I
have a lot of them working on my machine, but I will need to package them to
properly include here.

## Usage

If you use Arch Linux you can build packages yourself, but I plan to host
pre-build binaries to simplify it.

 1. Build packages (it may fail for a number of reasons, beware)

        make repo

 2. If you've built all the packages (the hard part), then it just works:

        make run

    This command will create a Docker image and it will run `test.pl` for all
    currently supported engines. If you want to test another default goal or
    different program file the simple redefine some variables:

        make run PROG=myprog.pl MAIN=mymain


## Currently working

SWI, Scryer, GNU, Ciao, Trealla.

## Anticipated implementations

Bin, ECLiPSe, Projog, B, Tu, Tau, SICStus, (if you have purchased the key),
Pop, Doge (JavaScript, Python, Java), Yap, XSB.

## Tried and wouldn't be supported

  * [JLog][a]– only GUI, but works Ok with cyclic terms.

        jlog: $(PROG)
        	java -jar /opt/jlog/1.3.6/JLog.jar

    JScriptLog has stuck in unfinished state from 2007, it runs, but it seems to
    support only hardcoded KB – some development is required.

  * [LPA-Prolog][b] – commercial license is needed.
  * [Brain Aid Prolog][c] – can't find sources.
  * [Strawberry Prolog][d] – full IDE no easy way to integrate
    into CLI.
  * [DGKS Prolog][e] – Looks like a someone's toy project from late 90', no CLI
    interface without writing custom Java code, can't handle operators correctly.

        dgks:
        	java -cp /usr/local/src/dgks-prolog/PrologO.zip prolog.dgks.prolog

  * Turbo Prolog – can't find source and it seems to be a lot of pain anyways.
    Links:
      * [Turbo Prolog Goodies][f]
  * [Quintus Prolog][g] – sources are paywalled, no real reason to use because
    it's successor SICStus is available.
  * [Minerva Prolog][h] – source code is unobtainium now.
  * [C# Prolog][i] – doesn't support cyclic terms and has non-standard exception
    handling.

        csh: $(PROG)
        	cd '/opt/C#Prolog SF4.1' && env MONO_PATH=CSProlog/obj/Debug mono PLd/obj/Debug/PLd.exe "['$(realpath $<)'],$(MAIN),halt."

  * [Amzi! Prolog][j] – looks like a complete IDE, hard to compile.
  * [Jinni Prolog][k] – code is freely availvable, but I don't have stamina to
    fix all compilation issues.
  * [IF/Prolog][l] – there are some very old sources, it might work or might not.
  * [BIM Prolog][m] – A lot of information, but no sources nor executables.
  * [Jekejeke Prolog][n] – I have found archived page, but .jar file wasn't
    archived and I don't like downloading it from random sites on internet.


## Still needs research

  * Ichiban Prolog[o]
  * Other systems: https://www.softwarepreservation.org/projects/prolog/
  * https://gitlab.com/gule-log/guile-log
  * https://github.com/DouglasRMiles/QuProlog
  * SmallTalk Prolog
  * https://github.com/leonweber/spyrolog
  * https://github.com/ptarau/iProlog
  * https://github.com/GunterMueller/UNSW_Prolog_and_iProlog
    https://www.cse.unsw.edu.au/~claude/research/software/prolog.html
  * http://www.projog.org/
  * https://github.com/JalogTeam/Jalog
  * ExperProlog
  * https://github.com/teyjus/teyjus

[a]: https://jlogic.sourceforge.net/ "JLog and JScriptLog sources"
[b]: https://www.lpa.co.uk/ind_pro.htm
[c]: http://www.fraber.de/bap/index.html
[d]: https://dobrev.com/
[e]: https://web.archive.org/web/20090724160647/http://geocities.com/SiliconValley/Campus/7816/
[f]: https://web.archive.org/web/20031203213809/http://perso.wanadoo.fr/colin.barker/tpro/tpro.htm
[g]: https://quintus.sics.se/
[h]: https://web.archive.org/web/20121105020447/http://www.ifcomputer.co.jp/MINERVA/Download/home_en.html
[i]: http://sourceforge.net/projects/cs-prolog/
[j]: http://www.amzi.com/AmziOpenSource/
[k]: https://github.com/heathmanb/JinniProlog
[l]: https://web.archive.org/web/20170717032834/http://www.ifcomputer.de/Products/Prolog/Download/home_de.html
[m]: https://people.cs.kuleuven.be/~Maurice.Bruynooghe/Prolog/Prolog.html
[n]: https://web.archive.org/web/20200223033605/http://www.jekejeke.ch/idatab/doclet/prod/en/docs/05_run/05_down.jsp
[o]: https://github.com/ichiban/prolog
