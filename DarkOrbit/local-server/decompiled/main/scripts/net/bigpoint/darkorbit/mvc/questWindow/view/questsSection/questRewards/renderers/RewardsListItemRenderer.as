package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questRewards.renderers
{
   import com.bigpoint.utils.TextFormatter;
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
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.RewardVO;
   import spark.components.supportClasses.ItemRenderer;
   
   use namespace mx_internal;
   
   public class RewardsListItemRenderer extends ItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public static const LAYOUT_CHANGED:String = "layoutChanged";
      
      private var _2113160650rendererContent:RewardsListItemRendererContent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RewardsListItemRenderer()
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
         bindings = this._RewardsListItemRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_questRewards_renderers_RewardsListItemRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return RewardsListItemRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.autoDrawBackground = false;
         this.mxmlContent = [this._RewardsListItemRenderer_RewardsListItemRendererContent1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RewardsListItemRenderer._watcherSetupUtil = param1;
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
      private function get rewardData() : RewardVO
      {
         this.rendererContent.rewardNameLabel.addEventListener(Event.RESIZE,this.labelResizedHandler);
         return data as RewardVO;
      }
      
      private function labelResizedHandler(param1:Event) : void
      {
         dispatchEvent(new Event(RewardsListItemRenderer.LAYOUT_CHANGED,true));
      }
      
      private function getRewardName(param1:RewardVO) : String
      {
         if(param1 == null)
         {
            return "";
         }
         return param1.lootId.indexOf("title_title") >= 0 ? BPLocale.getItemInCategory("achievements","label_achievement_titles") : BPLocale.getItemInCategory("items","items_" + param1.lootId.toString() + "_fullname");
      }
      
      private function getRewardAmt(param1:RewardVO) : String
      {
         if(param1 == null)
         {
            return "0";
         }
         return param1.lootId.indexOf("title_title") >= 0 ? BPLocale.getItemInCategory("achievements",param1.modifier) : TextFormatter.roundInteger(param1.amount);
      }
      
      private function _RewardsListItemRenderer_RewardsListItemRendererContent1_i() : RewardsListItemRendererContent
      {
         var _loc1_:RewardsListItemRendererContent = new RewardsListItemRendererContent();
         _loc1_.id = "rendererContent";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rendererContent = _loc1_;
         BindingManager.executeBindings(this,"rendererContent",this.rendererContent);
         return _loc1_;
      }
      
      private function _RewardsListItemRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getRewardName(rewardData);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"rendererContent.rewardName");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getRewardAmt(rewardData);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"rendererContent.amountStr");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get rendererContent() : RewardsListItemRendererContent
      {
         return this._2113160650rendererContent;
      }
      
      public function set rendererContent(param1:RewardsListItemRendererContent) : void
      {
         var _loc2_:Object = this._2113160650rendererContent;
         if(_loc2_ !== param1)
         {
            this._2113160650rendererContent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rendererContent",_loc2_,param1));
            }
         }
      }
   }
}

