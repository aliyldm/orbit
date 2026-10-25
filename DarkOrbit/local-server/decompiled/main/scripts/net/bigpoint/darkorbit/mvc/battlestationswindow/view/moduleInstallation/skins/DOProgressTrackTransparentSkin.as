package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.skins
{
   import mx.core.IFlexModuleFactory;
   import mx.graphics.SolidColor;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   
   public class DOProgressTrackTransparentSkin extends SparkSkin
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function DOProgressTrackTransparentSkin()
      {
         super();
         mx_internal::_document = this;
         this.name = "DOCustomProgressBarSkin";
         this.mxmlContent = [this._DOProgressTrackTransparentSkin_Rect1_c()];
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
      
      private function _DOProgressTrackTransparentSkin_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.height = 2;
         _loc1_.alpha = 0;
         _loc1_.fill = this._DOProgressTrackTransparentSkin_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _DOProgressTrackTransparentSkin_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
   }
}

