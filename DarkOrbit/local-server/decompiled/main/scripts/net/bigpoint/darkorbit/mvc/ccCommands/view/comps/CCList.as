package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
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
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCAttributeModule;
   import net.bigpoint.darkorbit.com.module.CCListRangeModule;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.KeyboardNotifications;
   import org.as3commons.lang.StringUtils;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.skins.spark.TextInputSkin;
   
   use namespace mx_internal;
   
   public class CCList extends CCAbstractComponent implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SEARCH_CONST:String = "Search...";
      
      public var _CCList_Label1:Label;
      
      private var _1488046559ddGroup:HGroup;
      
      private var _100358090input:TextInput;
      
      private var _3322014list:CCDropDownList;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _dataWrapper:VectorCollection;
      
      private var _tmpVector:Vector.<CCValueModule>;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCList()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._dataWrapper = new VectorCollection();
         this._tmpVector = new Vector.<CCValueModule>(0);
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._CCList_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCListWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCList[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this._CCList_HGroup1_i();
         this.addEventListener("creationComplete",this.___CCList_CCAbstractComponent1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCList._watcherSetupUtil = param1;
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
      
      override public function set data(param1:Object) : void
      {
         group.addElement(this.ddGroup);
         var _loc2_:Vector.<CCValueModule> = ((param1 as CCAttributeModule).range as CCListRangeModule).valueList;
         _loc2_.sort(this.sortBehavior);
         super.data = param1;
         this._dataWrapper.source = (_data.range as CCListRangeModule).valueList;
      }
      
      private function sortBehavior(param1:CCValueModule, param2:CCValueModule) : int
      {
         return StringUtils.compareTo(CCModuleTranslater.moduleToString(param1),CCModuleTranslater.moduleToString(param2));
      }
      
      override public function get currentData() : CCValueModule
      {
         return this.list.selectedItem as CCValueModule;
      }
      
      private function onTypedCharacter(param1:KeyboardEvent) : void
      {
         var searchArray:Vector.<CCValueModule> = null;
         var evt:KeyboardEvent = param1;
         if(evt.keyCode == Keyboard.ENTER)
         {
            this.input.text = this.currentData ? CCModuleTranslater.moduleToString(this.currentData) : this.input.text;
            this.list.selectedIndex = 0;
            this.list.closeDropDown(true);
            return;
         }
         if(this.input.text.length > 0 && this.input.text != SEARCH_CONST)
         {
            searchArray = this.indexOf((_data.range as CCListRangeModule).valueList,function(param1:CCValueModule, ... rest):Boolean
            {
               return CCModuleTranslater.filter(input.text,param1);
            });
            if(searchArray.length != 0)
            {
               this._dataWrapper.source = searchArray;
               (this.input.skin as TextInputSkin).setStyle("color",0);
            }
            else
            {
               (this.input.skin as TextInputSkin).setStyle("color",16711680);
            }
            this.list.selectedIndex = 0;
            this.list.openDropDown();
         }
         else
         {
            this.input.text = "";
            this._dataWrapper.source = (_data.range as CCListRangeModule).valueList;
            (this.input.skin as TextInputSkin).setStyle("color",0);
            this.list.selectedIndex = 0;
         }
      }
      
      private function indexOf(param1:Vector.<CCValueModule>, param2:Function) : Vector.<CCValueModule>
      {
         this._tmpVector.length = 0;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param2(param1[_loc4_]))
            {
               this._tmpVector.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return this._tmpVector;
      }
      
      private function handleCreationComplete() : void
      {
         this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onTypedCharacter);
         this.input.addEventListener(FocusEvent.FOCUS_IN,function(param1:FocusEvent):void
         {
            input.selectAll();
            GameFacade.getInstance().sendNotification(KeyboardNotifications.LOCK_KEYBOARD);
         });
         this.input.addEventListener(FocusEvent.FOCUS_OUT,function(param1:FocusEvent):void
         {
            if(input.text == "")
            {
               input.text = SEARCH_CONST;
            }
            GameFacade.getInstance().sendNotification(KeyboardNotifications.UNLOCK_KEYBOARD);
         });
      }
      
      private function _CCList_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._CCList_Label1_i(),this._CCList_TextInput1_i(),this._CCList_CCDropDownList1_i()];
         _loc1_.id = "ddGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ddGroup = _loc1_;
         BindingManager.executeBindings(this,"ddGroup",this.ddGroup);
         return _loc1_;
      }
      
      private function _CCList_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.id = "_CCList_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCList_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_CCList_Label1",this._CCList_Label1);
         return _loc1_;
      }
      
      private function _CCList_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.percentWidth = 100;
         _loc1_.id = "input";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.input = _loc1_;
         BindingManager.executeBindings(this,"input",this.input);
         return _loc1_;
      }
      
      private function _CCList_CCDropDownList1_i() : CCDropDownList
      {
         var _loc1_:CCDropDownList = new CCDropDownList();
         _loc1_.selectedIndex = 0;
         _loc1_.useVirtualLayout = true;
         _loc1_.percentWidth = 100;
         _loc1_.id = "list";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.list = _loc1_;
         BindingManager.executeBindings(this,"list",this.list);
         return _loc1_;
      }
      
      public function ___CCList_CCAbstractComponent1_creationComplete(param1:FlexEvent) : void
      {
         this.handleCreationComplete();
      }
      
      private function _CCList_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _data.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CCList_Label1.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = SEARCH_CONST;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"input.text");
         result[2] = new Binding(this,function():IList
         {
            return _dataWrapper;
         },null,"list.dataProvider");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get ddGroup() : HGroup
      {
         return this._1488046559ddGroup;
      }
      
      public function set ddGroup(param1:HGroup) : void
      {
         var _loc2_:Object = this._1488046559ddGroup;
         if(_loc2_ !== param1)
         {
            this._1488046559ddGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ddGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get input() : TextInput
      {
         return this._100358090input;
      }
      
      public function set input(param1:TextInput) : void
      {
         var _loc2_:Object = this._100358090input;
         if(_loc2_ !== param1)
         {
            this._100358090input = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"input",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get list() : CCDropDownList
      {
         return this._3322014list;
      }
      
      public function set list(param1:CCDropDownList) : void
      {
         var _loc2_:Object = this._3322014list;
         if(_loc2_ !== param1)
         {
            this._3322014list = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"list",_loc2_,param1));
            }
         }
      }
   }
}

