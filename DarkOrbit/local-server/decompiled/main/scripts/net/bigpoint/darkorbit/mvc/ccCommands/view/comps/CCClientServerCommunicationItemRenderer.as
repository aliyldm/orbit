package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
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
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.net.netty.record.RecordVO;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.supportClasses.ItemRenderer;
   
   use namespace mx_internal;
   
   public class CCClientServerCommunicationItemRenderer extends ItemRenderer implements IStateClient2
   {
      
      private var _991183554ICommand:Label;
      
      private var _3494ms:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _CCClientServerCommunicationItemRenderer_StylesInit_done:Boolean = false;
      
      public function CCClientServerCommunicationItemRenderer()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._CCClientServerCommunicationItemRenderer_HGroup1_c()];
         this.currentState = "in";
         states = [new State({
            "name":"in",
            "overrides":[]
         }),new State({
            "name":"out",
            "overrides":[]
         })];
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         mx_internal::_CCClientServerCommunicationItemRenderer_StylesInit();
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:RecordVO = param1 as RecordVO;
         if(_loc2_ == null)
         {
            return;
         }
         this.ms.text = _loc2_.milliseconds;
         this.ICommand.text = _loc2_.clazzname;
         if(_loc2_.isCommand)
         {
            this.ICommand.setStyle("color",8926003);
         }
         else if(_loc2_.isRequest)
         {
            this.ICommand.setStyle("color",3377203);
         }
      }
      
      private function _CCClientServerCommunicationItemRenderer_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.verticalAlign = "middle";
         _loc1_.paddingTop = 0;
         _loc1_.paddingBottom = 0;
         _loc1_.mxmlContent = [this._CCClientServerCommunicationItemRenderer_Label1_i(),this._CCClientServerCommunicationItemRenderer_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCClientServerCommunicationItemRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontSize",8);
         _loc1_.id = "ms";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ms = _loc1_;
         BindingManager.executeBindings(this,"ms",this.ms);
         return _loc1_;
      }
      
      private function _CCClientServerCommunicationItemRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontSize",10);
         _loc1_.id = "ICommand";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ICommand = _loc1_;
         BindingManager.executeBindings(this,"ICommand",this.ICommand);
         return _loc1_;
      }
      
      mx_internal function _CCClientServerCommunicationItemRenderer_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         if(mx_internal::_CCClientServerCommunicationItemRenderer_StylesInit_done)
         {
            return;
         }
         mx_internal::_CCClientServerCommunicationItemRenderer_StylesInit_done = true;
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","myFontStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         style = styleManager.getStyleDeclaration(".myFontStyle");
         if(!style)
         {
            style = new CSSStyleDeclaration(selector,styleManager);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.color = 10040319;
               this.fontSize = 15;
            };
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ICommand() : Label
      {
         return this._991183554ICommand;
      }
      
      public function set ICommand(param1:Label) : void
      {
         var _loc2_:Object = this._991183554ICommand;
         if(_loc2_ !== param1)
         {
            this._991183554ICommand = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ICommand",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ms() : Label
      {
         return this._3494ms;
      }
      
      public function set ms(param1:Label) : void
      {
         var _loc2_:Object = this._3494ms;
         if(_loc2_ !== param1)
         {
            this._3494ms = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ms",_loc2_,param1));
            }
         }
      }
   }
}

