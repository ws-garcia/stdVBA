Attribute VB_Name = "stdWindowTests"
'@class stdWindow
'@description A class for managing windows
'@example:
'   With stdWindow.CreateFromDesktop()
'     Dim notepad as stdWindow
'     set notepad = .Find(stdLambda.Create("$1.Caption = ""Untitled - Notepad"" and $1.ProcessName = ""notepad.exe"""))
'     nodepad.SendKeysInput("hello world")
'     nodepad.SendKeysInput("^a")
'     nodepad.SendKeysInput("^c")
'     Debug.Print stdClipboard.Text
'   End With
'
'   'Make a userform resizable
'   MyForm.show
'   stdWindow.CreateFromIUnknown(MyForm).resizable = true
'
'Spec:
' CONSTRUCTORS
'   [ ] Create(sClassName,sCaption,dwStyle, x, y, Width, Height, hWndParent, hMenu, hInstance, lpParam) as stdWindow
'   [ ] TODO:CreateStaticPopup(x, y, Width, Height, BorderWidth, BorderColor) as stdWindow
'   [X] CreateFromDesktop() as stdWindow
'   [X] CreateFromHwnd(hwnd) as stdWindow
'   [X] CreateFromPoint(x, y) as stdWindow
'   [ ] CreateFromEvent() as stdWindow
'   [X] CreateFromIUnknown(obj) as stdWindow
'   [X] CreateFromContextMenu() as stdWindow    'Class == "#32768"
' STATIC METHODS
'   [?] Requires()
' INSTANCE PROPERTIES
'   [X] Get     handle() as LongPtr
'   [X] Get     hDC() as LongPtr
'   [X] Get     Exists as Boolean
'   [X] Get/Let Visible() as Boolean        
'   [X] Get/Let State() as EWndState    'Normal,Minimised,Maximised
'   [X] Get     IsFrozen() as Boolean
'   [X] Get/Let Caption() as string
'   [X] Get     Class() as string
'   [X] Get     RectClient() as Long()
'   [X] Get/Let RectWindow() as Long()
'   [X] Get/Let X() as Long
'   [X] Get/Let Y() as Long
'   [X] Get/Let Width() as Long
'   [X] Get/Let Height() as Long
'   [X] Get     ProcessID() as long
'   [X] Get     ProcessName() as string
'   [X] Get/Set Parent() as stdWindow
'   [X] Get     AncestralRoot() as stdWindow
'   [X] Get/Let Style() as Long
'   [X] Get/Let StyleEx() as Long
'   [X] Get/Let UserData() as LongPtr
'   [X] Get/Let WndProc() as LongPtr
'   [X] Get/Let Resizable() as Boolean
'   [X] Get     Children() as Collection
'   [X] Get     Descendents() as Collection
'   [ ] Get/Let AlwaysOnTop() as Boolean
'
' INSTANCE METHODS
'   [ ] SetHook(idHook, hook, hInstance, dwThreadID) as LongPtr
'   [X] Redraw()
'   [X] SendMessage(wMsg, wParam, lParam)
'   [X] PostMessage(wMsg, wParam, lParam)
'   [ ] TODO: SendMessageTimeout(wMsg, wParam, lParam, TimeoutMilliseconds)
'   [ ] ClickInput(x?, y?, Button?)
'   [X] ClickEvent(x?, y?, Button?, isDoubleClick?, wParam?)
'   [ ] SendKeysInput(sKeys, bRaw?, keyDelay?)
'   [X] SendKeysEvent(sKeys, bRaw?, keyDelay?)
'   [X] Show()
'   [X] Hide()
'   [X] Maximize()
'   [X] Minimize()
'   [X] Activate()
'   [X] Close()
'   [X] FindFirst(query)
'   [X] FindAll(query)
'   [ ] Screenshot()
' PROTECTED METHODS
'   [X] zProtGetNextDescendent(stack, DFS, Prev) as stdWindow

Sub testAll()
  Test.Topic "stdWindow"
  
  'Preperation
  Dim desktop As stdWindow, app As stdWindow, uf As stdWindow
  
  
  '****************
  '* CONSTRUCTORS *
  '****************
  'Test CreateFromDesktop() constructor
  Set desktop = stdWindow.CreateFromDesktop()
  Debug.Print "Desktop class", desktop.Class = "#32769"
  
  'Test CreateFromHwnd() constructor
  Set app = stdWindow.CreateFromHwnd(Application.hwnd)
  Debug.Print "stdWindow::CreateFromHwnd()", app.Class = "XLMAIN"
  
  'Test CreateFromIUnknown() constructor
  UserForm1.Show False
  Set uf = stdWindow.CreateFromIUnknown(UserForm1)
  Debug.Print "stdWindow::CreateFromIUnknown", uf.Class = "ThunderDFrame"
  
  'Test CreateFromPoint() ?
  
  'Test CreateFromEvent()

  'TODO: Test CreateFromContextMenu()
  
  
  '***********************
  '* INSTANCE PROPERTIES *
  '***********************
  Debug.Print "stdWindow#handle", app.handle <> 0
  Debug.Print "stdWindow#hDC", app.hDC <> 0
  Debug.Print "stdWindow#Exists", app.Exists
  Debug.Print "stdWindow#Visible", desktop.Visible
  uf.visible = false
  Debug.Print "stdWindow#Visible - set false", not uf.visible
  uf.visible = true
  Debug.Print "stdWindow#Visible - set true", uf.visible

  Debug.Print "stdWindow#state norm", desktop.state = normal
  Application.WindowState = xlMinimized
  Debug.Print "stdWindow#state min", app.state = minimised
  Application.WindowState = xlMaximized
  Debug.Print "stdWindow#state max", app.state = maximised
  'TODO: Test isFrozen == true
  Debug.Print "stdWindow#IsFrozen", Not desktop.IsFrozen
  Debug.Print "stdWindow#Caption [Get]", app.Caption Like ThisWorkbook.windows(1).Caption & "*"
  uf.Caption = "Test"
  Debug.Print "stdWindow#Caption [Let]", uf.Caption = "Test"
  uf.Caption = UserForm1.name
  
  Debug.Print "stdWindow#class", app.Class = "XLMAIN"
  'TODO: RectClient
  'TODO: RectWindow [Get]
  'TODO: RectWindow [Set]
  
  'Position/Size Get
  Debug.Print "x", uf.x > 0
  Debug.Print "y", uf.y > 0
  Debug.Print "width", uf.width > 0
  Debug.Print "height", uf.height > 0
  
  'Position/Size Let
  uf.x=10
  uf.y=10
  uf.width = 100
  uf.height = 100
  Debug.Print "x [Let]", uf.x = 10
  Debug.Print "y [Let]", uf.y = 10
  Debug.Print "width [Let]", uf.width = 100
  Debug.Print "height [Let]", uf.height = 100

  
  Debug.Print "ProcessID 1", uf.processID = app.processId
  Debug.Print "ProcessID 2", uf.processID > 0 
  Debug.Print "ProcessName", uf.ProcessName like "*VBE7.DLL" 
  Debug.Print "stdWindow#parent - Desktop no parent", desktop.Parent Is Nothing
  Debug.Print "stdWindow#parent - app has desktop as parent 1", Not app.Parent Is Nothing
  If Not app.Parent Is Nothing Then Debug.Print "stdWindow#parent - app has desktop as parent 2", app.Parent.Class = "#32769"
  'TODO: Parent [Set]
  'TODO: AncestralRoot
  Debug.Print "stdWindow#Style", Hex(desktop.Style) = "96000000"
  'TODO: Test set Style
  Debug.Print "stdWindow#StyleEx", desktop.StyleEx = 0
  'TODO: Test set StyleEx
  Debug.Print "stdWindow#UserData - Desktop = 0", desktop.UserData = 0
  Debug.Print "stdWindow#UserData - UF = 0", uf.UserData = 0
  'TODO: Test set UserData
  Debug.Print "stdWindow#WndProc", uf.WndProc <> 0
  'TODO: Test WndProc set
  Debug.Print "stdWindow#Resizable 1", Not uf.Resizable
  Debug.Print "stdWindow#Resizable 2", app.Resizable
  'TODO Resizable [Set]
  Debug.Print "stdWindow#children 1", app.Children.count > 0
  'TODO: Descendents
  
  '********************
  '* INSTANCE METHODS *
  '********************
  
  

  unload UserForm1
End Sub


