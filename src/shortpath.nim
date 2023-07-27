import argparse
import sequtils
import strformat
import system
import unicode
import shortpath/crawler

const prog = "shortpath"
const VERSION {.strdefine.}: string = "0.0.0"

proc bail(message: string) =
  stderr.writeLine message
  quit(QuitFailure)

proc showVersion() =
  stdout.write(&"{prog} {VERSION}\n")
  quit(QuitSuccess)

proc validateShortest(shortest: string): int =
  result = parseInt(shortest)
  if result <= 0:
    raise newException(ValueError, "shortest must be greater than 0")

proc validateIndicator(indicator: string): Rune =
  for rune in indicator.runes:
    result = rune
    break
  if result == Rune(0):
    raise newException(ValueError, "unable to parse indicator rune")

const helpString = """
Description:
  This is a small command line utility that returns a string representing the
  current working directory where the name of each parent directory has been
  shortened to the smallest uniquely identifiable string for the directory in
  which it resides. The primary intended use case for this utility is to
  construct the current working directory in the command line prompt. For
  example, a normal prompt would contain the full path to the current working
  directory (pwd) in the prompt, but with 'shortpath', the prompt is shortened
  considerably without removing so much information that confusion could
  occur."""

when isMainModule:
  var p = newParser(prog):
    help(helpString)
    flag("-v", "--version", help="Show version")
    option(
      "-s", "--shortest", default=some("3"),
      help="Set minimum directory truncated length")
    option(
      "-i", "--indicator", default=some("…"),
      help="Set the truncation rune")
    run:
      if opts.version: showVersion()
      let shortest = validateShortest(opts.shortest)
      let indicator = validateIndicator(opts.indicator)
      shorten(shortest, indicator)
  try:
    p.run()
  except:
    bail(&"Error: {getCurrentExceptionMsg()}\n\n{p.help}")
