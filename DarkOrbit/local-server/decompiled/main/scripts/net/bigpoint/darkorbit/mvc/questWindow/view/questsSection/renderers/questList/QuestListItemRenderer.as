package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.renderers.questList
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
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestListItemVO;
   import spark.components.supportClasses.ItemRenderer;
   
   use namespace mx_internal;
   
   public class QuestListItemRenderer extends ItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _951530617content:QuestListItemRendererContent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function QuestListItemRenderer()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._QuestListItemRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_renderers_questList_QuestListItemRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return QuestListItemRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._QuestListItemRenderer_QuestListItemRendererContent1_i()];
         this.addEventListener("removedFromStage",this.___QuestListItemRenderer_ItemRenderer1_removedFromStage);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         QuestListItemRenderer._watcherSetupUtil = param1;
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
      
      [Bindable(event="dataChange")]
      private function get questListItemVO() : QuestListItemVO
      {
         return data as QuestListItemVO;
      }
      
      override public function set data(param1:Object) : void
      {
         this.removeListeners();
         super.data = param1;
         this.addListeners();
      }
      
      private function handleChanged() : void
      {
         this.content.questListItemVO = this.questListItemVO;
      }
      
      private function addListeners() : void
      {
         if(this.questListItemVO)
         {
            this.questListItemVO.changed.add(this.handleChanged);
         }
      }
      
      private function removeListeners() : void
      {
         if(this.questListItemVO)
         {
            this.questListItemVO.changed.remove(this.handleChanged);
         }
      }
      
      private function _QuestListItemRenderer_QuestListItemRendererContent1_i() : QuestListItemRendererContent
      {
         var _loc1_:QuestListItemRendererContent = new QuestListItemRendererContent();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.id = "content";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.content = _loc1_;
         BindingManager.executeBindings(this,"content",this.content);
         return _loc1_;
      }
      
      public function ___QuestListItemRenderer_ItemRenderer1_removedFromStage(param1:Event) : void
      {
         this.removeListeners();
      }
      
      private function _QuestListItemRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():QuestListItemVO
         {
            return questListItemVO;
         },null,"content.questListItemVO");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get content() : QuestListItemRendererContent
      {
         return this._951530617content;
      }
      
      public function set content(param1:QuestListItemRendererContent) : void
      {
         var _loc2_:Object = this._951530617content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
            }
         }
      }
   }
}

