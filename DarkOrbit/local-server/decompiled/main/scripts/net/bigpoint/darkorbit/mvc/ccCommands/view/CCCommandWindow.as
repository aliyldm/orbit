package net.bigpoint.darkorbit.mvc.ccCommands.view
{
   import com.bealearts.collection.VectorCollection;
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCInitCommand;
   import net.bigpoint.darkorbit.com.module.CCommandModule;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCHistoryEntry;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.AccordionList;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCClientServerCommunicationItemRenderer;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCEvent;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.history.CCHistoryRenderer;
   import net.bigpoint.darkorbit.net.netty.record.RecordVO;
   import org.as3commons.lang.StringUtils;
   import spark.components.Button;
   import spark.components.CheckBox;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.Panel;
   import spark.components.TextArea;
   import spark.components.TextInput;
   import spark.components.TitleWindow;
   import spark.components.VGroup;
   import spark.events.TextOperationEvent;
   import spark.skins.spark.TitleWindowSkin;
   
   use namespace mx_internal;
   
   public class CCCommandWindow extends TitleWindow implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const HISTORY_CLOSED:String = "History >>";
      
      private static const HISTORY_OPENED:String = "<< History";
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "titleDisplay":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false
      };
      
      public var _CCCommandWindow_AccordionList1:AccordionList;
      
      public var _CCCommandWindow_AccordionList2:AccordionList;
      
      private var _200693729checkBox_ShowCommands:CheckBox;
      
      private var _409971997checkBox_ShowRequests:CheckBox;
      
      private var _94746189clear:Button;
      
      private var _567880364clientServerCommandsList:List;
      
      private var _910424270filterInput:TextInput;
      
      private var _665358580histButton:Button;
      
      private var _1696358402histPanel:Panel;
      
      private var _1198359910serverCommandDetails:TextArea;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _512017433_commands:VectorCollection;
      
      private var _1009808555_history:VectorCollection;
      
      private var _635376497_servercommandsAndRequests:VectorCollection;
      
      private var _minimized:Boolean;
      
      private var _historyMinimized:Boolean = true;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCCommandWindow()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._512017433_commands = new VectorCollection();
         this._1009808555_history = new VectorCollection();
         this._635376497_servercommandsAndRequests = new VectorCollection();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._CCCommandWindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_CCCommandWindowWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCCommandWindow[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.x = 20;
         this.height = 500;
         this.title = "Build a tool and you are cool";
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._CCCommandWindow_Array1_c);
         this.addEventListener("addedToStage",this.___CCCommandWindow_TitleWindow1_addedToStage);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCCommandWindow._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function set data(param1:CCInitCommand) : void
      {
         var _loc2_:TitleWindowSkin = null;
         param1.commands.sort(this.sortModules);
         _loc2_ = skin as TitleWindowSkin;
         _loc2_.topGroup.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         _loc2_.topGroup.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         _loc2_.topGroup.addEventListener(MouseEvent.RIGHT_CLICK,this.close);
         closeButton.addEventListener(MouseEvent.CLICK,this.close);
         this._commands.source = param1.commands;
         this.clear.addEventListener(MouseEvent.CLICK,this.handleClearClicked);
         this.updateHeight();
      }
      
      private function sortModules(param1:CCommandModule, param2:CCommandModule) : int
      {
         return StringUtils.compareToIgnoreCase(param1.name,param2.name);
      }
      
      private function handleClearClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new CCEvent(CCEvent.CLEAR_HISTORY));
      }
      
      public function set history(param1:Vector.<CCHistoryEntry>) : void
      {
         this._history.source = param1;
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         stopDrag();
         this.updateHeight();
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         startDrag();
      }
      
      private function close(param1:MouseEvent) : void
      {
         this._minimized = !this._minimized;
         this.updateHeight();
      }
      
      private function updateHeight() : void
      {
         if(this._minimized)
         {
            height = 30;
         }
         else
         {
            height = stage.stageHeight - y - 20;
         }
         contentGroup.visible = !this._minimized;
      }
      
      private function handleAddedToStage() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this._servercommandsAndRequests.filterFunction = this.filterList;
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc5_:CCHistoryEntry = null;
         var _loc2_:Vector.<CCHistoryEntry> = this._history.source as Vector.<CCHistoryEntry>;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.key == param1.keyCode)
            {
               dispatchEvent(new CCEvent(CCEvent.ACTIVATE,_loc5_.request));
            }
            _loc4_++;
         }
      }
      
      private function toggleHistory() : void
      {
         this._historyMinimized = !this._historyMinimized;
         this.histPanel.visible = !this._historyMinimized;
         this.histButton.label = this._historyMinimized ? HISTORY_CLOSED : HISTORY_OPENED;
         if(this._historyMinimized)
         {
            this.histPanel.width = 0;
         }
         else
         {
            this.histPanel.percentWidth = 100;
         }
      }
      
      private function handleItemClick() : void
      {
         var _loc2_:String = null;
         var _loc1_:RecordVO = this.clientServerCommandsList.selectedItem;
         if(_loc1_)
         {
            this.serverCommandDetails.content = "";
            if(_loc1_.params == null || _loc1_.params.length == 0)
            {
               this.serverCommandDetails.content = "[No parameters specified.]";
            }
            else
            {
               _loc2_ = _loc1_.params;
               this.serverCommandDetails.content = _loc2_ + "\n";
            }
         }
      }
      
      public function addRecordDataToServerComandListView(param1:RecordVO) : void
      {
         this._servercommandsAndRequests.addItem(param1);
         this.autoScrollToBottom();
      }
      
      public function addRecordDataToRequestListView(param1:RecordVO) : void
      {
         this._servercommandsAndRequests.addItem(param1);
         this.autoScrollToBottom();
      }
      
      private function autoScrollToBottom() : void
      {
      }
      
      protected function clearFilterInputField(param1:MouseEvent) : void
      {
         this.filterInput.text = "";
         this._servercommandsAndRequests.refresh();
      }
      
      protected function changeFilterInputHandler(param1:MouseEvent) : void
      {
         this._servercommandsAndRequests.refresh();
      }
      
      private function filterList(param1:RecordVO) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1.isRequest && !this.checkBox_ShowRequests.selected)
         {
            return false;
         }
         if(param1.isCommand && !this.checkBox_ShowCommands.selected)
         {
            return false;
         }
         if(this.filterInput.text != null)
         {
            if(this.filterInput.text.length >= 2)
            {
               _loc2_ = this.filterInput.text.toLowerCase();
               _loc3_ = param1.clazzname.toLocaleLowerCase();
               if(_loc3_.indexOf(_loc2_) >= 0)
               {
                  return true;
               }
               return false;
            }
         }
         return true;
      }
      
      private function _CCCommandWindow_Array1_c() : Array
      {
         return [this._CCCommandWindow_Button1_i(),this._CCCommandWindow_HGroup1_c()];
      }
      
      private function _CCCommandWindow_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.right = 0;
         _loc1_.addEventListener("click",this.__histButton_click);
         _loc1_.id = "histButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.histButton = _loc1_;
         BindingManager.executeBindings(this,"histButton",this.histButton);
         return _loc1_;
      }
      
      public function __histButton_click(param1:MouseEvent) : void
      {
         this.toggleHistory();
      }
      
      private function _CCCommandWindow_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.top = 20;
         _loc1_.mxmlContent = [this._CCCommandWindow_VGroup1_c(),this._CCCommandWindow_Panel1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._CCCommandWindow_AccordionList1_i(),this._CCCommandWindow_VGroup2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_AccordionList1_i() : AccordionList
      {
         var _loc1_:AccordionList = new AccordionList();
         _loc1_.itemRenderer = this._CCCommandWindow_ClassFactory1_c();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.selectedIndex = 0;
         _loc1_.id = "_CCCommandWindow_AccordionList1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCCommandWindow_AccordionList1 = _loc1_;
         BindingManager.executeBindings(this,"_CCCommandWindow_AccordionList1",this._CCCommandWindow_AccordionList1);
         return _loc1_;
      }
      
      private function _CCCommandWindow_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = CCCommandRenderer;
         return _loc1_;
      }
      
      private function _CCCommandWindow_VGroup2_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._CCCommandWindow_List1_i(),this._CCCommandWindow_HGroup2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.itemRenderer = this._CCCommandWindow_ClassFactory2_c();
         _loc1_.useVirtualLayout = true;
         _loc1_.height = 200;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("alternatingItemColors",[15658734,14540253]);
         _loc1_.addEventListener("click",this.__clientServerCommandsList_click);
         _loc1_.id = "clientServerCommandsList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.clientServerCommandsList = _loc1_;
         BindingManager.executeBindings(this,"clientServerCommandsList",this.clientServerCommandsList);
         return _loc1_;
      }
      
      private function _CCCommandWindow_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = CCClientServerCommunicationItemRenderer;
         return _loc1_;
      }
      
      public function __clientServerCommandsList_click(param1:MouseEvent) : void
      {
         this.handleItemClick();
      }
      
      private function _CCCommandWindow_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.height = 40;
         _loc1_.mxmlContent = [this._CCCommandWindow_TextArea1_i(),this._CCCommandWindow_VGroup3_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.percentWidth = 60;
         _loc1_.height = 38;
         _loc1_.x = 2;
         _loc1_.setStyle("fontSize",9);
         _loc1_.id = "serverCommandDetails";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.serverCommandDetails = _loc1_;
         BindingManager.executeBindings(this,"serverCommandDetails",this.serverCommandDetails);
         return _loc1_;
      }
      
      private function _CCCommandWindow_VGroup3_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.mxmlContent = [this._CCCommandWindow_HGroup3_c(),this._CCCommandWindow_HGroup4_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_HGroup3_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._CCCommandWindow_CheckBox1_i(),this._CCCommandWindow_CheckBox2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_CheckBox1_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.label = "Show Requests";
         _loc1_.selected = true;
         _loc1_.setStyle("fontSize",8);
         _loc1_.addEventListener("change",this.__checkBox_ShowRequests_change);
         _loc1_.id = "checkBox_ShowRequests";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.checkBox_ShowRequests = _loc1_;
         BindingManager.executeBindings(this,"checkBox_ShowRequests",this.checkBox_ShowRequests);
         return _loc1_;
      }
      
      public function __checkBox_ShowRequests_change(param1:Event) : void
      {
         this.changeFilterInputHandler(null);
      }
      
      private function _CCCommandWindow_CheckBox2_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.label = "Show Commands";
         _loc1_.selected = true;
         _loc1_.setStyle("fontSize",8);
         _loc1_.addEventListener("change",this.__checkBox_ShowCommands_change);
         _loc1_.id = "checkBox_ShowCommands";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.checkBox_ShowCommands = _loc1_;
         BindingManager.executeBindings(this,"checkBox_ShowCommands",this.checkBox_ShowCommands);
         return _loc1_;
      }
      
      public function __checkBox_ShowCommands_change(param1:Event) : void
      {
         this.changeFilterInputHandler(null);
      }
      
      private function _CCCommandWindow_HGroup4_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._CCCommandWindow_Label1_c(),this._CCCommandWindow_TextInput1_i(),this._CCCommandWindow_Button2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_Label1_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Filter:";
         _loc1_.setStyle("fontSize",8);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCommandWindow_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.height = 18;
         _loc1_.addEventListener("change",this.__filterInput_change);
         _loc1_.id = "filterInput";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.filterInput = _loc1_;
         BindingManager.executeBindings(this,"filterInput",this.filterInput);
         return _loc1_;
      }
      
      public function __filterInput_change(param1:TextOperationEvent) : void
      {
         this.changeFilterInputHandler(null);
      }
      
      private function _CCCommandWindow_Button2_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.width = 30;
         _loc1_.height = 20;
         _loc1_.label = "X";
         _loc1_.addEventListener("click",this.___CCCommandWindow_Button2_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___CCCommandWindow_Button2_click(param1:MouseEvent) : void
      {
         this.clearFilterInputField(null);
      }
      
      private function _CCCommandWindow_Panel1_i() : Panel
      {
         var _loc1_:Panel = new Panel();
         _loc1_.title = "-=[HISTORY]=-";
         _loc1_.width = 0;
         _loc1_.visible = false;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._CCCommandWindow_Array10_c);
         _loc1_.id = "histPanel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.histPanel = _loc1_;
         BindingManager.executeBindings(this,"histPanel",this.histPanel);
         return _loc1_;
      }
      
      private function _CCCommandWindow_Array10_c() : Array
      {
         return [this._CCCommandWindow_Button3_i(),this._CCCommandWindow_AccordionList2_i()];
      }
      
      private function _CCCommandWindow_Button3_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "clear History";
         _loc1_.id = "clear";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.clear = _loc1_;
         BindingManager.executeBindings(this,"clear",this.clear);
         return _loc1_;
      }
      
      private function _CCCommandWindow_AccordionList2_i() : AccordionList
      {
         var _loc1_:AccordionList = new AccordionList();
         _loc1_.top = 25;
         _loc1_.itemRenderer = this._CCCommandWindow_ClassFactory3_c();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.id = "_CCCommandWindow_AccordionList2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCCommandWindow_AccordionList2 = _loc1_;
         BindingManager.executeBindings(this,"_CCCommandWindow_AccordionList2",this._CCCommandWindow_AccordionList2);
         return _loc1_;
      }
      
      private function _CCCommandWindow_ClassFactory3_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = CCHistoryRenderer;
         return _loc1_;
      }
      
      public function ___CCCommandWindow_TitleWindow1_addedToStage(param1:Event) : void
      {
         this.handleAddedToStage();
      }
      
      private function _CCCommandWindow_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = HISTORY_CLOSED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"histButton.label");
         result[1] = new Binding(this,function():IList
         {
            return _commands;
         },null,"_CCCommandWindow_AccordionList1.dataProvider");
         result[2] = new Binding(this,function():IList
         {
            return _servercommandsAndRequests;
         },null,"clientServerCommandsList.dataProvider");
         result[3] = new Binding(this,function():uint
         {
            return 9487316;
         },function(param1:uint):void
         {
            histPanel.setStyle("contentBackgroundColor",param1);
         },"histPanel.contentBackgroundColor");
         result[4] = new Binding(this,function():uint
         {
            return 9487316;
         },function(param1:uint):void
         {
            histPanel.setStyle("backgroundColor",param1);
         },"histPanel.backgroundColor");
         result[5] = new Binding(this,function():IList
         {
            return _history;
         },null,"_CCCommandWindow_AccordionList2.dataProvider");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get checkBox_ShowCommands() : CheckBox
      {
         return this._200693729checkBox_ShowCommands;
      }
      
      public function set checkBox_ShowCommands(param1:CheckBox) : void
      {
         var _loc2_:Object = this._200693729checkBox_ShowCommands;
         if(_loc2_ !== param1)
         {
            this._200693729checkBox_ShowCommands = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"checkBox_ShowCommands",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get checkBox_ShowRequests() : CheckBox
      {
         return this._409971997checkBox_ShowRequests;
      }
      
      public function set checkBox_ShowRequests(param1:CheckBox) : void
      {
         var _loc2_:Object = this._409971997checkBox_ShowRequests;
         if(_loc2_ !== param1)
         {
            this._409971997checkBox_ShowRequests = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"checkBox_ShowRequests",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clear() : Button
      {
         return this._94746189clear;
      }
      
      public function set clear(param1:Button) : void
      {
         var _loc2_:Object = this._94746189clear;
         if(_loc2_ !== param1)
         {
            this._94746189clear = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clear",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clientServerCommandsList() : List
      {
         return this._567880364clientServerCommandsList;
      }
      
      public function set clientServerCommandsList(param1:List) : void
      {
         var _loc2_:Object = this._567880364clientServerCommandsList;
         if(_loc2_ !== param1)
         {
            this._567880364clientServerCommandsList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientServerCommandsList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get filterInput() : TextInput
      {
         return this._910424270filterInput;
      }
      
      public function set filterInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._910424270filterInput;
         if(_loc2_ !== param1)
         {
            this._910424270filterInput = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filterInput",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get histButton() : Button
      {
         return this._665358580histButton;
      }
      
      public function set histButton(param1:Button) : void
      {
         var _loc2_:Object = this._665358580histButton;
         if(_loc2_ !== param1)
         {
            this._665358580histButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"histButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get histPanel() : Panel
      {
         return this._1696358402histPanel;
      }
      
      public function set histPanel(param1:Panel) : void
      {
         var _loc2_:Object = this._1696358402histPanel;
         if(_loc2_ !== param1)
         {
            this._1696358402histPanel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"histPanel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get serverCommandDetails() : TextArea
      {
         return this._1198359910serverCommandDetails;
      }
      
      public function set serverCommandDetails(param1:TextArea) : void
      {
         var _loc2_:Object = this._1198359910serverCommandDetails;
         if(_loc2_ !== param1)
         {
            this._1198359910serverCommandDetails = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"serverCommandDetails",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _commands() : VectorCollection
      {
         return this._512017433_commands;
      }
      
      private function set _commands(param1:VectorCollection) : void
      {
         var _loc2_:Object = this._512017433_commands;
         if(_loc2_ !== param1)
         {
            this._512017433_commands = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_commands",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _history() : VectorCollection
      {
         return this._1009808555_history;
      }
      
      private function set _history(param1:VectorCollection) : void
      {
         var _loc2_:Object = this._1009808555_history;
         if(_loc2_ !== param1)
         {
            this._1009808555_history = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_history",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _servercommandsAndRequests() : VectorCollection
      {
         return this._635376497_servercommandsAndRequests;
      }
      
      private function set _servercommandsAndRequests(param1:VectorCollection) : void
      {
         var _loc2_:Object = this._635376497_servercommandsAndRequests;
         if(_loc2_ !== param1)
         {
            this._635376497_servercommandsAndRequests = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_servercommandsAndRequests",_loc2_,param1));
            }
         }
      }
   }
}

