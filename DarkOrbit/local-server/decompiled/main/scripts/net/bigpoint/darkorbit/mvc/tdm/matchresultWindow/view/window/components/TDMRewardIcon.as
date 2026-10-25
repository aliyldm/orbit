package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components
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
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOHtmlTooltip;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.tooltip.TDMResultWindowToolTipContainer;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardsModel;
   import spark.components.SkinnableContainer;
   
   public class TDMRewardIcon extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _836092443_rewards:TDMRewardsModel;
      
      private var _tooltip:TDMResultWindowToolTipContainer;
      
      public function TDMRewardIcon()
      {
         super();
         mx_internal::_document = this;
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this.enabled = true;
         this.toolTip = " ";
         this.useHandCursor = true;
         this.buttonMode = true;
         this.styleName = "tdmToolTip";
         this.addEventListener("toolTipCreate",this.___TDMRewardIcon_SkinnableContainer1_toolTipCreate);
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.skinClass = TDMRewardIconSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function set data(param1:Object) : void
      {
         this._rewards = param1 as TDMRewardsModel;
         if(Boolean(this._rewards) && this._rewards.rewardList.length > 0)
         {
            if(this._tooltip)
            {
               this._tooltip.dataProvider = new VectorCollection(this._rewards.rewardList);
            }
         }
      }
      
      private function handleToolTipCreate(param1:ToolTipEvent) : void
      {
         var _loc2_:DOHtmlTooltip = null;
         if(!this._tooltip)
         {
            this._tooltip = new TDMResultWindowToolTipContainer();
         }
         if(Boolean(this._rewards) && this._rewards.rewardList.length > 0)
         {
            this._tooltip.rewards = this._rewards;
            param1.toolTip = this._tooltip;
         }
         else
         {
            _loc2_ = new DOHtmlTooltip();
            _loc2_.htmlText = this._rewards.title;
            param1.toolTip = _loc2_;
         }
      }
      
      public function ___TDMRewardIcon_SkinnableContainer1_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreate(param1);
      }
      
      [Bindable(event="propertyChange")]
      private function get _rewards() : TDMRewardsModel
      {
         return this._836092443_rewards;
      }
      
      private function set _rewards(param1:TDMRewardsModel) : void
      {
         var _loc2_:Object = this._836092443_rewards;
         if(_loc2_ !== param1)
         {
            this._836092443_rewards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_rewards",_loc2_,param1));
            }
         }
      }
   }
}

