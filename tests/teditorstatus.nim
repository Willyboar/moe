import unittest
import moepkg/[ui, highlight, editorstatus, editorview, gapbuffer, unicodeext, insertmode, movement, editor, window, color, bufferstatus]

test "Add new buffer":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.addNewBuffer("")
  status.resize(100, 100)
  check(status.bufStatus.len == 2)

test "Vertical split window":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.resize(100, 100)
  status.verticalSplitWindow

test "Horizontal split window":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.resize(100, 100)
  status.horizontalSplitWindow

test "resize 1":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.resize(100, 100)
  status.bufStatus[0].buffer = initGapBuffer(@[ru"a"])
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight = initHighlight($status.bufStatus[0].buffer, status.bufStatus[0].language)
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.view = initEditorView(status.bufStatus[0].buffer, 1, 1)
  status.resize(0, 0)

test "resize 2":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.resize(100, 100)
  status.bufStatus[0].buffer = initGapBuffer(@[ru"a"])
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight = initHighlight($status.bufStatus[0].buffer, status.bufStatus[0].language)
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.view = initEditorView(status.bufStatus[0].buffer, 20, 4)
  status.resize(20, 4)
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.currentColumn = 1
  status.changeMode(Mode.insert)
  for i in 0 ..< 10:
    status.bufStatus[0].keyEnter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoCloseParen)
    status.update

test "Highlight of a pair of paren 1":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight = initHighlight($status.bufStatus[0].buffer, status.bufStatus[0].language)

  block:
    status.bufStatus[0].buffer = initGapBuffer(@[ru"()"])
    status.updateHighlight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.update

    check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].firstColumn == 0)
    check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.parenText and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].firstColumn == 1)

  block:
    status.bufStatus[0].buffer = initGapBuffer(@[ru"[]"])
    status.updateHighlight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.update

    check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].firstColumn == 0)
    check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.parenText and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].firstColumn == 1)

  block:
    status.bufStatus[0].buffer = initGapBuffer(@[ru"{}"])
    status.updateHighlight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.update

    check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].firstColumn == 0)
    check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.parenText and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].firstColumn == 1)

  block:
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(()"])
    status.updateHighlight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.update

    check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].firstColumn == 0 and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].lastColumn == 2)

test "Highlight of a pair of paren 2":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight = initHighlight($status.bufStatus[0].buffer, status.bufStatus[0].language)

  status.bufStatus[0].buffer = initGapBuffer(@[ru"(())"])
  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].firstColumn == 0 and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].lastColumn == 2)
  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.parenText and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].firstColumn == 3)

test "Highlight of a pair of paren 3":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight = initHighlight($status.bufStatus[0].buffer, status.bufStatus[0].language)

  status.bufStatus[0].buffer = initGapBuffer(@[ru"(", ru")"])
  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].firstRow == 0)
  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.parenText and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].firstRow == 1)

test "Highlight of a pair of paren 4":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight = initHighlight($status.bufStatus[0].buffer, status.bufStatus[0].language)

  status.bufStatus[0].buffer = initGapBuffer(@[ru"(", ru")"])
  status.update

  status.bufStatus[0].keyDown(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
  status.changeMode(Mode.insert)
  status.bufStatus[0].keyEnter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoIndent)

  status.update

test "Highlight of a pair of paren 5":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.resize(100, 100)
  status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight = initHighlight($status.bufStatus[0].buffer, status.bufStatus[0].language)

  status.bufStatus[0].buffer = initGapBuffer(@[ru"a", ru"a)"])
  status.resize(100, 100)

  status.bufStatus[0].keyDown(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
  status.update

test "Auto delete paren 1":
  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"()"])
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"()"])
    status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"")

test "Auto delete paren 2":
  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(())"])
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"()")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(())"])
    status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"()")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(())"])
    for i in 0 ..< 2: status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"()")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(())"])
    for i in 0 ..< 3: status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"()")

test "Auto delete paren 3":
  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(()"])
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"()")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(()"])
    status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"(")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(()"])
    for i in 0 ..< 2: status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"(")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"())"])
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru")")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"())"])
    status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru")")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"())"])
    for i in 0 ..< 3: status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"()")

test "Auto delete paren 4":
  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(", ru")"])
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"" and status.bufStatus[0].buffer[1] == ru"")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(", ru")"])
    status.bufStatus[0].keyDown(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].deleteCurrentCharacter(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"" and status.bufStatus[0].buffer[1] == ru"")

test "Auto delete paren 5":
  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"()"])
    status.changeMode(Mode.insert)
    status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].keyBackspace(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"()"])
    status.changeMode(Mode.insert)
    for i in 0 ..< 2: status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].keyBackspace(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"")

test "Auto delete paren 6":
  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(a(a))"])
    status.changeMode(Mode.insert)
    for i in 0 ..< 5: status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].keyBackspace(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"(aa)")

  block:
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"(a(a))"])
    status.changeMode(Mode.insert)
    for i in 0 ..< 6: status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
    status.bufStatus[0].keyBackspace(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode, status.settings.autoDeleteParen)

    check(status.bufStatus[0].buffer[0] == ru"a(a)")

test "Highlight current word 1":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"test abc test"])

  status.resize(100, 100)
  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.currentWord and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[2].color == EditorColorPair.currentWord)

test "Highlight current word 2":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"test", ru"test"])

  status.resize(100, 100)
  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.currentWord and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.currentWord)

test "Highlight current word 3":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"[test]", ru"test"])

  status.resize(100, 100)
  status.bufStatus[0].keyRight(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.currentWord and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[3].color == EditorColorPair.currentWord)

test "Highlight full width space 1":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"　"])
  status.settings.highlightOtherUsesCurrentWord = false

  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.highlightFullWidthSpace)

test "Highlight full width space 2":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"abc　"])
  status.settings.highlightOtherUsesCurrentWord = false

  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar and status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.highlightFullWidthSpace)

test "Highlight full width space 3":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"　"])
  status.settings.highlightOtherUsesCurrentWord = false

  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.highlightFullWidthSpace)

test "Highlight full width space 2":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"a　b"])
  status.settings.highlightOtherUsesCurrentWord = false

  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[0].color == EditorColorPair.defaultChar)
  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[1].color == EditorColorPair.highlightFullWidthSpace)
  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.highlight[2].color == EditorColorPair.defaultChar)

test "Write tab line":
  var status = initEditorStatus()
  status.addNewBuffer("test.txt")

  status.resize(100, 100)

  check(status.tabWindow.width == 100)

test "Close window":
  var status = initEditorStatus()
  status.addNewBuffer("")
  status.resize(100, 100)
  status.verticalSplitWindow
  status.closeWindow(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)

test "Close window 2":
  var status = initEditorStatus()
  status.addNewBuffer("")

  status.resize(100, 100)
  status.update

  status.horizontalSplitWindow
  status.resize(100, 100)
  status.update

  status.closeWindow(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
  status.resize(100, 100)
  status.update

  let windowNodeList = status.workSpace[status.currentWorkSpaceIndex].mainWindowNode.getAllWindowNode

  check(windowNodeList.len == 1)

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.h == 98)
  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.w == 100)

test "Close window 3":
  var status = initEditorStatus()
  status.addNewBuffer("")

  status.resize(100, 100)
  status.update

  status.verticalSplitWindow
  status.resize(100, 100)
  status.update

  status.horizontalSplitWindow
  status.resize(100, 100)
  status.update

  status.closeWindow(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
  status.resize(100, 100)
  status.update

  let windowNodeList = status.workSpace[status.currentWorkSpaceIndex].mainWindowNode.getAllWindowNode

  check(windowNodeList.len == 2)

  for n in windowNodeList:
    check(n.w == 50)
    check(n.h == 98)

test "Close window 4":
  var status = initEditorStatus()
  status.addNewBuffer("")

  status.resize(100, 100)
  status.update

  status.horizontalSplitWindow
  status.resize(100, 100)
  status.update

  status.verticalSplitWindow
  status.resize(100, 100)
  status.update

  status.closeWindow(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
  status.resize(100, 100)
  status.update

  let windowNodeList = status.workSpace[status.currentWorkSpaceIndex].mainWindowNode.getAllWindowNode

  check(windowNodeList.len == 2)

  check(windowNodeList[0].w == 100)
  check(windowNodeList[0].h == 49)

  check(windowNodeList[1].w == 100)
  check(windowNodeList[1].h == 49)

test "Close window 5":
  var status = initEditorStatus()
  status.addNewBuffer("test.nim")
  status.bufStatus[0].buffer = initGapBuffer(@[ru"echo 'a'"])

  status.resize(100, 100)
  status.update

  status.verticalSplitWindow
  status.resize(100, 100)
  status.update

  status.moveCurrentMainWindow(1)
  status.addNewBuffer("test2.nim")
  status.bufStatus[1].buffer = initGapBuffer(@[ru"proc a() = discard"])
  status.changeCurrentBuffer(1)
  status.resize(100, 100)
  status.update

  status.closeWindow(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode)
  status.resize(100, 100)
  status.update

  check(status.workSpace[status.currentWorkSpaceIndex].currentMainWindowNode.bufferIndex == 0)

test "Create work space":
  var status = initEditorStatus()
  status.addNewBuffer("")

  status.resize(100, 100)
  status.update

  status.createWrokSpace

  check(status.workspace.len == 2)
  check(status.currentWorkSpaceIndex == 1)

test "Change work space":
  var status = initEditorStatus()
  status.addNewBuffer("")

  status.resize(100, 100)
  status.update

  status.createWrokSpace

  status.changeCurrentWorkSpace(1)
  check(status.currentWorkSpaceIndex == 0)

test "Delete work space":
  var status = initEditorStatus()
  status.addNewBuffer("")

  status.resize(100, 100)
  status.update

  status.createWrokSpace

  status.deleteWorkSpace(1)

  check(status.workSpace.len == 1)

# Fix #611
test "Change current buffer":
  var status = initEditorStatus()

  status.addNewBuffer("")
  status.bufStatus[0].filename =  ru"test"
  status.bufStatus[0].buffer =  initGapBuffer(@[ru"", ru"abc"])

  status.resize(100, 100)
  status.update

  let
    currentLine = status.bufStatus[0].buffer.high
    currentColumn = status.bufStatus[0].buffer[currentLine].high
  status.workspace[status.currentWorkSpaceIndex].currentMainWindowNode.currentLine = currentLine
  status.workspace[status.currentWorkSpaceIndex].currentMainWindowNode.currentColumn = currentColumn

  status.addNewBuffer("")
  status.bufStatus[0].filename =  ru"test2"
  status.bufStatus[0].buffer =  initGapBuffer(@[ru""])

  status.changeCurrentBuffer(1)

  status.resize(100, 100)
  status.update
