package net.bigpoint.darkorbit.mvc.soundTool.view
{
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
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.audio.AudioMultiPattern;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import spark.components.Button;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.TextArea;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class SoundConfigWindow extends DOWindow implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public static const LOAD_ALL_SOUNDS:String = "LOAD_ALL_SOUNDS";
      
      public static const TEST_ALL_SOUNDS:String = "TEST_ALL_SOUNDS";
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      public var _SoundConfigWindow_List1:List;
      
      public var _SoundConfigWindow_List2:List;
      
      private var _1005512447output:TextArea;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1669543858patternList:ArrayCollection;
      
      private var _1616619753musicPatternList:ArrayCollection;
      
      private var fileReference:FileReference;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SoundConfigWindow()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._1669543858patternList = new ArrayCollection();
         this._1616619753musicPatternList = new ArrayCollection();
         this.fileReference = new FileReference();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._SoundConfigWindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_soundTool_view_SoundConfigWindowWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SoundConfigWindow[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 600;
         this.height = 800;
         this.title = "DEBUG SOUND CONFIG";
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SoundConfigWindow_Array1_c);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SoundConfigWindow._watcherSetupUtil = param1;
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
      
      public function setData(param1:Array) : void
      {
         this.patternList.source = param1;
      }
      
      private function save() : void
      {
         var _loc1_:XML = this.getAudioPatternAsXML();
         this.fileReference.save(_loc1_);
      }
      
      private function getAudioPatternAsXML() : XML
      {
         var _loc2_:AudioMultiPattern = null;
         var _loc3_:XML = null;
         var _loc4_:AudioMultiPattern = null;
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc9_:XML = null;
         var _loc10_:XML = null;
         var _loc1_:XML = <sounds></sounds>;
         for each(_loc2_ in this.patternList.source)
         {
            if(_loc2_)
            {
               _loc6_ = <sound></sound>;
               _loc6_.@id = _loc2_.getPatternID();
               _loc6_.@volume = _loc2_.getVolume();
               _loc6_.@soundbank = _loc2_.soundbank;
               _loc7_ = <reskeys></reskeys>;
               for each(_loc8_ in _loc2_.resKeyList)
               {
                  _loc9_ = <reskey></reskey>;
                  _loc9_.@resKey = _loc8_;
                  _loc7_.appendChild(_loc9_);
               }
               _loc6_.appendChild(_loc7_);
               _loc1_.appendChild(_loc6_);
            }
         }
         _loc3_ = <music></music>;
         for each(_loc4_ in this.musicPatternList.source)
         {
            if(_loc4_)
            {
               _loc10_ = <track></track>;
               _loc10_.@id = _loc4_.getPatternID();
               _loc10_.@resKey = _loc4_.getResKey();
               _loc10_.@volume = _loc4_.getVolume();
               _loc3_.appendChild(_loc10_);
            }
         }
         _loc5_ = <patterns></patterns>;
         _loc5_.appendChild(_loc3_);
         _loc5_.appendChild(_loc1_);
         return _loc5_;
      }
      
      private function load() : void
      {
         this.fileReference.addEventListener(Event.SELECT,this.loadFileSelected);
         this.fileReference.browse();
      }
      
      private function loadFileSelected(param1:Event) : void
      {
         this.fileReference.removeEventListener(Event.SELECT,this.loadFileSelected);
         this.fileReference.addEventListener(Event.COMPLETE,this.fileLoaded);
         this.fileReference.load();
      }
      
      private function fileLoaded(param1:Event) : void
      {
         this.fileReference.removeEventListener(Event.COMPLETE,this.fileLoaded);
         var _loc2_:XML = new XML(this.fileReference.data.readUTFBytes(this.fileReference.data.length));
         var _loc3_:XML = <game></game>;
         _loc3_.appendChild(_loc2_);
         PatternManager.parseSoundPatterns(_loc3_);
         PatternManager.parseMusicPatterns(_loc3_);
         this.update();
      }
      
      public function setMusicData(param1:Array) : void
      {
         this.musicPatternList.source = param1;
      }
      
      private function reset() : void
      {
         PatternManager.parseSoundPatterns(Main.gameXML);
         PatternManager.parseMusicPatterns(Main.gameXML);
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:Array = PatternManager.soundPatterns;
         this.setData(_loc1_);
         var _loc2_:Array = PatternManager.musicPatterns;
         this.setMusicData(_loc2_);
         AudioManager.stopMusic();
         AudioManager.loadMusic(0);
      }
      
      private function loadAllSounds() : void
      {
         dispatchEvent(new Event(LOAD_ALL_SOUNDS));
      }
      
      private function checkAllSounds() : void
      {
         dispatchEvent(new Event(TEST_ALL_SOUNDS));
      }
      
      private function _SoundConfigWindow_Array1_c() : Array
      {
         return [this._SoundConfigWindow_HGroup1_c()];
      }
      
      private function _SoundConfigWindow_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._SoundConfigWindow_VGroup1_c(),this._SoundConfigWindow_VGroup2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SoundConfigWindow_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.mxmlContent = [this._SoundConfigWindow_Button1_c(),this._SoundConfigWindow_Button2_c(),this._SoundConfigWindow_Button3_c(),this._SoundConfigWindow_Button4_c(),this._SoundConfigWindow_Button5_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SoundConfigWindow_Button1_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "SAVE";
         _loc1_.addEventListener("click",this.___SoundConfigWindow_Button1_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___SoundConfigWindow_Button1_click(param1:MouseEvent) : void
      {
         this.save();
      }
      
      private function _SoundConfigWindow_Button2_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "LOAD";
         _loc1_.addEventListener("click",this.___SoundConfigWindow_Button2_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___SoundConfigWindow_Button2_click(param1:MouseEvent) : void
      {
         this.load();
      }
      
      private function _SoundConfigWindow_Button3_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "RESET";
         _loc1_.addEventListener("click",this.___SoundConfigWindow_Button3_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___SoundConfigWindow_Button3_click(param1:MouseEvent) : void
      {
         this.reset();
      }
      
      private function _SoundConfigWindow_Button4_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "LOAD ALL SOUNDS";
         _loc1_.addEventListener("click",this.___SoundConfigWindow_Button4_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___SoundConfigWindow_Button4_click(param1:MouseEvent) : void
      {
         this.loadAllSounds();
      }
      
      private function _SoundConfigWindow_Button5_c() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "CHECK ALL SOUNDS";
         _loc1_.addEventListener("click",this.___SoundConfigWindow_Button5_click);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___SoundConfigWindow_Button5_click(param1:MouseEvent) : void
      {
         this.checkAllSounds();
      }
      
      private function _SoundConfigWindow_VGroup2_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._SoundConfigWindow_Label1_c(),this._SoundConfigWindow_List1_i(),this._SoundConfigWindow_Label2_c(),this._SoundConfigWindow_List2_i(),this._SoundConfigWindow_TextArea1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SoundConfigWindow_Label1_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "EFFECTS";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SoundConfigWindow_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.itemRenderer = this._SoundConfigWindow_ClassFactory1_c();
         _loc1_.id = "_SoundConfigWindow_List1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SoundConfigWindow_List1 = _loc1_;
         BindingManager.executeBindings(this,"_SoundConfigWindow_List1",this._SoundConfigWindow_List1);
         return _loc1_;
      }
      
      private function _SoundConfigWindow_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = SoundListItemRenderer;
         return _loc1_;
      }
      
      private function _SoundConfigWindow_Label2_c() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "MUSIC";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SoundConfigWindow_List2_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.percentHeight = 15;
         _loc1_.percentWidth = 100;
         _loc1_.itemRenderer = this._SoundConfigWindow_ClassFactory2_c();
         _loc1_.id = "_SoundConfigWindow_List2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SoundConfigWindow_List2 = _loc1_;
         BindingManager.executeBindings(this,"_SoundConfigWindow_List2",this._SoundConfigWindow_List2);
         return _loc1_;
      }
      
      private function _SoundConfigWindow_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = MusicListItemRenderer;
         return _loc1_;
      }
      
      private function _SoundConfigWindow_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.percentWidth = 100;
         _loc1_.id = "output";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.output = _loc1_;
         BindingManager.executeBindings(this,"output",this.output);
         return _loc1_;
      }
      
      private function _SoundConfigWindow_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():IList
         {
            return patternList;
         },null,"_SoundConfigWindow_List1.dataProvider");
         result[1] = new Binding(this,function():IList
         {
            return musicPatternList;
         },null,"_SoundConfigWindow_List2.dataProvider");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get output() : TextArea
      {
         return this._1005512447output;
      }
      
      public function set output(param1:TextArea) : void
      {
         var _loc2_:Object = this._1005512447output;
         if(_loc2_ !== param1)
         {
            this._1005512447output = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"output",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get patternList() : ArrayCollection
      {
         return this._1669543858patternList;
      }
      
      private function set patternList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1669543858patternList;
         if(_loc2_ !== param1)
         {
            this._1669543858patternList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"patternList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get musicPatternList() : ArrayCollection
      {
         return this._1616619753musicPatternList;
      }
      
      private function set musicPatternList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1616619753musicPatternList;
         if(_loc2_ !== param1)
         {
            this._1616619753musicPatternList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"musicPatternList",_loc2_,param1));
            }
         }
      }
   }
}

