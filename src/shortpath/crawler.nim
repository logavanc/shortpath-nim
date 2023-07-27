import strformat
import unicode

proc shorten*(shortest: int, indicator: Rune) =
  echo &"shortest: {shortest}"
  echo &"indicator: '{indicator}'"
