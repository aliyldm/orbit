package net.bigpoint.darkorbit.map.view2D.display.uber
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IStateAware;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.display.DisplayObjectsBuilder;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.model.ViewCreateDTO;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.viewBuilder.view.IAnimatedViewContainer;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UberMapAssetView2D extends Sprite implements IDisposable, IStateAware
   {
      
      public const ready:ISignal = new Signal();
      
      private var _view:IAnimatedViewContainer;
      
      private var _includeIn:Vector.<String>;
      
      private var _descriptor:XML;
      
      public function UberMapAssetView2D(param1:XML)
      {
         super();
         this._descriptor = param1;
         if(this._descriptor.attribute("includeIn").length() > 0)
         {
            this._includeIn = Vector.<String>(String(this._descriptor.@includeIn).split(","));
         }
      }
      
      public function init() : void
      {
         var _loc1_:String = null;
         var _loc2_:XML = null;
         if(String(this._descriptor.@descriptorResKey).length > 0)
         {
            _loc1_ = String(this._descriptor.@descriptorResKey);
         }
         else
         {
            _loc2_ = this._descriptor;
         }
         GameFacade.getInstance().sendNotification(MapAssetNotification.LOAD_MAPASSET_VIEW,new ViewCreateDTO(_loc1_,this.initView,DisplayObjectsBuilder.flashViewBuilder,_loc2_));
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._view)
         {
            removeChild(this._view.view as DisplayObject);
            this._view.dispose();
            this._view = null;
         }
         Settings.autoQualityReduction.changed.remove(this.updateDescriptorQualities);
      }
      
      private function initView(param1:IAnimatedViewContainer) : void
      {
         this._view = param1;
         addChild(this._view.view as DisplayObject);
         Settings.autoQualityReduction.changed.add(this.updateDescriptorQualities);
         this.updateDescriptorQualities();
         setTimeout(this.ready.dispatch,1);
      }
      
      private function updateDescriptorQualities() : void
      {
         if(this._view)
         {
            this._view.userQuality = Settings.qualityBackground.value;
            this._view.reductionLevel = Settings.autoQualityReduction.value;
         }
      }
      
      public function handleStateChange(param1:String) : void
      {
         visible = this._includeIn == null || this._includeIn.indexOf(param1) != -1;
      }
      
      public function get view() : IAnimatedViewContainer
      {
         return this._view;
      }
   }
}

