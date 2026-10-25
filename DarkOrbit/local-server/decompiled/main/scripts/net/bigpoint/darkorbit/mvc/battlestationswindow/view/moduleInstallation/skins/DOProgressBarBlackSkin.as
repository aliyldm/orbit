package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.skins
{
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   
   public class DOProgressBarBlackSkin extends SparkSkin
   {
      
      private var _1743770798bitmapFill:SolidColor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function DOProgressBarBlackSkin()
      {
         super();
         mx_internal::_document = this;
         this.name = "DOCustomProgressBarSkin";
         this.mxmlContent = [this._DOProgressBarBlackSkin_Rect1_c()];
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
      
      override protected function initializationComplete() : void
      {
         super.initializationComplete();
      }
      
      private function _DOProgressBarBlackSkin_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 2;
         _loc1_.right = 2;
         _loc1_.top = 2;
         _loc1_.bottom = 2;
         _loc1_.fill = this._DOProgressBarBlackSkin_SolidColor1_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _DOProgressBarBlackSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.55;
         this.bitmapFill = _loc1_;
         BindingManager.executeBindings(this,"bitmapFill",this.bitmapFill);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get bitmapFill() : SolidColor
      {
         return this._1743770798bitmapFill;
      }
      
      public function set bitmapFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1743770798bitmapFill;
         if(_loc2_ !== param1)
         {
            this._1743770798bitmapFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bitmapFill",_loc2_,param1));
            }
         }
      }
   }
}

